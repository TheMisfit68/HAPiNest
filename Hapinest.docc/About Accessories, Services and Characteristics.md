#  About Accessories, Services and Characteristics

## Terminology used in Apple's Home-app.
In Apple's Home-app an _Accessory_ can be represented as one or more tiles.  
Therefore each tile represents either the accessory's' most important service or each individual service.  
In the Home-app the name _'Accessory'_ is used for both kind of tiles.  

## Use of Accessories, Services, and Characteristics (in HAP or in the HomeKit Accessory Simulator).
An HAP-accessory's _Type_ is only used to display as extra info at the time the accessory is added to the Home-App. 
An HAP-accessory's _Primary service_ determines the look of the Accesory's tile in the Home-app.
If the Primary service doesn't contain any representable elements then the tile will represent the first service that does.
In none of the services contain any representable elements then the tile will not update its representation.
A restart of the Home-app will refresh the representation of the accessory's tile after a change in an accessory's configuration.  

__⚠️ Warning !__  
__(Prior to MacOs 13.5.2, iOS 16.6.1 and iPadOS 16.6 tiles might not always display the correct service).__  

Custom accessories can only be an array of 1 or more of Apple's standard Services and their Characteristics.
Custom accessories that don't make use of those standards are not supported by Apples Home-App at all.

A Services optional 'characteritics'-parameter enables you to provide characterics like the name and the manufacturer
This is also true for Service.Info passed to an acccessories initializer
