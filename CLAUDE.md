# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Qt6/QML desktop chat client written in C++20, targeting **Qt 6.6.1**. Uses `Qt6::Quick`, `Qt6::WebSockets`, `Qt6::Widgets`. Backend host is hard-coded as `myapp.local` in `src/core/chatclient.cpp` and the WebSocket URL is built via DNS-based routing (`ws://myapp.local/create?user_id=...&device_id=...`).

## Build & run

Build is driven by Qt Creator; CMake is the build system (`CMakeLists.txt` at the repo root). The out-of-tree build directory used by this checkout is `/Users/vovatakeda/Desktop/QtProjects/firstInstance/build-ChatClient_QML_migrate-Qt_6_6_1_for_macOS-Debug/` (referenced from the root `Makefile`).

### What this repo does *not* have

No `README.md`, no `.cursor/rules`, no `.github/copilot-instructions.md`, no test suite, no linter config, no CI. The only build/task config is `CMakeLists.txt` and the root `Makefile` (whose sole target is `clean`, below).

### Reset local state

`make clean` wipes the cached per-user state in the build directory so you can re-register as a fresh user. It removes `dialogs` (the serialized `DialogsManager`), `settings.ini` (QSettings — user id, device id, user name) and `images/` (downloaded attachments).

## Architecture

The app follows a QML view ⇄ C++ model/controller split. `main.cpp` wires everything up:

1. Instantiates three `QAbstractListModel` subclasses (`ContactsModel`, `SearchModel`, `ChatHistoryModel`) as `std::shared_ptr`s.
2. Constructs the central `ChatClient`, passing it the three models.
3. Exposes `chatClientObj` and the three models to QML via `QQmlContext::setContextProperty` (not `qmlRegisterType`) — QML files reference them by those names directly.

### ChatClient (`src/core/chatclient.{h,cpp}`)

Orchestration hub between QML and the network/data layers. Owns the `WebSocketClient`, `HttpClient`, and `DialogsManager`. Its `Q_INVOKABLE` methods (`loadDialogs`, `saveDialogs`, `isUserRegistered`, `sendNewMessage`, `updateCurrentChat`, `sendImage`, `registerUser`) are the surface QML calls. Signals (`SearchPrefixChanged`, `dialogIndexChanged`, `goToMainWidget`, `AttachmentsDownloaded`) are the surface QML listens to. When a WebSocket message arrives, `GotNewMessage` dispatches it into `DialogsManager` which propagates to all three models.

### Data layer (`src/model/data/`)

- `Dialog` — one conversation. Holds `QList<std::shared_ptr<Message>>` plus unread count, chat id, interlocutor name. Serializable via `QDataStream` operators.
- `DialogsManager` — owns all `Dialog`s in a `std::list<std::shared_ptr<Dialog>>` with two side indices: `m_UserToChat` (user id → chat id) and `m_IdToDialog` (chat id → list iterator). `friend ChatClient`. Persists itself with `SaveToMemory` / `LoadFromMemory` against the build dir.

### Models (`src/model/`)

`ContactsModel`, `SearchModel`, `ChatHistoryModel` are all thin `QAbstractListModel`s. They **do not own data** — they take a `std::shared_ptr<DialogsManager>` (or a `std::vector<UserInfo>` for `SearchModel`) as data source and project it into QML roles. When mutating state, go through `DialogsManager`/`ChatClient` and let the model emit its own change signals — don't mutate models directly.

### Network (`src/network/`)

- `WebSocketClient` (namespace `WebSocket`) — one bidirectional socket. Takes a `std::function<void(Message)>` callback at construction; parses incoming JSON and dispatches. `WebSocket::Message` is the wire struct.
- `HttpClient` — wraps a `QNetworkAccessManager`. Each `sendHttpRequest` call attaches a per-request `std::function` callback (stored in `m_reqToFunc`) that fires in `onRequestFinished`. Request kind is tagged via string-view constants (`createChatReq`, `getUsersListReq`) stored in `m_requestNames`.

### QML (`qml/`, `Main.qml`)

Entry point is `Main.qml` → `StackView` that initially shows `StartWidget.qml` or `MainWidget.qml` depending on `chatClientObj.isUserRegistered()`. `MainWidget` is split into three panels under `qml/MainWidgetInternal/{LeftSideBar,MidSideBar,RightSideBar}/`. Shared styling lives in `qml/StyleModule/Style.qml`, which is built as a separate static Qt library (`StyleLib` / module `StyleModule`) via `qml/StyleModule/CMakeLists.txt`.

### Local state

Per-user identity (user id, device id, user name) lives in `QSettings` (→ `settings.ini` in the build dir) and is accessed via `src/utils/utils.{h,cpp}` free functions (`getCurrUserId`, `getCurrDeviceId`, `getCurrUserName`). `utils.h` also defines `QDataStream` operators for `std::optional<T>` used by the `Dialog`/`Message` serialization.

## Gotchas

- **Adding a QML file:** `qt_add_qml_module(...)` in the root `CMakeLists.txt` lists every QML file explicitly in `QML_FILES`. A new `.qml` not added there will not land in the `qrc:/ChatClient/` resource prefix and will fail to load at runtime with no compile error. This bites almost every UI change.
