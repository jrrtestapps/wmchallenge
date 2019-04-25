//
//  DIContainer.swift
//  WeedmapsChallenge
//
//  Created by Jason Rapai on 4/23/19.
//  Copyright © 2019 Weedmaps, LLC. All rights reserved.
//

import Foundation

class DIContainer {
  let yelpAPIService: YelpAPIServiceProtocol
  let imageCachingService: ImageCachingServiceProtocol
  let locationService: LocationServiceProtocol
  let alertService: AlertServiceProtocol
  
  init(yelpAPIService: YelpAPIServiceProtocol, imageCachingService: ImageCachingServiceProtocol, locationService: LocationServiceProtocol, alertService: AlertServiceProtocol) {
    self.yelpAPIService = yelpAPIService
    self.imageCachingService = imageCachingService
    self.locationService = locationService
    self.alertService = alertService
  }
}
