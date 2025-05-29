# ToDo

- [ ] Check the IP-address of the simulator against localhost before starting the local modbus server.
	  when a custom IP-address is used, assume a remote simulator (like on the home server) and do not start the local simulator.

- [ ] Create Preference view/container for each module,
use the WeatherService.CreditsView as an example (the views should be embedded by extensions in the main driver type}
use those views directly as the tabs from the apps prefs/settings - view

- [ ] Create a Display/View/Container for each module where applicable
- [ ] Complete DocC files with UML diagrams to explain architecture


# Performance
Complete ToDo's of the SoftPLC package first
Check doubleclick interval of the programmable switches (e.g. for the lights in the bedroom).


## Testing
- [ ] Test the smartsprinkler in Auto-enabled mode during dry-season.

## Longterm MacOS 13
- [ ] Use gauges and charts in SwiftUI to represent al kinds of numeric data
- [ ] Bundle ClibYASDI as a binary package by creating a new binary-target for the package (do not includec zip-archive in git, upload to seperate server LFS)

## Longterm MacOS xx
- [ ] Use SwiftData as the persistent store for all dbase-based Apps.

- [ ] include support for Matter instead of only HAP once the docmentation for Matter(support) improves and rename the project accordingly
- [ ] Refactor Milightdriver (=UDP-socket) to Async/Await when available.

