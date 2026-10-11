local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local Stats = game:GetService("Stats")

local Defs = require(script.Parent.Definitions)
local Modes = require(script.Parent.Modes)

local methods = {
	QuickNet = "FireServer",
	Packet = "Fire",
	RemoteEvent = "FireServer",
	ByteNet = "send",
	Jolt = "Fire",
	Blink = "Fire",
	NetRay = "Fire",
	Lync = "fireServer",
}

local functionMethods = {
	QuickNet = "InvokeServer",
	Blink = "Invoke",
	NetRay = "Call",
	Jolt = "Invoke",
	RemoteFunction = "InvokeServer",
}

local events = {
	QuickNet = {
		Booleans = Defs.bool1,
		Entities = Defs.entities1,
		Strings = Defs.strings1, 
		Numbers = Defs.numbers1,
		Dict = Defs.dict1,
		Instance = Defs.testInst,
		Vectors = Defs.vectors1,
	},

	Packet = {
		Booleans = Defs.bool2,
		Entities = Defs.entities2,
		Strings = Defs.strings2,
		Numbers = Defs.numbers2,
		Dict = Defs.dict2,
		Vectors = Defs.vectors2,
	},

	RemoteEvent = {
		Booleans = Defs.bool3,
		Entities = Defs.entities3,
		Strings = Defs.strings3,
		Numbers = Defs.numbers3,
		Dict = Defs.dict3,
		Vectors = Defs.vectors3,	
	},

	ByteNet = {
		Booleans = Defs.bool4.BoolTest,
		Entities = Defs.entities4.EntitiesTest,
		Strings = Defs.strings4.StringsTest,
		Numbers = Defs.numbers4.NumbersTest,
		Dict = Defs.dict4.DictTest,
		Vectors = Defs.vectors4.VectorsTest,
	},
	
	Jolt = {
		Booleans = Defs.bool5,
		Entities = Defs.entities5,
		Strings = Defs.strings5,
		Numbers = Defs.numbers5,
		Dict = Defs.dict5,
		Vectors = Defs.vectors5,
	},
	
	Blink = {
		Booleans = Defs.bool6,
		Entities = Defs.entities6,
		Strings = Defs.strings6,
		Numbers = Defs.numbers6,
		Dict = Defs.dict6,
		Vectors = Defs.vectors6,
	},
	
	NetRay = {
		Booleans = Defs.bool7,
		Entities = Defs.entities7,
		Strings = Defs.strings7,
		Numbers = Defs.numbers7,
		Dict = Defs.dict7,
		Vectors = Defs.vectors7,
	},
	
	Lync = {
		Booleans = Defs.bool8.Booleans,
		Entities = Defs.entities8.Entities,
		Strings = Defs.strings8.Strings,
		Numbers = Defs.numbers8.Numbers,
		Dict = Defs.dict8.Dict,
		Vectors = Defs.vectors8.Vectors,
	}
}

local functions = {
	QuickNet = {
		RemoteFunction = Defs.remoteFunction1,
	},
	
	Blink = {
		RemoteFunction = Defs.remoteFunction2,
	},
	
	NetRay = {
		RemoteFunction = Defs.remoteFunction3,
	},
	
	Jolt = {
		RemoteFunction = Defs.remoteFunction4,
	},
	
	RemoteFunction = {
		RemoteFunction = Defs.remoteFunction5,
	}
}

local function getBooleansData(count: number)
	local booleans = table.create(count)
	for i = 1, count do
		booleans[i] = math.random() > .5 and true or false
	end
	return booleans
end

local function getEntitiesData(count: number)
	local array = table.create(count)
	for i = 1, count do
		array[i] = {
			id = math.random(1, 255),
			x = math.random(1, 255),
			y = math.random(1, 255),
			z = math.random(1, 255),
			orientation = math.random(1, 255),
			animation = math.random(1, 255),
			}
	end
	return array
end

local function getStringsData(count: number, strLen: number?)
	local chars = "abcdefghijklmnopqrstuvwxyz"
	strLen = strLen or 8
	
	local strings = table.create(count)
	for i = 1, count do
		local str = ""
		for j = 1, strLen do
			local random = math.random(1, 26)
			str = str..string.sub(chars, random, random)
		end
		strings[i] = str
	end
	return strings
end

local function getNumbersData(amount: number)
	local nums = {}
	for i = 1, amount do
		nums[i] = math.random(0, 255)
	end
	return nums
end

local function getDictData(count: number)
	local dict = {}
	for i = 1, count do
		local key = "Key"..i
		dict[key] = math.random(0, 255)
	end
	return dict
end

