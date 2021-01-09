#  ToDo Domotica
  
Subscript voorzien voor accessories op naam
cleanup bridge en merge/typealias wit delegate
Pushbutton voorzien als subscript van Switch?

###### Provide feedback of currenstate to HomeKit
- [ ]  currentposition.value implementeren
- [ ]  enum PositionState implementeren

###### PLC kringen verder uitwerken
- [ ]  Ebools herwerken (pijlsymbolen gebruiken als functienaam)
- [ ]  Screens en rolgordijnen uitwerken

###### Scenes definiëren volgens Things



- [ ]  Knoppen implementeren voor opvrgan informatie leaf
- [ ]  Array of partial keypaths meegeven als parameter aan SQLite.autoCreateTableFor<T:SQLRecordable> in JVCocoa
- [ ]  SmartsprinklerDriver afwerken

MODEL-layer
write model files with data properties and any data-transforming code (like JSON decoding wich belongs to the model Layer) or validation of the data
write models that provide testdata in separte Structs

VIEW-layer
Only use simple data types (not objects) in views, to keep them as generic as posible
(To remove specific formatting from your views, write formatters as global extensions on types that need to be formatted)

VIEW-MODEL/ViewController (Application level)
at the application level extend  ur generic views with an app specific init that splits objects in the views simple types and use app specific formatters when passing parameters

