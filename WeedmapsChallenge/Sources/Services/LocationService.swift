//
//  LocationService.swift
//  WeedmapsChallenge
//
//  Created by Jason Rapai on 4/23/19.
//  Copyright © 2019 Weedmaps, LLC. All rights reserved.
//

import CoreLocation
import RxSwift
import RxCocoa

struct Location {
  let latitude: Double
  let longitude: Double
}

protocol LocationServiceProtocol: class {
  var current: Location? { get }
  var currentObservable: Observable<Location?> { get }
}

class LocationService: NSObject, LocationServiceProtocol {
  let locationManager = CLLocationManager()
  
  let _current: BehaviorRelay<Location?> = BehaviorRelay(value: nil)
  var current: Location? { return self._current.value }
  let currentObservable: Observable<Location?>
  
  override init() {
    self.currentObservable = self._current.asObservable()
    super.init()
    self.locationManager.delegate = self
    self.locationManager.requestWhenInUseAuthorization()
  }
}

extension LocationService: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    switch status {
    case .authorizedWhenInUse:
      self.locationManager.requestLocation()
    default: break
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let currentLocation = locations.first else { return }
    let location = Location(
      latitude: currentLocation.coordinate.latitude,
      longitude: currentLocation.coordinate.longitude)
    self._current.accept(location)
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("## error \(error.localizedDescription)")
  }
}
