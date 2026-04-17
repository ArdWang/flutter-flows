# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.0.1] - 2026-04-17

### Added
- Initial release of LiteFlows framework
- **Dependency Injection** system with `Flow.put`, `Flow.find`, `Flow.isRegistered`, and `Flow.remove`
- **Reactive State Management** with Rx types:
  - `Rx<T>`, `Rxn<T>` for generic reactive wrappers
  - `RxBool`, `RxInt`, `RxDouble`, `RxString` for primitive types
  - `RxList<T>`, `RxMap<K,V>`, `RxSet<T>` for collections
  - `.obs` extension for easy reactive type creation
- **Route Management** with `Flow.to`, `Flow.toNamed`, `Flow.back`, `Flow.off`, `Flow.offAll`
- **FlowMaterialApp** widget for app configuration with theme support
- **FlowPage** for named route definitions
- **FlowController** base class with lifecycle methods (`onInit`, `onClose`)
- **Flx** reactive widget builder
- **FlxValue** optimized single-value reactive widget
- **Logic/State/View** architecture pattern support
- Example app demonstrating all features:
  - Counter page with reactive state
  - Home page with UserData editing
  - Detail page with route parameter receiving
  - Performance test page
  - Light/Dark theme switching
  - Custom app icon configuration
- Comprehensive documentation:
  - README.md (English)
  - README_cn.md (Chinese)
  - CHANGELOG.md
  - CHANGELOG_cn.md

### Changed
- Optimized route argument passing to preserve `settings.arguments`
- Updated default theme colors to cyan/teal (0xFF26C6DA) for brand consistency
- Improved AppBar colors with darker shades for better contrast
- Enhanced example app with editable UserData model
- Refined API design based on GetX inspiration with cleaner syntax

### Fixed
- Route arguments not being passed correctly when using `FlowMaterialApp`
- Theme switching not reflecting in UI
- RenderFlex overflow issues in example pages
- Type casting issues with nullable UserData parameters

### Performance
- Single-level observation design for optimal performance
- Zero boilerplate - no StreamControllers, ChangeNotifiers, or InheritedWidgets required
- Efficient widget rebuilding with FlxValue for single-value observation

## [Unreleased]

### Planned
- Additional Rx operators and utilities
- Middleware support for route navigation
- Enhanced DevTools integration
- More comprehensive test coverage
- Additional example templates

---

**Acknowledgments:**

This project is inspired by the excellent work on [GetX](https://pub.dev/packages/get).
We want to express our gratitude to Jonny Borges and the GetX community for pioneering
reactive state management and dependency injection in Flutter.
