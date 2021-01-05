# gaconsentmanager-ios-module
Appodeal Consent Manager for Godot

API Compatible with [Android plugin](https://github.com/PoqXert/gaconsentmanager-android-plugin).

## Setup

1. [Get Godot source](https://docs.godotengine.org/en/stable/development/compiling/getting_source.html).
2. Copy files from this repository to ``godot/modules/gaconsentmanager`` folder.
3. Add ``StackConsentManager.framework`` to ``lib`` subfolder.
4. [Compile for iOS](https://docs.godotengine.org/en/stable/development/compiling/compiling_for_ios.html).
5. After export Godot-project to XCode-project, replace ``GameName.a`` in XCode-project to file got on previous step.
7. Add Consent Manager framework (see [Choose your type of installation](https://wiki.appodeal.com/en/ios/consent-manager) section).

## Usage
To use the ``GAConsentManager`` API you first have to get the ``GAConsentManager`` singleton:
```gdscript
var _consent_manager

func _ready():
  if Engine.has_singleton("GAConsentManager"):
    _consent_manager = Engine.get_singeton("GAConsentManager")
```
### Regulations
```gdscript
enum Regulation {
  UNKNOWN = 0,
  NONE = 1,
  GDPR = 2,
  CCPA = 3,
}
```
### Statuses
```gdscript
enum Status {
  UNKNOWN = 0,
  NON_PERSONALIZED = 1,
  PARTLY_PERSONALIZED = 2,
  PERSONALIZED = 3,
}
```
### Methods
#### Synchronize
```gdscript
# Synchronize Consent Manager SDK
func synchronize(app_key: String) -> void
```
```gdscript
# Sunchronize Consent Manager SDK with params
func sunchronizeWithParams(app_key: String, params: Dictionary) -> void
```
#### Consent Dialog
```gdscript
# Should a consent dialog be displayed?
func shouldShowConsentDialog() -> bool
```
```gdscript
# Load Consent Dialog
func loadConsentDialog() -> void
```
```gdscript
# Is the dialog ready for display?
func isConsentDialogReady() -> bool
```
```gdscript
# Show Consent Dialog
func showConsentDialog() -> void
```
```gdscript
# Is the consent dialog shown?
func isConsentDialogPresenting() -> bool
```
#### Other
```gdscript
# Get regulation
func getRegulation() -> int
```
```gdscript
# Get status
func getStatus() -> int
```
```gdscript
# Get consent
func getConsent() -> bool
```
```gdscript
# Get IAB string
func getIABConsentString() -> String
```
```gdscript
# Get consent for vendor
func hasConsentForVendor(bundle: String) -> bool
```
```gdscript
# Enable IAB storage
func enableIABStorage() -> void
```
