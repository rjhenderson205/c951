--[[
BubbleRob Recovery Controller
Implements frontier-based exploration with thermal anomaly logging.
Referenced by Task 2 report sections C–G.
]]

-- Configuration parameters
local gridResolution = 0.5          -- meters per cell
local revisitDecay = 0.98           -- occupancy decay per tick
local anomalyThreshold = 38.0       -- Celsius
local consecutiveHotReads = 3
local maxSpeed = 1.2
local slowSpeed = 0.6

-- State
local wheelLeft, wheelRight
local proximitySensors = {}
local thermalSensor
local robotBody
local compass
local occupancy = {}
local hotCounter = 0
local frontierTargets = {}
local currentWaypoint = nil
local missionLog = {}

-- Utility functions
local function round(value, step)
    return math.floor((value / step) + 0.5) * step
end

local function getCellKey(position)
    local x = round(position[1], gridResolution)
    local y = round(position[2], gridResolution)
    return string.format("%.1f,%.1f", x, y), x, y
end

local function updateOccupancy(position, occupied)
    local key, x, y = getCellKey(position)
    local cell = occupancy[key] or {prob = 0.5, hot = false, timestamp = sim.getSimulationTime()}
    local alpha = occupied and 0.7 or 0.3
    cell.prob = (cell.prob * (1 - alpha)) + (occupied and alpha or -alpha)
    if cell.prob < 0 then cell.prob = 0 end
    if cell.prob > 1 then cell.prob = 1 end
    cell.timestamp = sim.getSimulationTime()
    occupancy[key] = cell
    return x, y
end

local function decayOccupancy()
    for key, cell in pairs(occupancy) do
        if sim.getSimulationTime() - cell.timestamp > 5 then
            cell.prob = cell.prob * revisitDecay
        end
    end
end

local function logThermalAnomaly(position, temp)
    local key = select(1, getCellKey(position))
    local cell = occupancy[key] or {prob = 0.3, hot = false, timestamp = sim.getSimulationTime()}
    cell.hot = true
    cell.timestamp = sim.getSimulationTime()
    occupancy[key] = cell
    table.insert(missionLog, {
        time = sim.getSimulationTime(),
        type = "thermal",
        temperature = temp,
        position = {x = position[1], y = position[2]}
    })
    sim.addLog(sim.verbosity_infos, string.format("Thermal anomaly logged at %s (%.1f°C)", key, temp))
end

local function collectFrontiers()
    frontierTargets = {}
    for key, cell in pairs(occupancy) do
        if cell.prob < 0.3 then
            -- Identify unknown neighbors
            local coords = {}
            for dx = -1, 1 do
                for dy = -1, 1 do
                    if math.abs(dx) + math.abs(dy) == 1 then
                        local neighborKey = string.format("%.1f,%.1f", tonumber(key:match("([-0-9.]+),")) + dx * gridResolution, tonumber(key:match(",([-0-9.]+)")) + dy * gridResolution)
                        if occupancy[neighborKey] == nil then
                            table.insert(frontierTargets, key)
                            break
                        end
                    end
                end
            end
        end
    end
end

local function chooseWaypoint(robotPos)
    if #frontierTargets == 0 then
        return nil
    end
    local bestKey, bestDist
    for _, key in ipairs(frontierTargets) do
        local x, y = key:match("([-0-9.]+),([-0-9.]+)")
        x = tonumber(x)
        y = tonumber(y)
        local dx = x - robotPos[1]
        local dy = y - robotPos[2]
        local dist = math.sqrt(dx * dx + dy * dy)
        if not bestDist or dist < bestDist then
            bestDist = dist
            bestKey = key
        end
    end
    return bestKey
end

local function goToWaypoint(robotPos, robotOri)
    if currentWaypoint == nil then
        return slowSpeed, slowSpeed
    end
    local wx, wy = currentWaypoint:match("([-0-9.]+),([-0-9.]+)")
    wx = tonumber(wx)
    wy = tonumber(wy)
    local dx = wx - robotPos[1]
    local dy = wy - robotPos[2]
    local distance = math.sqrt(dx * dx + dy * dy)
    if distance < gridResolution * 0.5 then
        currentWaypoint = nil
        return slowSpeed, slowSpeed
    end
    local angleToGoal = math.atan2(dy, dx)
    local heading = robotOri
    local angleError = angleToGoal - heading
    while angleError > math.pi do angleError = angleError - 2 * math.pi end
    while angleError < -math.pi do angleError = angleError + 2 * math.pi end

    local baseSpeed = maxSpeed
    if math.abs(angleError) > math.rad(45) then
        baseSpeed = slowSpeed
    end
    local kP = 1.5
    local turnSpeed = kP * angleError
    local left = baseSpeed - turnSpeed
    local right = baseSpeed + turnSpeed
    return left, right
