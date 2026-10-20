# ChatClient (QML)

A Qt6/QML desktop chat client. One-to-one messaging over HTTP (registration, user search, chat creation, attachment up/download) and WebSockets (live message delivery). Dialogs and attachments persist locally so they survive restarts.

Status: work in progress. This is a port of an older QWidgets-based client to QML and is not production-ready — see [Known limitations](#known-limitations).

## Requirements

- **Qt 6.6.1** (older 6.x may work, untested). Modules: `Quick`, `WebSockets`, `Widgets`, `Gui`.
- A C++20 compiler.
- CMake ≥ 3.16.
- A reachable backend at `myapp.local` (host name is currently hard-coded in `src/core/chatclient.cpp`). The backend is not part of this repo; both HTTP and WebSocket are plain (`http://`, `ws://`).

## Build

The project is developed in Qt Creator — open `CMakeLists.txt` with a Qt 6.6.1 kit configured and build.

The executable is `appChatClient_QML` (bundled as `appChatClient_QML.app` on macOS).

## Run

On first launch the app shows a registration screen (`StartWidget.qml`); after `/user/register` succeeds, user id, device id, and user name are written to `settings.ini` next to the app binary and `MainWidget.qml` is loaded.

### Local state locations

Paths are relative to the app binary (on macOS, three directories above the `.app` bundle):

| File / dir | Purpose |
|---|---|
| `settings.ini` | QSettings — `userId`, `deviceId`, `currUserName`, `registered` flag |
| `dialogs` | `DialogsManager` serialized with `QDataStream` (binary) |
| `images/` | Downloaded + locally-cached attachments (max 640px side) |

### Reset

```sh
make clean
```

Removes `dialogs`, `settings.ini`, and `images/` from the build directory so you can re-register. **Note:** the `BUILD_DIR` path in `Makefile` is hard-coded to the original author's workstation — edit it before use.

## Architecture

High-level: QML view ⇄ `ChatClient` (C++ controller) ⇄ `DialogsManager` (data) + `HttpClient` / `WebSocketClient` (network). Three `QAbstractListModel`s project `DialogsManager` state into QML roles.

See [`CLAUDE.md`](./CLAUDE.md) for the full architecture notes, build gotchas, and layout.

## Known limitations

- Credentials and messages travel over plain HTTP/WS; no TLS, no token auth. Not suitable for use outside a trusted LAN.
- No tests, no CI, no linter config.
- Hard-coded backend host (`myapp.local`) and hard-coded build path in `Makefile`.
- No WebSocket reconnection — if the socket drops, restart the app.
- Builds + runs on macOS and Windows (platform `#ifdef`s present); not tested on Linux.
