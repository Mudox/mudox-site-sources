+++
date = "2015-04-17T14:43:56+08:00"
draft = true
title = "iOS NOTES - LOCATION BASED SERVIES"

tags      = ["Cocoa", "AppDev"]
languages = ["Swift", "ObjC"]
platforms = ["MacOS", "iOS"]
+++

Quick steps to use iOS's LBS technology.
<!--more-->

# Core Location

iOS devices integrates various hardware components, such as:

+ GPS (Global Positioning System) for positioning

+ Hardware compass for heading monitoring.

+ WiFi for positioning.

+ Cellular network for cell-tower triangulation.

+ Blue tooth for iBeacon ranging.

+ some data sensors for improve positioning accuracy under some circumstances.

to provides users with following LBS abilities as much as possible:

1. Location Updates

  1. Standard location updates

  2. Significant location updates

2. Heading monitoring

3. Region monitoring

4. iBeacon ranging

5. Visit events

The `CLLocationManager` acts just like an `NSNotificationCenter` (but it is not
a singleton) between the LBS hardwares and your App, you use it to request the
authorization for LBS functionalities you are planning to use afterwords, and
adjusts the relevant parameters of them before starting their notification
updating loops.

After you call one of its' `start***` or `request***` methods to emit requests
for one of the 5 LBS abilities mentioned above, the `CLLocationManager`
activate relevant hardware components, when the data is available it notifies
you asynchronously by calling one of the its' delegate's methods.

![Core Location Map](../../../note/core_location_map.svg)

## Work flow of using LBS abilities.

1. Project setup

  1. Enable _Background Location Updates Background Mode_ capability.

  2. Add _NSLocationAlwaysUsageDescriptions_ or
     _NSLocationWhenInUseUsageDescription_ key to info.plist.

2. Configuring `CLLocationManager`

  1. Creating a `CllocationManager` instance and hold a strong reference to it.

  2. Specify location manager's delegate, usually be a view controller.

  3. Check & request authorization status.

  4. Configures the relevant properties for the LBS functionality you are about
     to use.

  5. Before starting each LBS updating functions, there are also corresponding
     APIs you can invoke to check the services availability.

  6. Call `start**` methods to start the various LBS notification loops.

    ```swift
    // declare as some long-standing reference outside of function body.
    let locationManager = CLLocationManager()
    --------------------
    // within functions ( be it in viewDidLoad() )
    // designate delegate
    locationManager.delegate = self
    // request for authorization
    locationManager.requestAlwaysAuthorization()
    // configure updating related settings
    locationManager.activityType = .AutomotiveNavigation
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
    locationManager.distanceFilter = 10
    // finally check device & service availability before starting notification loop.
    if CLLocationManager.locationServicesEnabled() {
      locationManager.startUpdatingLocation()
    } else {
      let alert = UIAlertController(
        title: "Service Not Available",
        message: "The location is not available or has been shut down.",
        preferredStyle: .Alert)
      presentViewController(alert, animated: true, completion: nil)
    }
    ```

3. Implement `CLLocationManagerDelegate` methods in you designated delegate
   object to:

   + handle received location data updates.

   + handle LBS failures.

   + handle authorization status changes.

   + ...

# MapKit

In general, MapKit:

1. shows map in one of three map types:

  + Standard

  + Satellite

  + Hybrid

2. along with many built-in elements:

  + compass

  + POIs (points of interest)

3. and provides developer with two kinds of customizable presentation
   facilities:

  + annotations

  + overlays

As of managing annotations, MapKit adopts the same design pattern as that is
heavily used by `UITableView` -- decoupling data model from presentation tools
through __reuse pool__. Hence, there comes separate class hierarchies for
storing annotation (overlay) data, and presenting them respectively.

+ data object

    - all objects that conforms to `MKAnnotation` protocol, are responsible for
      storing data for annotations, such as location, textual info, etc.

    - all objects that conforms to `MKOverlay` protocol, are responsible for
      storing data for overlays, such as location, etc.

+ presentation tools

    - instances that inherit from `MKAnnotationView` can be __reused__ to display a data objects.

    - instances that inherit from `MKOverlayRenderer` can be used to display a overlay objects.

![MapKit map](../../../note/map_kit_map.svg)

## Customize annotation view

A annotation view usually consist of 2 parts:

1. The view view.

  Set its' `image` property to change its' appearance.

2. The callout view, which is popped up when the pin view is selected.

  The built-in callout view is not exposed for customization, so we should disable the `canShowCallout` property