local function getVectorsData(count: number)
	local vectors = table.create(count)
	for i = 1, count do
		vectors[i] = Vector3.new(math.random() * 100, math.random() * 100, math.random() * 100)
	end
	return vectors
end

local testData = {
	Booleans = getBooleansData(1000),
	Entities = getEntitiesData(100),
	Strings = getStringsData(300, 8),
	Numbers = getNumbersData(1000),
	Dict = getDictData(200),
	Vectors = getVectorsData(100),
}

--create StringValue
local strVal = Instance.new("StringValue")
strVal.Name = "BenchmarkResults"
strVal.Parent = script.Parent

--dont use deltaTime it doesnt show below 15 fps
local function startTest(networkName: string, testName: string, firesPerFrame: number, duration: number?)
	:(number?, number?)
	duration = duration or 10
	local isByteNet = networkName == "ByteNet"
	local isBlink = networkName == "Blink"
	local isNetRay = networkName == "NetRay"
	if isNetRay and testName == "Vectors" then
		return 0, 0
	end
	local dotCall = isByteNet or isBlink or isNetRay
	local methodName = methods[networkName]
	local event = events[networkName][testName]
	local fire = event[methodName]
	local data = testData[testName]	


	local numFrames = 0
	local timePassed = 0
	local timestamp
	local kbps = 0

	local conn
	conn = RunService.PostSimulation:Connect(function()
		if dotCall then
			for i = 1, firesPerFrame do
				fire(data)
			end
		else
			for i = 1, firesPerFrame do
				fire(event, data)
			end
		end

		local now = os.clock()
		if timestamp then
			numFrames += 1
			timePassed += now - timestamp
			kbps += Stats.DataSendKbps
		end
			timestamp = now
	end)
	
	task.wait(duration)
	conn:Disconnect()
	if timePassed == 0 then
		timePassed = 1e-6
	end
	local avgFps = numFrames/timePassed
	--scale kbps by 60/fps, more fps will send packets more often
	local avgKbps = (60 / avgFps) * kbps / numFrames
	print(string.format("\n[%s] [%s] \nAverage FPS: %.3f \nAverage Kbps: %.3f", 
			networkName, testName, avgFps, avgKbps))
	return avgFps, avgKbps
end

local function startFunction(networkName: string, testName: string, firesPerFrame: number, duration: number?)
	:(number?, number?)
	duration = duration or 20
	local methodName = functionMethods[networkName]
	local func = functions[networkName][testName]
	local invoke = func[methodName]
	local data = getNumbersData(500)
	local isBlink = networkName == "Blink"
	local isNetRay = networkName == "NetRay"
	local dotCall = isBlink or isNetRay

	local numFrames = 0
	local timePassed = 0
	local timestamp
	local sendKbps = 0
	
	local conn
	conn = RunService.PostSimulation:Connect(function()
		if dotCall then
			for i = 1, firesPerFrame do
				task.spawn(invoke, data)
			end
		else
			for i = 1, firesPerFrame do
				task.spawn(invoke, func, data)
			end
		end

		local now = os.clock()
		if timestamp then
			numFrames += 1
			timePassed += now - timestamp
			sendKbps += Stats.DataSendKbps
		end
		timestamp = now
	end)
	
	task.wait(duration)
	conn:Disconnect()
	local avgFps = numFrames / timePassed
	--scale kbps by 60/fps, more fps will send packets more often
	local avgSendKbps = (60 / avgFps) * sendKbps / numFrames
	print(string.format("\n[%s] [%s] \nAverage FPS: %.3f \nAverage Send: %.3f", 
		networkName, testName, avgFps, avgSendKbps))
	
end

local function roundToDecimal(num: number, decimal: number): number
	local factor = 10^decimal
	return math.round(num * factor)/factor
end

local testNames = {"Booleans", "Entities", "Strings", "Numbers", "Dict", "Vectors"}

local function runAll(firesPerFrame: number, duration: number?)
	local results = {}
	local networkNames = Modes.Enabled
	for _, network in networkNames do
		print("====Benchmarking "..network.."====")
		local result = {}
		results[network] = result
		for _, test in testNames do
			task.wait(7)
			print("Starting test: "..test)
			local fps, kbps = startTest(network, test, firesPerFrame, duration)
			result[test] = {fps = roundToDecimal(fps, 3), kbps = roundToDecimal(kbps, 3)}
		end
	end
	local finalResult = HttpService:JSONEncode(results)
	strVal.Value = finalResult
	print("Saved results in Benchmarks.BenchmarkResults")
end

return {
	start = startTest,
	startFunction = startFunction,
	runAll = runAll,
}




