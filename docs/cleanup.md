---
layout: docs
title: Cleanup
---

## ``Connection``
Connection objects can be used to clean up network connections.

### ``.Connected``
A read-only boolean property that indicates if the connection is currently connected.
```lua
local isConnected = conn.Connected
print(isConnected)
```

### ``:Disconnect()``
Disconnects a listener.
```lua
conn:Disconnect()
```

