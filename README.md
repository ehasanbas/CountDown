# CountDown

A small Swift countdown timer demo app and widget for iOS, with a lightweight event model and an image picker helper.


## Quick summary

- Language: Swift
- Targets:
  - CountDown (main app)
  - CountDownWidget (today/home screen widget)
  - CountDownTests (unit tests)
  - CountDownUITests (UI tests)
- Notable source files (top-level):
  - `Event.swift` — event model used by the app / widget
  - `EventStore.swift` — persistence and in-app store for events
  - `ImagePicker.swift` — helper for selecting images from the photo library
- Open the Xcode project `CountDown.xcodeproj` to build and run.

## Requirements

- Xcode 12+ (adjust if the repo requires a newer version)
- Swift 5+
- iOS 14+ to use WidgetKit

## Repository layout

- CountDown/                 — app source (app-specific files may be inside this folder)
- CountDownWidget/           — widget target sources
- CountDown.xcodeproj        — Xcode project
- Event.swift                — Event model (id/title/date/optional image)
- EventStore.swift           — app data store (load/save, add/remove, publishes changes)
- ImagePicker.swift          — UIKit wrapper for UIImagePickerController used by the app
- CountDownTests/            — unit tests (test harness present)
- CountDownUITests/          — UI tests (UI test harness present)

## Build & run

1. Clone the repository:
   git clone https://github.com/ehasanbas/CountDown.git

2. Open the project in Xcode:
   open CountDown/CountDown.xcodeproj
   or
   open CountDown.xcodeproj

3. Select the `CountDown` app target (or `CountDownWidget` for the widget target) and choose a simulator or a device.

4. Build and run (Cmd+R). The app and widget targets can be run from Xcode; the widget will show up in the simulator's home screen widget gallery (or on a device).

## How the code is organized (concrete notes)

- Event.swift
  - Contains the Event data structure used by the app (typically includes an identifier, title, target date/time, and optional image or color metadata).
  - This model is used both by the app UI and by the widget to render countdowns.

- EventStore.swift
  - Manages a collection of Event instances.
  - Responsible for loading and saving events (likely via Codable + filesystem or UserDefaults).
  - Exposes methods to add, remove, update events and to retrieve upcoming events.
  - If implemented as an ObservableObject (SwiftUI) or via NotificationCenter, the UI updates automatically when the store changes.

- ImagePicker.swift
  - Utility to present an image picker and return a selected image to the caller.
  - Typical usage: let image = await ImagePicker.pick(...) or via delegate callbacks (depending on implementation).

- CountDownWidget
  - Contains WidgetKit code to display one or more countdowns on the iOS home screen.
  - Reads events (or a subset according to configuration) and updates widget timelines.

## Example usage (how you probably use the code)

Open the demo app and add a new event using the UI. The widget target will read the stored events (via shared container / app group if implemented) and show the next upcoming countdown.

Pseudo-usage (adapt to actual public API in the code):
```swift
import Foundation
// Create an event (replace with actual Event initializer)
let event = Event(title: "Birthday", date: Date().addingTimeInterval(86_400)) // +1 day

// Save using EventStore (replace with actual API)
EventStore.shared.add(event)
```

If the widget is intended to read the same events as the app, ensure `EventStore` uses an app group container or shared storage so the widget target can access the same data.

## Tests

- Unit tests are present under `CountDownTests`. Run them in Xcode: Product → Test (Cmd+U).
- UI tests are under `CountDownUITests`.

Consider adding a GitHub Actions workflow to run these tests on push/PR and to provide a build badge in the README.
