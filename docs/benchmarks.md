---
layout: docs
title: Benchmarks
---

# Benchmarks
Benchmarks are conducted by firing the network event 1000 times per frame with the same data for 10 seconds. At the end of this period, the average FPS and Kbps are recorded. The Kbps value is normalized to 60 FPS. All benchmarks are conducted in Roblox studio. See the benchmarks [source code](https://github.com/breadboardengineer1234/QuickNet/tree/main/benchmarks) for more details.

### Entities Test (100 entities)

| Networking Tool | FPS | Kbps |
|--------------------|------------------------|--------------------
| RemoteEvent | 4.24 | 2165272.99
| Packet | 13.38 | 38.88
| ByteNet | 12.51 | 37.66
| Jolt | 21.85 | 41.82
| NetRay Compile | 25.12 | 39.61
| Lync | 14.77 | 39.34
| Blink | 24.94	| 39.65
| QuickNet | 34.45 | 39.68
| QuickNet (custom)* | 58.77 | 39.35

### Booleans Test (1000 booleans)

| Networking Tool | FPS | Kbps |
|--------------------|------------------------|--------------------
| RemoteEvent | 9.81 | 291769.91
| Packet | 10.70 | 20.98
| ByteNet | 11.32 | 20.01
| Jolt | 84.80 | 10.18
| NetRay Compile | 73.68 | 10.13
| Lync | 23.07 | 11.06
| Blink | 42.70	| 20.66
| QuickNet | 97.74 | 10.03 

### Strings Test (300 strings)

| Networking Tool | FPS | Kbps |
|--------------------|------------------------|--------------------
| RemoteEvent | 22.31 | 718753.84
| Packet | 17.98 | 108.12
| ByteNet | Crash | 
| Jolt | 40.59 | 110.59
| NetRay Compile | 23.13 | 109.48
| Lync | 19.61 | 319.44
| Blink | 30.53	| 102.33
| QuickNet | 57.26 | 103.76 

### Numbers Test (1000 numbers)

| Networking Tool | FPS | Kbps |
|--------------------|------------------------|--------------------
| RemoteEvent | 10.43 | 1123124.57
| Packet | 6.55 | 99.45
| ByteNet | 12.79 | 59.69
| Jolt | 57.04 | 65.24
| NetRay Compile | 45.23 | 64.53
| Lync | 11.25 | 122.40
| Blink | 44.56	| 64.77
| QuickNet | 97.01 | 65.60

### Dictionary Test (200 dictionaries)

| Networking Tool | FPS | Kbps |
|--------------------|------------------------|--------------------
| RemoteEvent | 16.34 | 1466655.19
| Packet | 1.08 | 58.14
| ByteNet | Crash | 
| Jolt | 49.55 | 70.33
| NetRay Compile | 20.49 | 62.65
| Lync | 6.19 | 116.34
| Blink | 28.22	| 58.49
| QuickNet | 53.66 | 62.65

### Vector3 Test (100 vector3s)

| Networking Tool | FPS | Kbps |
|--------------------|------------------------|--------------------
| RemoteEvent | 27.47 | 13665554.86
| Packet | 38.37 | 79.22
| ByteNet | 35.18 | 69.56
| Jolt | 116.70 | 74.22
| NetRay Compile | N/A* |
| Lync | 24.64 | 138.41
| Blink | 147.14 | 74.54
| QuickNet | 190.90 | 74.63

### Call-Response Test (500 numbers)

Call-response refers to the networking behavior of RemoteFunctions. Even though this functionality is quite useful, some libraries do not support it (marked as "N/A" below). In this test, each invoke is wrapped in a task.spawn to ensure calls aren't blocked. This introduces some noise so the actual performance differences are greater than that shown. Note there's an issue where Stats.DataReceiveKbps always returns 0, so the receive Kbps is inferred from the send Kbps by returning the exact same data that's sent.
| Networking Tool | FPS | Send Kbps | Receive Kbps 
|--------------------|------------------------|--------------------|----------------
| RemoteFunction | 15.44 | 764181.29 | 764181.29
| Packet | Crash |  |
| ByteNet | N/A | |
| Jolt | Crash | |
| NetRay Compile | 44.18 | 136083.19 | 136083.19
| Lync | N/A | |
| Blink | Crash | |
| QuickNet | 59.97 | 150.12 | 150.12

JSON output of benchmark:
```lua
{"Blink":{"Vectors":{"kbps":74.542,"fps":147.146},"Numbers":{"kbps":64.77,"fps":44.566},"Dict":{"kbps":58.494,"fps":28.222},"Booleans":{"kbps":20.666,"fps":42.701},"Entities":{"kbps":39.654,"fps":24.946},"Strings":{"kbps":102.336,"fps":30.533}},"RemoteEvent":{"Vectors":{"kbps":13665554.869,"fps":27.477},"Numbers":{"kbps":1123124.572,"fps":10.436},"Dict":{"kbps":1466655.193,"fps":16.343},"Booleans":{"kbps":291769.916,"fps":9.812},"Entities":{"kbps":2165272.999,"fps":4.248},"Strings":{"kbps":718753.844,"fps":22.313}},"Lync":{"Vectors":{"kbps":138.413,"fps":24.641},"Numbers":{"kbps":122.407,"fps":11.25},"Dict":{"kbps":116.348,"fps":6.19},"Booleans":{"kbps":11.062,"fps":23.072},"Entities":{"kbps":39.344,"fps":14.775},"Strings":{"kbps":319.445,"fps":19.614}},"Packet":{"Vectors":{"kbps":79.22,"fps":38.375},"Numbers":{"kbps":99.459,"fps":6.558},"Dict":{"kbps":58.149,"fps":1.089},"Booleans":{"kbps":20.986,"fps":10.705},"Entities":{"kbps":38.889,"fps":13.384},"Strings":{"kbps":108.121,"fps":17.988}},"NetRay":{"Vectors":{"kbps":0,"fps":0},"Numbers":{"kbps":64.536,"fps":45.232},"Dict":{"kbps":62.656,"fps":20.492},"Booleans":{"kbps":10.136,"fps":73.686},"Entities":{"kbps":39.618,"fps":25.129},"Strings":{"kbps":109.489,"fps":23.136}},"QuickNet":{"Vectors":{"kbps":74.638,"fps":190.9},"Numbers":{"kbps":65.602,"fps":97.015},"Dict":{"kbps":62.653,"fps":53.665},"Booleans":{"kbps":10.039,"fps":97.744},"Entities":{"kbps":39.684,"fps":34.457},"Strings":{"kbps":103.763,"fps":57.269}},"Jolt":{"Vectors":{"kbps":74.228,"fps":116.701},"Numbers":{"kbps":65.245,"fps":57.044},"Dict":{"kbps":70.338,"fps":49.554},"Booleans":{"kbps":10.185,"fps":84.804},"Entities":{"kbps":41.828,"fps":21.856},"Strings":{"kbps":110.596,"fps":40.598}}}
```
Note: due to issues with crashing ByteNet has to be tested individually.

*QuickNet (custom) uses data.custom to hook a custom defined serializer.

*NetRay Compile refused to compile the files with vector3 data type.

