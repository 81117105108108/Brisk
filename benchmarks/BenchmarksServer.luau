local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remote = Instance.new("RemoteEvent")
remote.Name = "BenchmarkRemote"
remote.Parent = ReplicatedStorage

local remoteFunction = Instance.new("RemoteFunction")
remoteFunction.Name = "BenchmarkRemoteFunction"
remoteFunction.Parent = ReplicatedStorage

local Defs = require(script.Parent.Definitions)

Defs.bool1.OnServerEvent:Connect(function(player, data)
	--print(data)
end)

Defs.bool2.OnServerEvent:Connect(function(player, data)

end)

Defs.bool3.OnServerEvent:Connect(function(player, data)

end)

Defs.bool4.BoolTest.listen(function(data, player)

end)

Defs.bool5:Connect(function(player, data)
	
end)

Defs.bool6.On(function(player, data)
	
end)

Defs.bool7.On(function(player, data)
	
end)

Defs.bool8.Booleans:onServer(function(data, player)

end)

Defs.entities1.OnServerEvent:Connect(function(player, data)

end)

Defs.entities2.OnServerEvent:Connect(function(player, data)

end)

Defs.entities3.OnServerEvent:Connect(function(player, data)

end)

Defs.entities4.EntitiesTest.listen(function(data, player)

end)

Defs.entities5:Connect(function(player, data)
	
end)

Defs.entities6.On(function(player, data)
	
end)


Defs.entities7.On(function(player, data)
	
end)

Defs.entities8.Entities:onServer(function(data, player)
	
end)

Defs.strings1.OnServerEvent:Connect(function(player, data)
	
end)

Defs.strings2.OnServerEvent:Connect(function(player, data)

end)

Defs.strings3.OnServerEvent:Connect(function(player, data)

end)

Defs.strings4.StringsTest.listen(function(data, player)

end)

Defs.strings5:Connect(function(player, data)
	
end)

Defs.strings6.On(function(player, data)
	
end)

Defs.strings7.On(function(player, data)

end)

Defs.strings8.Strings:onServer(function(data, player)
	
end)

Defs.numbers1.OnServerEvent:Connect(function(player, data)
	--print(data)
end)

Defs.numbers2.OnServerEvent:Connect(function(player, data)

end)

Defs.numbers3.OnServerEvent:Connect(function(player, data)

end)

Defs.numbers4.NumbersTest.listen(function(data, player)

end)

Defs.numbers5:Connect(function(player, data)
	
end)

Defs.numbers6.On(function(player, data)
	
end)

Defs.numbers7.On(function(player, data)
	
end)

Defs.numbers8.Numbers:onServer(function(data, player)
	
end)

Defs.dict1.OnServerEvent:Connect(function(player, data)

end)

Defs.dict2.OnServerEvent:Connect(function(player, data)

end)

Defs.dict3.OnServerEvent:Connect(function(player, data)

end)

Defs.dict4.DictTest.listen(function(data, player)

end)

Defs.dict5:Connect(function(player, data)
	
end)

Defs.dict6.On(function(player, data)
	
end)

Defs.dict7.On(function(player, data)
	
end)

Defs.dict8.Dict:onServer(function(data, player)
	
end)

Defs.vectors1.OnServerEvent:Connect(function(player, data)
	
end)

Defs.vectors2.OnServerEvent:Connect(function(player, data)
	
end)

Defs.vectors3.OnServerEvent:Connect(function(player, data)
	
end)

Defs.vectors4.VectorsTest.listen(function(data, player)
	
end)

Defs.vectors5:Connect(function(player, data)
	
end)

Defs.vectors6.On(function(player, data)
	
end)

Defs.vectors8.Vectors:onServer(function(data, player)
	
end)

Defs.remoteFunction1.OnServerInvoke = function(player, data)
	return data
end

Defs.remoteFunction2.On(function(player, data)
	return data
end)

Defs.remoteFunction3.On(function(player, data)
	return data
end)

Defs.remoteFunction4.OnInvoke = function(player, data)
	return data
end

Defs.remoteFunction5.OnServerInvoke = function(player, data)
	return data
end

return nil

