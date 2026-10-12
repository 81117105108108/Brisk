--!strict
--!native
--!optimize 2

-- Compiles declarative table definitions, literals, unions, and custom types
-- into optimized, low-overhead schemas consumable by the serialization engine.

local Enums = require(script.Parent.Enums)
local EnumsToNative = require(script.Parent.EnumsToNativeTypes)
local Types = require(script.Parent.Types)

export type SchemaArg = Types.SchemaArg
export type Literal = Types.Literal

local SOURCE = "[Brisk]"

local function keyValueSwap<K, V>(tbl: { [K]: V }): { [V]: K }
	local new: { [V]: K } = {}
	for k, v in tbl do
		new[v] = k
	end
	return table.freeze(new)
end

local reverseEnums: { [number]: string } = keyValueSwap(Enums)

local fastPaths = table.freeze({
	Array = table.freeze({
		[Enums.NumberU4] = Enums.FastNumberU4Array,
		[Enums.NumberU8] = Enums.FastNumberU8Array,
		[Enums.NumberI32] = Enums.FastNumberI32Array,
		[Enums.NumberF32] = Enums.FastNumberF32Array,
		[Enums.Boolean] = Enums.FastBoolArray,
		[Enums.String] = Enums.FastStringArray,
	}),

	DictStatic = table.freeze({
		[Enums.NumberU4] = Enums.FastNumberU8DictStatic,
		[Enums.NumberU8] = Enums.FastNumberU8DictStatic,
		[Enums.NumberI32] = Enums.FastNumberI32DictStatic,
		[Enums.NumberF32] = Enums.FastNumberF32DictStatic,
		[Enums.Boolean] = Enums.FastBoolDictStatic,
		[Enums.String] = Enums.FastStringDictStatic,
	}),

	Dict = table.freeze({
		[Enums.NumberU4] = Enums.FastNumberU8Dict,
		[Enums.NumberU8] = Enums.FastNumberU8Dict,
		[Enums.NumberI32] = Enums.FastNumberI32Dict,
		[Enums.NumberF32] = Enums.FastNumberF32Dict,
		[Enums.Boolean] = Enums.FastBoolDict,
		[Enums.String] = Enums.FastStringDict,
	}),
})

-- Forward declaration for recursive compilation
local processSchema: (schema: any) -> any

-- Compares elements for homogeneous primitive type array/struct fast-paths
@native
local function checkSameTypes(data: { any }): (boolean, any?)
	local len = #data
	if len == 0 then
		return false, nil
	end

	local first = data[1]
	for i = 2, len do
		if data[i] ~= first then
			return false, first
		end
	end

	return true, first
end

-- Deterministic key comparator ensuring client and server maintain identical struct byte orders
@native
local function sortKeysComparator(a: any, b: any): boolean
	local aType = type(a)
	local bType = type(b)

	if aType ~= bType then
		return aType < bType
	end

	return a < b
end

-- ============================================================================
-- SCHEMA CONSTRUCTORS
-- ============================================================================

