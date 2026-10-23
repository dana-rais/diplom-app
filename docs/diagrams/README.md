# Architectural Diagrams Specification

## 1. System Context Diagram

The System Context diagram shows the planned application as a single system and its interactions with people and external systems. The application runs entirely on the user's device: there is no server, no account registration, and no personal data is transmitted.

```mermaid
flowchart TB
    user["Older adult<br/>[Person]<br/>Learns smartphone skills"]
    helper["Relative or volunteer<br/>[Person, optional]<br/>Helps with first-time setup"]
    app["Қадам / Шаг mobile app<br/>[Software system]<br/>Interactive training simulations,<br/>hints and audio guidance, works offline"]
    os["Device OS: Android / iOS<br/>[External system]<br/>Text-to-speech, system font scale,<br/>local storage, vibration"]

    user -->|"Practises tasks, reads and listens to instructions"| app
    app -->|"Shows lessons, hints and feedback"| user
    helper -.->|"Helps choose language and text size"| app
    app -->|"Uses speech output, saves progress and settings locally"| os
```

**Elements**

| Element | Type | Responsibility |
|---|---|---|
| Older adult | Person | Main user who practises simulated tasks |
| Relative or volunteer | Person (optional) | Helps with language, text size and first launch |
| Қадам / Шаг app | Software system | Lessons, simulations, hints, audio, progress tracking |
| Device OS | External system | Text-to-speech, storage, system accessibility settings |

The internal local storage (SharedPreferences / Hive) is shown on the Component Diagram, not here, because it is part of the application.


## 2. Use Case Diagram

The Use Case diagram defines the planned core interactions between the older adult, an optional helper, and the application. Audio guidance and hints extend a running lesson or simulation. Saving progress and settings locally is included in the use cases that change them.

```mermaid
flowchart LR
    user(["Older adult"])
    helper(["Relative or volunteer<br/>(optional)"])

    subgraph sys["Қадам / Шаг app"]
        uc1(["UC-1 Customize accessibility<br/>language KZ/RU, text scale, theme"])
        uc2(["UC-2 View progress<br/>completed lessons and categories"])
        uc3(["UC-3 Run lesson or interactive simulation<br/>gestures, scam call and SMS scenarios"])
        uc4(["UC-4 Listen to audio guidance<br/>text-to-speech narration"])
        uc5(["UC-5 Request supportive hint<br/>non-punitive safety tips"])
        uc6(["UC-6 Save progress and settings locally"])
    end

    user --> uc1
    user --> uc2
    user --> uc3
    helper -.-> uc1
    uc4 -.->|"«extend»"| uc3
    uc5 -.->|"«extend»"| uc3
    uc1 -.->|"«include»"| uc6
    uc3 -.->|"«include»"| uc6
```

| Use case | Requirement | Main components |
|---|---|---|
| UC-1 | FR-1, FR-2 | SettingsScreen, SettingsController, SettingsRepository |
| UC-2 | FR-3 | ProgressScreen, ProgressController |
| UC-3 | FR-4, FR-6 | Simulator widgets, SimulationEngine |
| UC-4 | FR-5 | AudioNarrationService |
| UC-5 | FR-6 | Simulator widgets, SimulationEngine |
| UC-6 | FR-7 | SettingsRepository, ProgressRepository |


## 3. Component Diagram (draft)

The Component diagram outlines the planned layers and structural blocks of the Flutter application. All data is stored locally; the only external dependency is the device speech engine.

```mermaid
flowchart TB
    subgraph PL["Presentation layer (Flutter widgets)"]
        home["HomeScreen"]
        progress["ProgressScreen"]
        settings["SettingsScreen"]
        sim["Simulator and scenario widgets<br/>(hint panel, step guidance)"]
    end

    subgraph BL["Business logic layer (state management)"]
        sc["SettingsController<br/>theme, text scale, language"]
        pc["ProgressController<br/>lesson tracking"]
        se["SimulationEngine<br/>scenarios, step flow, error handling, hints"]
        tts["AudioNarrationService"]
    end

    subgraph DL["Data layer (local, offline)"]
        sr["SettingsRepository<br/>SharedPreferences"]
        pr["ProgressRepository<br/>Hive"]
        content["Scenario content and<br/>localization (assets, l10n kk/ru)"]
    end

    os["Device OS<br/>text-to-speech"]

    home --> sc
    home --> pc
    progress --> pc
    settings --> sc
    sim --> se
    sim --> tts

    se -->|"lesson completed"| pc
    se --> content
    sc --> sr
    pc --> pr
    tts --> os
```

## 4. Summary

All diagrams describe the target architectural design of the Flutter application. The application is offline-first: no server, no accounts, and no personal data leaves the device.
