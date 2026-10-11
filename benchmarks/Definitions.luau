local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local isServer = RunService:IsServer()

local QuickNet = require(ReplicatedStorage.QuickNet)
local Packet = require(ReplicatedStorage.Packet)
local ByteNet = require(ReplicatedStorage.ByteNet)
local Jolt = require(ReplicatedStorage.Jolt)
local blinkFolder = ReplicatedStorage.Blink
local Blink = isServer and require(blinkFolder.Server) or require(blinkFolder.Client)
local NetRay = isServer and require(ReplicatedStorage.NetRay.Server) or require(ReplicatedStorage.NetRay.Client)
local Lync = require(ReplicatedStorage.Lync)

local env = isServer and "Server" or "Client"
local remote = ReplicatedStorage:WaitForChild("BenchmarkRemote")
local remoteFunction = ReplicatedStorage:WaitForChild("BenchmarkRemoteFunction")
local data = QuickNet.Data

local module = {
	bool1 = QuickNet:register("BoolTest", {data.Boolean}):SetRateLimit(1000000000, 30),
	
	bool2 = Packet("BoolTest", {Packet.Boolean8}),
	
	bool3 = remote,
	
	bool4 = ByteNet.defineNamespace("BoolTest", function()
		return {
			BoolTest = ByteNet.definePacket({
				value = ByteNet.array(ByteNet.bool),
			})
		}
	end),
	
	bool5 = Jolt[env]("BoolTest"),
	
	bool6 = Blink.Booleans,
	
	bool7 = NetRay.Booleans,
	
	bool8 = Lync.define("BoolTest", {
		Booleans = Lync.packet(Lync.array(Lync.bool(), 0, 1000)),
	}),
	
	entities1 = QuickNet:register("EntitiesTest",
		{
			{
				id = data.NumberU8,
				x = data.NumberU8,
				y = data.NumberU8,
				z = data.NumberU8,
				orientation = data.NumberU8,
				animation = data.NumberU8,
			}
		}):SetRateLimit(1000000000, 30),
	
	--entities1 = QuickNet:register("EntitiesTest", data.custom(
	--	@native function(buff, offset, value, inst, metadata)
	--		buffer.writeu8(buff, offset, #value)
	--		local ptr = offset + 1
			
	--		for _, struct in value do
	--			buffer.writeu8(buff, ptr, struct.id)
	--			buffer.writeu8(buff, ptr + 1, struct.x)
	--			buffer.writeu8(buff, ptr + 2, struct.y)
	--			buffer.writeu8(buff, ptr + 3, struct.z)
	--			buffer.writeu8(buff, ptr + 4, struct.orientation)
	--			buffer.writeu8(buff, ptr + 5, struct.animation)
	--			ptr += 6
	--		end
	--		return ptr - offset
	--	end,
		
	--	@native function(buff, offset, inst, metadata)
	--		local len = buffer.readu8(buff, offset)
	--		local ptr = offset + 1
	--		local array = table.create(len)
			
	--		for i = 1, len do
	--			array[i] = {
	--				id = buffer.readu8(buff, ptr),
	--				x = buffer.readu8(buff, ptr + 1),
	--				y = buffer.readu8(buff, ptr + 2),
	--				z = buffer.readu8(buff, ptr + 3),
	--				orientation = buffer.readu8(buff, ptr + 4),
	--				animation = buffer.readu8(buff, ptr + 5),
	--			}
	--			ptr += 6
	--		end
	--		return array, ptr - offset
	--	end,
		
	--	nil
	--	)):SetRateLimit(1000000000, 30),
	
	entities2 = Packet("EntitiesTest", {
		{
			id = Packet.NumberU8, 
			x = Packet.NumberU8, 
			y = Packet.NumberU8,
			z = Packet.NumberU8,
			orientation = Packet.NumberU8,
			animation = Packet.NumberU8,
		}
	}),	
	
	entities3 = remote,
	
	entities4 = ByteNet.defineNamespace("EntitiesTest", function()
		return {
			EntitiesTest = ByteNet.definePacket({
				value = ByteNet.array(ByteNet.struct(
					{
						id = ByteNet.uint8, 
						x = ByteNet.uint8, 
						y = ByteNet.uint8,
						z = ByteNet.uint8,
						orientation = ByteNet.uint8,
						animation = ByteNet.uint8,
					}
					)),
			})
		}
	end),
	
	entities5 = Jolt[env]("EntitiesTest"),
	
	entities6 = Blink.Entities,
	
	entities7 = NetRay.Entities,
	
	entities8 = Lync.define("EntitiesTest", {
		Entities = Lync.packet(Lync.array(Lync.struct({
			id = Lync.int(0, 255),
			x = Lync.int(0, 255),
			y = Lync.int(0, 255),
			z = Lync.int(0, 255),
			orientation = Lync.int(0, 255),
			animation = Lync.int(0, 255),
		}), 0, 100))
	}),
	
	strings1 = QuickNet:register("StringsTest", {data.String}):SetRateLimit(1000000000, 30),
	
	strings2 = Packet("StringsTest", {Packet.String}),
	
	strings3 = remote,
	
	strings4 = ByteNet.defineNamespace("StringsTest", function()
		return {
			StringsTest = ByteNet.definePacket({
				value = ByteNet.array(ByteNet.string),
			})
		}
	end),
	
	strings5 = Jolt[env]("StringsTest"),
	
	strings6 = Blink.Strings,
	
	strings7 = NetRay.Strings,
	
	strings8 = Lync.define("StringsTest", {
		Strings = Lync.packet(Lync.array(Lync.str(0, 50), 0, 500))
	}),
	
	numbers1 = QuickNet:register("NumbersTest", {data.NumberU8}):SetRateLimit(1000000000, 30),
	
	numbers2 = Packet("NumbersTest", {Packet.NumberU8}),
	
	numbers3 = remote,
	
	numbers4 = ByteNet.defineNamespace("NumbersTest", function()
		return {
			NumbersTest = ByteNet.definePacket({
				value = ByteNet.array(ByteNet.uint8),
			})
		}
	end),
	
	numbers5 = Jolt[env]("NumbersTest"),
	
	numbers6 = Blink.Numbers,
	
	numbers7 = NetRay.Numbers,
	
	numbers8 = Lync.define("NumbersTest", {
		Numbers = Lync.packet(Lync.array(Lync.int(0, 255), 0, 2000))
	}),
		
	dict1 = QuickNet:register("DictTest", {[data.String] = data.NumberU8}):SetRateLimit(1000000000, 30),
	
	dict2 = Packet("DictTest", Packet.Any),
	
	dict3 = remote,
	
	dict4 = ByteNet.defineNamespace("DictTest", function()
		return {
			DictTest = ByteNet.definePacket({
				value = ByteNet.map(ByteNet.string, ByteNet.uint8),
			})
		}
	end),
	
	dict5 = Jolt[env]("DictTest"),
	
	dict6 = Blink.Dictionary,
	
	dict7 = NetRay.Dictionary,
	
	dict8 = Lync.define("DictTest", {
		Dict = Lync.packet(Lync.map(Lync.str(0, 50), Lync.int(0, 255), 0, 500))
	}),
		
	vectors1 = QuickNet:register("VectorsTest", {data.Vector3F32}):SetRateLimit(100000000000, 30),
	
	--vectors1 = QuickNet:register("VectorsTest", data.custom(
	--	@native function(buff, offset, value: {Vector3}, inst, metadata): number
	--		buffer.writeu8(buff, offset, #value)
	--		local ptr = offset + 1
			
	--		for _, vec in value do
	--			buffer.writef32(buff, ptr, vec.X)
	--			buffer.writef32(buff, ptr + 4, vec.Y)
	--			buffer.writef32(buff, ptr + 8, vec.Z)
	--			ptr += 12
	--		end
	--		return ptr - offset
	--	end,
		
	--	@native function(buff, offset, inst, metadata): ({Vector3}, number)
	--		local len = buffer.readu8(buff, offset)
	--		local ptr = offset + 1
			
	--		local array = table.create(len)
	--		for i = 1, len do
	--			array[i] = Vector3.new(
	--				buffer.readf32(buff, ptr),
	--				buffer.readf32(buff, ptr + 4),
	--				buffer.readf32(buff, ptr + 8)
	--			)
	--			ptr += 12
	--		end
	--		return array, ptr - offset
	--	end,
		
	--	nil
	--	)):SetRateLimit(1000000000, 30),
	
	vectors2 = Packet("VectorsTest", {Packet.Vector3F32}),
	
	vectors3 = remote,
	
	vectors4 = ByteNet.defineNamespace("VectorsTest", function()
		return {
			VectorsTest = ByteNet.definePacket({
				value = ByteNet.array(ByteNet.vec3),
			})
		}
	end),
	
	vectors5 = Jolt[env]("VectorsTest"),
	
	vectors6 = Blink.Vectors,
	
	vectors7 = nil,
	
	vectors8 = Lync.define("VectorsTest", {
		Vectors = Lync.packet(Lync.array(Lync.vec3(), 0, 100))
	}),
	
	remoteFunction1 = QuickNet:register("RemoteFunctionTest", {data.NumberU8}):Response({data.NumberU8})
		:SetRateLimit(1000000000000, 30),
	
	remoteFunction2 = Blink.RemoteFunction,
	
	remoteFunction3 = NetRay.RemoteFunction,
	
	remoteFunction4 = Jolt[env]("RemoteFunction"),
	
	remoteFunction5 = remoteFunction,
}


Lync.start()
RunService.PostSimulation:Connect(function()
	Lync.flush()
end)

return module