local function arrayStatic(data: { any }): { any }
	local processed = table.create(#data)
	for i = 1, #data do
		processed[i] = processSchema(data[i])
	end

	local sameTypes, dataType = checkSameTypes(processed)
	local fastPath = if sameTypes and dataType ~= nil then fastPaths.Array[dataType] else nil

	return {
		[1] = Enums.ArrayStatic,
		[2] = processed,
		[3] = fastPath,
	}
end

local function array<T>(data: { T } | T): { any }
	local rawType = if type(data) == "table" and (data :: any)[1] ~= nil then (data :: any)[1] else data
	if rawType == nil then
		error(`{SOURCE} array must specify an element type`, 2)
	end

	if rawType == Enums.Any then
		return {
			[1] = Enums.ArrayDynamic,
		}
	end

	local innerData = processSchema(rawType)
	local fastPath = fastPaths.Array[innerData]

	-- Automatically activate bulk struct-array fast path when element is a static struct
	if type(innerData) == "table" and innerData[1] == Enums.DictStatic then
		fastPath = Enums.FastStructArray
	end

	return {
		[1] = Enums.Array,
		[2] = innerData,
		[3] = fastPath,
	}
end

local function arrayDynamic(): { any }
	return {
		[1] = Enums.ArrayDynamic,
	}
end

local dictCounter = 0
@native
local function getDictId(): number
	dictCounter += 1
	return dictCounter
end

local function dictStatic(data: { [string | number]: any }): { any }
	local keyCount = 0
	for _ in data do
		keyCount += 1
	end

	if keyCount == 0 then
		error(`{SOURCE} static struct cannot be empty`, 2)
	end

	local keys = table.create(keyCount)
	local idx = 0
	for key in data do
		idx += 1
		keys[idx] = key
	end

	table.sort(keys, sortKeysComparator)

	local vals = table.create(keyCount)
	local template = {}

	for i = 1, keyCount do
		local key = keys[i]
		vals[i] = processSchema(data[key])
		template[key] = false -- Pre-allocate shape and hash capacity
	end

	local sameTypes, dataType = checkSameTypes(vals)
	local fastPath = if sameTypes and dataType ~= nil then fastPaths.DictStatic[dataType] else nil

	return {
		[1] = Enums.DictStatic,
		[2] = vals,
		[3] = keys,
		[4] = template,
		[5] = fastPath,
	}
end

local function dict<K, V>(data: { [K]: V } | (K, V)): { any }
	local keyType: any
	local valType: any

	if type(data) == "table" then
		local k, v = next(data :: { [K]: V })
		if k == nil then
			error(`{SOURCE} map dictionary cannot be empty`, 2)
		end
		keyType = k
		valType = v
	else
		error(`{SOURCE} invalid arguments passed to dict constructor`, 2)
	end

	if keyType == Enums.Any and valType == Enums.Any then
		return {
			[1] = Enums.DictDynamic,
		}
	end

	local innerKey = processSchema(keyType)
	local innerVal = processSchema(valType)

	local keyFastPath = if type(innerKey) == "number" then fastPaths.Dict[innerKey] else nil
	local valFastPath = if type(innerVal) == "number" then fastPaths.Dict[innerVal] else nil

	-- Automatically activate bulk struct-dict fast path when values are static structs
	if type(innerVal) == "table" and innerVal[1] == Enums.DictStatic then
		valFastPath = Enums.FastStructDict
	end

	return {
		[1] = Enums.Dict,
		[2] = innerKey,
		[3] = innerVal,
		[4] = keyFastPath,
		[5] = valFastPath,
		[6] = getDictId(),
	}
end

local function dictDynamic(): { any }
	return {
		[1] = Enums.DictDynamic,
	}
end

local function optional<T>(dataType: T): { any }
	if dataType == nil then
		error(`{SOURCE} input to optional cannot be nil`, 2)
	end

	return {
		[1] = Enums.Optional,
		[2] = processSchema(dataType),
	}
end

local function buildUnion(branches: { any }): { [any]: any }
	if #branches < 2 then
		error(`{SOURCE} union must contain at least 2 types`, 2)
	end

	local unionSchema: { [any]: any } = {
		[1] = Enums.Union,
	}

	for _, rawBranch in branches do
		local branch = processSchema(rawBranch)
		local isTable = type(branch) == "table"

		if isTable then
			local enumTag = branch[1]
			if enumTag == Enums.Optional then
				error(`{SOURCE} optional type cannot be unioned`, 2)
			elseif enumTag == Enums.Any then
				error(`{SOURCE} Any type cannot be unioned`, 2)
			elseif enumTag == Enums.Literal then
				error(`{SOURCE} literal types cannot be unioned`, 2)
			elseif enumTag == Enums.Union then
				error(`{SOURCE} cannot nest a union directly inside another union`, 2)
			end

			if unionSchema.table ~= nil then
				error(`{SOURCE} cannot union multiple table types (cannot discriminate at runtime)`, 2)
			end

			unionSchema.table = branch
			unionSchema[enumTag] = branch
		else
			local native = EnumsToNative[branch]
			if not native then
				error(`{SOURCE} invalid union type enum '{tostring(branch)}'`, 2)
			end

			if unionSchema[native] ~= nil then
				error(`{SOURCE} cannot union multiple types of the same native type '{native}'`, 2)
			end

			unionSchema[native] = branch
			unionSchema[branch] = branch
		end
	end

	return unionSchema
end

local function union<T1, T2>(data1: T1, data2: T2): any
	return buildUnion({ data1, data2 })
end

local function unionMany(...: any): any
	return buildUnion({ ... })
end

local function literal(...: any): { any }
	local map = { ... }
	local count = #map

	if count == 0 then
		error(`{SOURCE} literal must have at least one value`, 2)
	end

	if count > 255 then
		error(`{SOURCE} literal cannot have more than 255 values (exceeds u8 wire index)`, 2)
	end

	local reverseMap: { [any]: number } = {}
	for i = 1, count do
		local val = map[i]
		local dt = typeof(val)
		if dt ~= "string" and dt ~= "number" and dt ~= "boolean" and dt ~= "Vector3" then
			error(`{SOURCE} unsupported literal type: '{dt}'`, 2)
		end

		if reverseMap[val] ~= nil then
			error(`{SOURCE} duplicate literal value '{tostring(val)}'`, 2)
		end

		reverseMap[val] = i
	end

	return {
		[1] = Enums.Literal,
		[2] = map,
		[3] = reverseMap,
	}
end

local function custom(
	encode: (buff: buffer, offset: number, value: any, instances: { Instance }, metadata: any) -> number,
	decode: (buff: buffer, offset: number, instances: { Instance }?, metadata: any) -> (any, number),
	metadata: any
): { any }
	if type(encode) ~= "function" then
		error(`{SOURCE} First argument to custom() must be an encode function`, 2)
	end

	if type(decode) ~= "function" then
		error(`{SOURCE} Second argument to custom() must be a decode function`, 2)
	end

	return {
		[1] = Enums.Custom,
		[2] = encode,
		[3] = decode,
		[4] = metadata,
	}
end

-- ============================================================================
-- SCHEMA RECURSIVE COMPILER & NORMALIZER
-- ============================================================================

local COMPILED_TAGS = table.freeze({
	[Enums.Array] = true,
	[Enums.ArrayStatic] = true,
	[Enums.ArrayDynamic] = true,
	[Enums.Dict] = true,
	[Enums.DictStatic] = true,
	[Enums.DictDynamic] = true,
	[Enums.Optional] = true,
	[Enums.Union] = true,
	[Enums.Literal] = true,
	[Enums.Custom] = true,
})

processSchema = function(schema: any): any
	-- Primitive Enum validation
	if type(schema) ~= "table" then
		if not reverseEnums[schema] then
			error(`{SOURCE} invalid data type enum: {tostring(schema)}`, 2)
		end
		return schema
	end

	local tag = schema[1]

	-- Idempotency: bypass recompiling already-processed schemas
	if COMPILED_TAGS[tag] then
		if tag == Enums.Optional then
			schema[2] = processSchema(schema[2])
		elseif tag == Enums.ArrayStatic then
			for i, v in schema[2] do
				schema[2][i] = processSchema(v)
			end
		end
		return schema
	end

	-- Analyze table morphology
	local count = 0
	local isArrayStatic = true
	local firstKey = nil

	for k in schema do
		count += 1
		if count == 1 then
			firstKey = k
		end
		if k ~= count then
			isArrayStatic = false
		end
	end

	if count == 0 or firstKey == nil then
		error(`{SOURCE} Empty table is not a valid schema definition`, 2)
	end

	-- Morphological Classification
	if count == 1 then
		if firstKey == 1 then
			-- Sequential 1-element table: dynamic list `{ Enums.NumberU32 }`
			return array(schema)
		elseif reverseEnums[firstKey] ~= nil or firstKey == Enums.Any then
			-- Key is a type enum: map dictionary `{ [Enums.String] = Enums.NumberU32 }`
			return dict(schema)
		else
			-- Key is a string field name: single-field struct `{ name = Enums.String }`
			return dictStatic(schema)
		end
	elseif isArrayStatic then
		-- Multi-element sequential array: fixed tuple `{ Enums.NumberU32, Enums.String }`
		return arrayStatic(schema)
	else
		-- Multi-element non-sequential table: static struct `{ x = Enums.F32, y = Enums.F32 }`
		return dictStatic(schema)
	end
end

local function compileSchema(...: any): any
	local count = select("#", ...)
	if count == 0 then
		error(`{SOURCE} compileSchema requires at least one argument`, 2)
	end

	if count == 1 then
		return processSchema((...))
	end

	local compiled = table.create(count)
	for i = 1, count do
		compiled[i] = processSchema(select(i, ...))
	end

	return compiled
end

local Parser = table.freeze({
	-- Primary Compilation
	compile = compileSchema,
	getSchema = compileSchema, -- Backwards compatibility alias

	-- Explicit Type Constructors
	array = array,
	arrayStatic = arrayStatic,
	arrayDynamic = arrayDynamic,
	dict = dict,
	dictStatic = dictStatic,
	dictDynamic = dictDynamic,
	optional = optional,
	union = union,
	unionMany = unionMany,
	literal = literal,
	custom = custom,

	-- Reflection
	fastPaths = fastPaths,
})

return Parser
