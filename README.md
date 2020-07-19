# Fluttair
A flutter application for VFR flight planning and navigation.

<img src="demo/map2.png" width="200"> <img src="demo/map1.png" width="200"> <img src="demo/archived.png" width="200"> <img src="demo/db3.png" width="200">

## Overview
Fluttair is destined to VFR pilots who seek a minimalist and free navigation moving map application.
It is written in dart using the flutter framework, hence compatible for both Android and iOS.

The development has been halted for now, due to the difficulty of maintaining up-to-date navigational data without renting a server. 
You are encouraged to re-use ideas and design from the present project according to the terms of the license (GNU GPL v3).

## Features and limitations
Fluttair can:
* display information about airports, airspaces and navigational aids from a SQL database contained in the local storage
* fetch METAR/TAF data for airports
* display mapbox-style maps (.mbtiles) contained in the local storage
* plan a VFR route from a set of steerpoint coordinates
* display the user's position and the route on the moving map
* track the user's flight and display it for further debrief

Fluttair cannot:
* fetch navigational data and maps directly from the internet
* fetch NOTAMs
* perform screen-off tracking

You can find a to-do list in the issue tracker.

## How-to
In order to get the app working on your phone you need:
* [Android SDK, Flutter SDK and Dart](https://flutter.dev/docs/get-started/install)
* [openaip2sqlite](https://github.com/acrovato/openaip2sqlite)

Last versions tested:
* Android SDK v30.0.2
* Flutter SDK v1.12.13+hotfix.5
* openaip2sqlite [v1.1](https://github.com/acrovato/openaip2sqlite/releases/tag/v1.1)

Once the Android tools and Flutter are setup:
1) Download the data
  - airports, airspaces and navigational aids from [openAIP](https://www.openaip.net/)
  - maps from [Open FlightMaps](https://www.openflightmaps.org/)
2) Make database
  - use [openaip2sqlite](https://github.com/acrovato/openaip2sqlite) to generate a database containing the navigational data (world.db)
  - rename the map using the format `provider_regioncode.mbtiles` (e.g. Belgium map file from open flightmaps would write `ofm_eb.mbtiles`)
3) Move the database to the local storage
  - world.db goes under /assets/database
  - maps files go under /assets/maps
4) Connect your phone and compile (`flutter run --release`)
5) Enjoy! Any question, feedback or issue? Check the issue tracker or open a new issue!
