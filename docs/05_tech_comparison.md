# 05. Technology Comparison & Technical Justification

## 1. Overview
To ensure scalability, high accessibility performance, and cross-platform compatibility, key technological alternatives were systematically evaluated across three architectural decisions: cross-platform framework, local data storage, and state management.

## 2. Decision 1: Cross-Platform UI Framework

| Criteria | Flutter 3.47.7 (Selected) | React Native | Native (Android/iOS) |
|---|---|---|---|
| **Single Codebase** | ✅ Yes (Android, iOS, Web) | ✅ Yes (Android, iOS) | ❌ No (Requires separate codebases) |
| **Accessibility & Custom UI** | ✅ Excellent (Custom semantics, dynamic text scale) | ⚠️ Moderate (Relies on bridge to native components) | ✅ Native OS Accessibility APIs |
| **Performance** | ✅ High (Impeller/Skia direct rendering) | ⚠️ Moderate (JS Bridge overhead) | ✅ Maximum Native Performance |
| **Development Speed** | ✅ High (Hot Reload, rich widget catalog) | ✅ High | ❌ Slow (Dual maintenance) |

* **Justification:** **Flutter 3.47.7** was selected because it allows custom control over widget rendering, enabling precise implementation of high-contrast themes, dynamic font resizing (100%–150%), and unified cross-platform behavior for elderly accessibility standards.

## 3. Decision 2: Local Data Storage & Progress Persistence

| Criteria | Shared Preferences / Hive (Selected) | SQLite (sqflite) | Realm DB |
|---|---|---|---|
| **Data Structure Complexity** | Low-to-Medium (Key-Value / NoSQL) | High (Relational SQL tables) | Object-oriented |
| **Performance / Speed** | ✅ Fast synchronous/asynchronous read | ⚠️ Slight overhead for complex queries | ✅ Fast |
| **Setup Complexity** | ✅ Minimal configuration | ⚠️ High (Migration scripts, schemas) | ⚠️ Requires native bindings |
| **Offline Reliability** | ✅ 100% Offline persistent | ✅ 100% Offline persistent | ✅ 100% Offline persistent |

* **Justification:** Lightweight local persistence (**SharedPreferences / Hive**) was selected to store user preferences (language, font size, theme) and lesson progress statuses without the overhead of heavy relational database engines.

## 4. Decision 3: State Management Architecture

| Criteria | Provider / Riverpod (Selected) | BLoC / Cubit | setState (Vanilla) |
|---|---|---|---|
| **Boilerplate Code** | Low to Moderate | High (Events & States) | None |
| **Testability** | ✅ High (Separation of UI & Logic) | ✅ High | ❌ Poor |
| **Learning Curve** | ✅ Gentle and reactive | Steep | Minimal |
| **Predictability** | ✅ Reactive state streams | ✅ Strict event-driven | ❌ Scalability issues |

* **Justification:** **Provider / Riverpod** was chosen to maintain reactive state for interactive simulators (e.g., step-by-step guidance, audio playback state, dynamic text scale updates across all screens) while keeping the codebase clean and maintainable.
