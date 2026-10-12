--!strict

-- 1. SIGNALS & LIFETIME MANAGEMENT

export type Connection = {
	Connected: boolean,
	Disconnect: (self: Connection) -> (),
	Destroy: (self: Connection) -> (), -- Alias for Disconnect for Trove/Maid compatibility
}

-- Fast linked-list node used internally for zero-allocation signal dispatch
export type ConnectionNode<T...> = {
	Callback: ((T...) -> ())?,
	Next: ConnectionNode<T...>?,
	Prev: ConnectionNode<T...>?,
	Connected: boolean,
	IsOnce: boolean,
	IsAsync: boolean,
}

export type Signal<T...> = {
	Connect: (self: Signal<T...>, callback: (T...) -> ()) -> Connection,
	ConnectAsync: (self: Signal<T...>, callback: (T...) -> ()) -> Connection,
	Once: (self: Signal<T...>, callback: (T...) -> ()) -> Connection,
	Wait: (self: Signal<T...>) -> T...,
	Fire: (self: Signal<T...>, T...) -> (),
	Destroy: (self: Signal<T...>) -> (),
}

-- 2. SERIALIZATION & SCHEMAS

export type Literal = string | number | boolean | Vector3

-- Sidecar table for instances replicated across Roblox boundaries.
-- Supports both array indexing and internal offset pointer tracking.
export type InstanceList = {
	pointer: number?,
	[number]: Instance,
}

-- Raw or compiled schema node consumed by the serialization engine
export type SchemaArg = number | { [any]: any }

export type CustomSerializer<T, M = any> = {
	Encode: (buff: buffer, offset: number, value: T, instances: { Instance }, metadata: M) -> number,
	Decode: (buff: buffer, offset: number, instances: InstanceList?, metadata: M) -> (T, number),
	Metadata: M?,
}

-- 3. RATE LIMITING & SECURITY

export type RateLimitConfig = {
	Max: number,
	TimeWindow: number,
}

export type RateLimitState = {
	Count: number,
	ResetTime: number,
}

-- Middleware pipeline for payload sanitization, logging, or authorization
export type Middleware<A...> = (player: Player?, A...) -> boolean

-- 4. NETWORK INVOCATIONS & EVENTS

export type NetworkType = number -- Matches Enums.Reliable, Enums.Unreliable, Enums.Function

export type NetworkFunction<A..., B...> = {
	-- Server-side callbacks (optional before binding)
	OnServerInvoke: ((Player, A...) -> B...)?,
	OnServerInvokeAsync: ((Player, A...) -> B...)?,

	-- Configuration (fluent builder pattern)
	SetRateLimit: (self: NetworkFunction<A..., B...>, max: number, timeWindow: number) -> NetworkFunction<A..., B...>,
	SetResponseTimeout: (self: NetworkFunction<A..., B...>, timeout: number) -> NetworkFunction<A..., B...>,
	SetMiddleware: (self: NetworkFunction<A..., B...>, middleware: Middleware<A...>) -> NetworkFunction<A..., B...>,

	-- Client invocation (yielding)
	InvokeServer: (self: NetworkFunction<A..., B...>, A...) -> B...,
	InvokeServerAsync: (self: NetworkFunction<A..., B...>, A...) -> B...,
}

export type NetworkEvent<A...> = {
	-- Server-side dispatch
	OnServerEvent: Signal<Player, A...>,
	FireClient: (self: NetworkEvent<A...>, player: Player, A...) -> (),
	FireClients: (self: NetworkEvent<A...>, players: { Player }, A...) -> (),
	FireAllClients: (self: NetworkEvent<A...>, A...) -> (),
	FireAllExcept: (self: NetworkEvent<A...>, exclude: Player | { Player }, A...) -> (),

	-- Configuration (fluent builder pattern)
	Response: <B...>(self: NetworkEvent<A...>, responseSchema: SchemaArg) -> NetworkFunction<A..., B...>,
	Unreliable: (self: NetworkEvent<A...>) -> NetworkEvent<A...>,
	SetRateLimit: (self: NetworkEvent<A...>, max: number, timeWindow: number) -> NetworkEvent<A...>,
	SetMiddleware: (self: NetworkEvent<A...>, middleware: Middleware<A...>) -> NetworkEvent<A...>,

	-- Client-side dispatch
	OnClientEvent: Signal<A...>,
	FireServer: (self: NetworkEvent<A...>, A...) -> (),
}

export type NetworkInfo<A..., B...> = {
	Name: string,
	Id: number,
	NetworkType: NetworkType,
	RateLimit: RateLimitConfig,
	SendSchema: SchemaArg,
	ResponseSchema: SchemaArg?,
	Signal: Signal<Player, A...>,
	AsyncSignal: Signal<Player, A...>,
	Object: NetworkEvent<A...> | NetworkFunction<A..., B...>,
	ResponseTimeout: number,
	Middleware: Middleware<A...>?,
}

-- 5. BUFFER QUEUES & TRANSPORT

-- Outgoing packet batching queue for high-density frame aggregation
export type OutgoingQueue = {
	QueueSize: number,
	ByteSize: number,
	Capacity: number,
	Cursor: number,
	Buffer: buffer,
	Instances: InstanceList,
}

-- Inbound packet representation for unified server/client processing
export type IncomingPacket = {
	Buffer: buffer,
	Cursor: number,
	Instances: InstanceList?,
	Player: Player?,
}

return nil
