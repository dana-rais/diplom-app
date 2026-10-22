# Architectural Diagrams Specification

## 1. System Context Diagram (C4 Level 1)
The System Context diagram illustrates the planned interaction between the elderly user, the cross-platform Flutter application, and local device storage.

```mermaid
graph TD
    User[Elderly User / Senior Citizen] <-->|Interacts with UI / Audio Guidance| FlutterApp[Interactive Digital Literacy App]
    FlutterApp <-->|Reads & Saves Progress / Settings| LocalStorage[(Local Storage: SharedPreferences / Hive)]
```

---

## 2. Use Case Diagram
The Use Case diagram defines the planned core interactions between the senior user and the application modules.

```mermaid
graph LR
    User[Senior User]
    
    subgraph Proposed Application Modules
        UC1(UC-1: Customize Accessibility - Language KZ/RU, Text Scale 100%-150%, Theme)
        UC2(UC-2: View Progress - Check completed lessons & categories)
        UC3(UC-3: Run Interactive Simulators - Gestures, Mock Scam Calls & SMS)
        UC4(UC-4: Trigger Audio Guidance - Text-to-Speech Narration)
        UC5(UC-5: Request Supportive Hint - Non-punitive safety tips)
    end
    
    User --> UC1
    User --> UC2
    User --> UC3
    User --> UC4
    User --> UC5
```

---

## 3. Component Diagram
The Component diagram outlines the planned software architecture layers and structural blocks of the Flutter application.

```mermaid
graph TD
    subgraph Presentation Layer UI
        UI1[HomeScreen Widget]
        UI2[ProgressScreen Widget]
        UI3[SettingsScreen Widget]
        UI4[Simulator & Scenario Widgets]
    end

    subgraph Business Logic Layer State Management
        CTRL1[SettingsController - Theme, Font, Language]
        CTRL2[ProgressController - Lesson tracking]
        CTRL3[SimulationEngine - Scenarios & Error handling]
        AUDIO[AudioNarrationService - Text-to-Speech]
    end

    subgraph Data Layer Storage
        DB[(LocalStorageService - SharedPreferences / Hive)]
    end

    UI1 --> CTRL1
    UI2 --> CTRL2
    UI3 --> CTRL1
    UI4 --> CTRL3
    UI4 --> AUDIO
    CTRL1 --> DB
    CTRL2 --> DB
    CTRL3 --> DB
```

---

## 4. Summary
All presented diagrams describe the target architectural design and planned component interactions for the proposed Flutter application.
