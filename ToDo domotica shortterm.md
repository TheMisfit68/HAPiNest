#  ToDo Domotica shortterm
  
Repair dimmable light on on/Of switch

Pushbutton voorzien als subcass van Switch?
### Redsign garageDoor accesory subclass .toggled
### Screens en rolgordijnen uitwerken

###### PLC kringen verder uitwerken

###### Scenes definiëren volgens Things


- [ ] In bridge /device 'Subscript' voorzien voor accessories op naam

- [ ]  Knoppen implementeren voor opvragen informatie leaf
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

