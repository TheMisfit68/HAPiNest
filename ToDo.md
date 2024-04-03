# ToDo for HAPiNest

- [ ] Create Preference view/container for each module,
use the leafsettingsView and to a lesser extend the WeatherService.CreditsView as an example (the views should be embedded by extensions in the main driver type}
use those views directly as the tabs from the apps prefs/settings - view

- [ ] Create a Display/View/Container for each module where applicable

- [ ] Complete the leafDriver1s ACController with temperature setpoint if Nissan developer account gets granted)

- [ ]  Write DOCC files 
For Siridriver
For ScriptsDriver
For Hapinest with UML diagrams to explain architecture


# Performance
Complete ToDo's of the SoftPLC package first
Check doubleclick interval of the programmable switches (e.g. for the lights in the bedroom).


## Testing
- [ ] Test the smartsprinkler in Auto-enabled mode during dry-season.

## Longterm MacOS 13
- [ ] Use gauges and charts in SwiftUI to represent al kinds of numeric data
- [ ] Bundle ClibYASDI as a binary package by creating a new binary-target for the package (do not includec zip-archive in git, upload to seperate server LFS)

## Longterm MacOS xx
- [ ] include support for Matter instead of only HAP once the docmentation for Matter(support) improves and rename the project accordingly
- [ ] Refactor TizenDriver (=Websocket) to Async/Await when available.
- [ ] Refactor Milightdriver (=UDP-socket) to Async/Await when available.
- [ ] Use SwiftData as the persistent store for all dbase-based Apps.

