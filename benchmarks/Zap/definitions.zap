type Entity = struct {
	id: u8,
	x: u8,
	y: u8,
	z: u8,
	orientation: u8,
	animation: u8
}

event Entities = {
    from: Client,
    type: Reliable,
    call: SingleSync,
    data: Entity[0..1000]
}

event Booleans = {
	from: Client,
	type: Reliable,
	call: SingleSync,
	data: boolean[0..1000],
}

event Strings = {
	from: Client,
	type: Reliable,
	call: SingleSync,
	data: string[0..500],
}

event Numbers = {
	from: Client,
	type: Reliable,
	call: SingleSync,
	data: u8[0..2000],
}

type Dict = map {[string]: u8}

event Dictionary = {
	from: Client,
	type: Reliable,
	call: SingleSync,
	data: Dict,
}

event Vectors = {
	from: Client,
	type: Reliable,
	call: SingleSync,
	data: vector[0..500],
}

funct RemoteFunction = {
    call: Async,
    args: u8[0..500],
    rets: u8[0..500]
}