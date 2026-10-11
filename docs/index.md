---
layout: docs
title: Home
---

# QuickNet
High performance networking solution for Roblox.

## Performance
QuickNet uses clever optimization techniques under the hood to reduce allocations and minimize CPU usage. As a result, QuickNet is typically able to deliver **higher FPS** compared to default RemoteEvents. In addition, its buffer implementation allows data to be compressed when sent over the network, resulting in much **lower network traffic**.

## Security
The buffer implementation makes it very difficult for exploiters to access the game's network events. For those who manage to bypass the buffer encoding, QuickNet performs additional checks on incoming data from clients to protect the server from invalid data and DDoS. For even further protection, the developer can set custom rate limits for each network event.

## Accessibility
Despite QuickNet's high performance, it is very easy to use. No plugins, installations, or setup required; it works out of the box. Furthermore, the syntax is very similar to default RemoteEvents meaning very little learning is required. In fact, if a game is already using RemoteEvents QuickNet can be dropped in with minimal changes to the code base.

## Getting Started

- [Benchmarks](benchmarks.md)
- [Installation](installation.md)
- [Quickstart](quickstart.md)

## Updates
### v0.4.0 (10/10/26)
* Added data.custom type: this method provides a hook for custom serialization so you can provide your own encode/decode functions for arbitrary data. Custom serialization can be significantly faster than the built in serialization in some cases, such as when your data is complex
* Added new serialized types: Font and Ray
* Added/improved error messages across the board, from fire paths to schema parser
* Optimized string serialization by ~15% in some cases
* Optimized struct serialization by ~15% in some cases
* Removed buffer library variables from Serialize file: upvalues are generally slower than getimport and most likely the variables were getting compiled to getimport calls anyways. The previously observed performance benefit was most likely just benchmark noise
* Internal signal implementation changed from dictionary to linked list. Reentrant behavior should now be consistent (disconnecting yourself runs callback, disconnecting others skips them if they haven't been visited yet)
* Connection objects are now metatables and connection type renamed from QuickNetConnection to Connection
* Fixed Once and Wait methods calling connect/disconnect through the object table instead of calling the local functions directly
* Fixed fastUnpack function returning extra nils, which could've caused a correctness issue in an edge case where the user uses the select() function to read callback arguments
* Fixed buffers cache size counter going out of sync with the actual number of buffers in the cache (not a correctness bug, but caused extra ejections from the cache)
* Fixed table pool size being off by 1
* Removed unused "onceCallbacks" table allocation
* Added safety guard for exceeding 80% of the static allocation on both client and server
* Constant variables now use const instead of local

### v0.3.5 (9/7/26)
* Optimization for FireAllClients, FireClients, and FireAllExcept: instead of serializing the data for each individual player, QuickNet now serializes for only one player then copies the bytes directly for the remaining players. This should be a massive performance boost for games with large server size
* Server side player buffer recycling removed: performance benefit was negligible and had a conflict with the new optimization
* New Config file isolates the parameters intended to be adjusted by the user
* setMaxPayloadSize method removed since the value is exposed in the new Config file
* Small misc changes that don't affect performance or behavior

### v0.3.4 (8/5/26)
* setEnumItems -> addEnumItems: Instead of requiring a single call that provides every EnumItem used, EnumItems can now be attached individually in multiple different scripts on startup
* Reworked logic for Once and Wait methods: more reliable behavior, more reused code and less logic in listener paths on both server and client

### v0.3.3 (6/25/26)
* Fixed client side error swallowing in the calling thread for remote functions

### v0.3.2 (6/13/26)
* Fixed small memory leak for unreliable events

### v0.3.1 (6/5/26)
* Fixed instance pointer bug for nil instances on receiving end
* Improved debug message for response events
* Removed some unnecessary code

### v0.3.0 (5/16/26)
* Added optional types via the data.optional method. Optional types have significantly better performance than Any types
* Added union types via the data.union and data.unionMany methods. Union types have slightly better performance than Any types for primitives, but significantly better performance for table types
* Added literal types via the data.literal method. Literal types typically use much less bandwidth than normal types but do not have better performance (a little worse in most cases)
* Added 13 new serialized types: NumberU4, CFrameI16FX16, Vector3I16, Vector2I16, Player, ColorSequence, NumberSequence, NumberRange, UDim, UDim2, Region3, PhysicalProperties, Rect. Check [here](https://breadboardengineer1234.github.io/QuickNet/types) for more info
* Changed the way NumberU8s are encoded when passed in a table. Values that do not follow NumberU8 rules no longer corrupt other NumberU8 values. In addition, the serialization has been slightly optimized.
* Slight adjustments to internal parameters

### v0.2.0 (5/10/26)
* Added unreliable support, simply call :Unreliable when registering an event
* Fixed a bug where sending a table throws an error when using the Any type
* Added new serialized types: BrickColor, DateTime32, DateTime64, CFrameF32Aligned, TweenInfo
* Added :Once method
* Fixed an issue where calling :Wait doesn’t return the arguments
* Optimized connection objects: no longer creates new closures for each connection
* FX16 scale factor changed from 128 → 100
* Adjusted some other internal parameters

### v0.1.0 (5/7/26)
* Release
