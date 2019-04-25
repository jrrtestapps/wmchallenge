//
//  Copyright © 2018 Weedmaps, LLC. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  // MARK: Properties
  
  var window: UIWindow?
  var diContainer: DIContainer!
  var appCoordinator: AppCoordinator!
  
  // MARK: Lifecycle
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    self.diContainer = DIContainer(
      yelpAPIService: YelpAPIService(baseURI: "https://api.yelp.com/v3"),
      imageCachingService: ImageCachingService(),
      locationService: LocationService(),
      alertService: AlertService())
//     Mock Data
//    self.diContainer = DIContainer(
//      yelpAPIService: MockYelpAPIService(),
//      imageCachingService: ImageCachingService(),
//      locationService: LocationService(),
//      alertService: AlertService())
    
    self.appCoordinator = AppCoordinator(
      diContainer: self.diContainer,
      tabBarController: self.window?.rootViewController as! UITabBarController)
    
    self.appCoordinator.start()
    
    return true
  }
}

