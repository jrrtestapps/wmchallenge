//
//  AppCoordinator.swift
//  WeedmapsChallenge
//
//  Created by Jason Rapai on 4/23/19.
//  Copyright © 2019 Weedmaps, LLC. All rights reserved.
//

import UIKit

class AppCoordinator {
  let diContainer: DIContainer
  let tabBarController: UITabBarController
  
  private var homeNavigationController: UINavigationController!
  private var homeViewController: HomeViewController!
  
  private var favoritesNavigationController: UINavigationController!
  
  init(diContainer: DIContainer, tabBarController: UITabBarController) {
    self.diContainer = diContainer
    self.tabBarController = tabBarController
    
    self.diContainer.alertService.setup(rootViewController: self.tabBarController)
  }
  
  func start() {
    guard let homeNavigationController = self.tabBarController.viewControllers?[0] as? UINavigationController,
      let homeViewController = homeNavigationController.viewControllers.first as? HomeViewController,
      let favoritesNavigationController = self.tabBarController.viewControllers?[1] as? UINavigationController else {
        fatalError("The app simply cannot start without these assumptions.")
    }
    
    self.homeNavigationController = homeNavigationController
    self.homeViewController = homeViewController
      .setup(viewModel: HomeViewModel(
        delegate: self,
        yelpAPIService: self.diContainer.yelpAPIService,
        locationService: self.diContainer.locationService,
        alertService: self.diContainer.alertService,
        imageCachingService: self.diContainer.imageCachingService))
    
    self.favoritesNavigationController = favoritesNavigationController
  }
}

extension AppCoordinator: HomeViewModelDelegate {
  func homeViewModel(_ source: HomeViewModel, openBusinessInApp businessViewModel: BusinessViewModel) {
    let viewController: HomeDetailViewController = HomeDetailViewController()
      .configure(with: businessViewModel)
    self.homeNavigationController.pushViewController(viewController, animated: true)
  }
}
