# ``HAPiNest``

@Metadata {
    @PageKind(article)
    @PageImage(
           purpose: icon, 
           source: "HomeKitLogoTiled", 
           alt: "Some generic Homekit logo")
    @PageColor(yellow)
}

HAPiNest is a my personal Home-automation system compatible with Apples HomeKit (written in Swift).

## Overview

![The HAPiNest icon](icon_256x256.png)


The program implements the  [HomeKit Accessory Protocol (HAP)](./Resources/HAP-Specification-Non-Commercial-Version.pdf).  

It serves as a HomeKit bridge that bundles different HomeKit accessories.  
Those accessories can be controlled with Apples Home app (or any other HomeKit-client).  
Hardware drivers for each accessory-type are then used to translate the actions into the hardware.

## Topics

### Essentials