end

local function transformToWorld(handle, rel)
    local matrix = sim.getObjectMatrix(handle, -1)
    return sim.multiplyVector(matrix, rel)
end

local function readSensors()
    local readings = {}
    for i, sensor in ipairs(proximitySensors) do
        local res, dist, _, detectedPoint = sim.checkProximitySensor(sensor)
        if res > 0 then
            local worldPoint = transformToWorld(sensor, detectedPoint)
            readings[i] = {distance = dist, point = worldPoint}
        else
            readings[i] = nil
        end
    end
    local tempData = sim.readVisionSensor(thermalSensor)
    local temperature = nil
    if tempData and tempData[11] then
        temperature = tempData[11] * 100  -- convert from normalized value to Celsius approximation
    end
    return readings, temperature
end

local function adjustForObstacles(readings)
    local leftMod, rightMod = 1.0, 1.0
    for i, reading in ipairs(readings) do
        if reading and reading.distance < 0.5 then
            if i == 1 then
                leftMod = leftMod * 0.6
            else
                rightMod = rightMod * 0.6
            end
        end
    end
    return leftMod, rightMod
end

local function writeLog()
    local path = sim.getStringParameter(sim.stringparam_app_arg1)
    if path == nil or path == '' then
        path = sim.getStringParameter(sim.stringparam_scene_path) .. "/mission_log.csv"
    end
    local file = io.open(path, "w")
    if not file then
        sim.addLog(sim.verbosity_errors, "Unable to open mission log file for writing.")
        return
    end
    file:write("time,type,temperature,x,y\n")
    for _, entry in ipairs(missionLog) do
        file:write(string.format("%.2f,%s,%.2f,%.2f,%.2f\n", entry.time, entry.type, entry.temperature or 0, entry.position.x, entry.position.y))
    end
    file:close()
end

function sysCall_init()
    wheelLeft = sim.getObjectHandle('bubbleRob_leftMotor')
    wheelRight = sim.getObjectHandle('bubbleRob_rightMotor')
    proximitySensors[1] = sim.getObjectHandle('ultrasonic_front_left')
    proximitySensors[2] = sim.getObjectHandle('ultrasonic_front_right')
    thermalSensor = sim.getObjectHandle('thermal_array')
    compass = sim.getObjectHandle('bubbleRob_compass')
    robotBody = sim.getObjectHandle('bubbleRob')
    sim.addLog(sim.verbosity_infos, 'BubbleRob Recovery controller initialized.')
end

function sysCall_actuation()
    local position = sim.getObjectPosition(robotBody, -1)
    updateOccupancy(position, false)
    decayOccupancy()

    collectFrontiers()
    if currentWaypoint == nil then
        currentWaypoint = chooseWaypoint(position)
        if currentWaypoint then
            sim.addLog(sim.verbosity_debug, 'New waypoint: ' .. currentWaypoint)
        end
    end

    local euler = sim.getObjectOrientation(compass, -1)
    local readings, temperature = readSensors()

    if temperature and temperature > anomalyThreshold then
        hotCounter = hotCounter + 1
        if hotCounter >= consecutiveHotReads then
            logThermalAnomaly(position, temperature)
            hotCounter = 0
        end
    else
        hotCounter = math.max(0, hotCounter - 1)
    end

    for _, reading in ipairs(readings) do
        if reading and reading.point then
            updateOccupancy(reading.point, true)
        end
    end

    local leftSpeed, rightSpeed = goToWaypoint(position, euler[3])
    local leftMod, rightMod = adjustForObstacles(readings)
    sim.setJointTargetVelocity(wheelLeft, leftSpeed * leftMod)
    sim.setJointTargetVelocity(wheelRight, rightSpeed * rightMod)
end

function sysCall_cleanup()
    writeLog()
    sim.addLog(sim.verbosity_infos, 'BubbleRob Recovery mission log written.')
end
