//
//  HomeViewModelTests.swift
//  WeedmapsChallengeTests
//
//  Created by Jason Rapai on 4/24/19.
//  Copyright © 2019 Weedmaps, LLC. All rights reserved.
//

import XCTest
@testable import WeedmapsChallenge
import RxSwift

class MockHomeViewModelDelegate: HomeViewModelDelegate {
  func homeViewModel(_ source: HomeViewModel, openBusinessInApp businessViewModel: BusinessViewModel) {}
}

class MockLocationService: LocationServiceProtocol {
  var current: Location? {
    return Location(latitude: 0, longitude: 0)
  }
  
  var currentObservable: Observable<Location?> {
    return Observable.just(self.current)
  }
}

class MockAlertService: AlertServiceProtocol {
  func setup(rootViewController: UIViewController) -> Self {
    return self
  }
  
  func actionSheet(actions: [ActionSheetAction]) {}
  
  func prompt(title: String, body: String, actionTitle: String?, actionHandler: (() -> Void)?) {}
}

class MockImageCachingService: ImageCachingServiceProtocol {
  func image(for uri: String, completion: @escaping (Result<UIImage, Error>) -> Void) -> URLSessionTask? {
    return nil
  }
}

class HomeViewModelTest: XCTestCase {
  var mockHomeViewModelDelegate: MockHomeViewModelDelegate!
  var mockYelpAPIService: MockYelpAPIService!
  var mockLocationService: MockLocationService!
  var mockAlertService: MockAlertService!
  var mockImageCachingService: MockImageCachingService!
  var target: HomeViewModel!
  
  override func setUp() {
    super.setUp()
    self.mockHomeViewModelDelegate = MockHomeViewModelDelegate()
    self.mockYelpAPIService = MockYelpAPIService()
    self.mockLocationService = MockLocationService()
    self.mockAlertService = MockAlertService()
    self.mockImageCachingService = MockImageCachingService()
    
    setupYelpAPIService()
    
    self.target = HomeViewModel(
      delegate: self.mockHomeViewModelDelegate,
      yelpAPIService: self.mockYelpAPIService,
      locationService: self.mockLocationService,
      alertService: self.mockAlertService,
      imageCachingService: self.mockImageCachingService)
  }
  
  func setupYelpAPIService() {}
}

class HomeViewModel_when_initialized_and_user_has_a_location: HomeViewModelTest {
  var expectGetBusinessSearchCompletionCalled = XCTestExpectation(description: "getBusinessSearch completion called")
  var expectedBusinesses: [Business]!
  var actualBusinessViewModels: [BusinessViewModel]?
  var getBusinessSearchCallCount: Int = 0
  
  override func setUp() {
    self.expectedBusinesses = [
      Business(name: "testName", url: "https://www.yelp.com", rating: 4, imageURL: "http://s3-media2.fl.yelpcdn.com/bphoto/MmgtASP3l_t4tPCL1iAsCg/o.jpg"),
      Business(name: "testName2", url: "https://www.yelp.com", rating: 3.5, imageURL: "http://s3-media2.fl.yelpcdn.com/bphoto/MmgtASP3l_t4tPCL1iAsCg/o.jpg"),
      Business(name: "testName3 is a much longer name that should wrap", url: "https://www.yelp.com", rating: 5, imageURL: "http://s3-media2.fl.yelpcdn.com/bphoto/MmgtASP3l_t4tPCL1iAsCg/o.jpg"),
    ]
    super.setUp()
    self.actualBusinessViewModels = self.target.businesses
  }
  
  override func setupYelpAPIService() {
    self.mockYelpAPIService.getBusinessSearchTestClosure = { searchTerm, location, limit, offset, completion in
      self.getBusinessSearchCallCount = self.getBusinessSearchCallCount + 1
      completion(.success(self.expectedBusinesses))
      self.expectGetBusinessSearchCompletionCalled.fulfill()
      return nil
    }
  }
  
  func test_then_getBusinessSearch_call_count_is_1() {
    wait(for: [self.expectGetBusinessSearchCompletionCalled], timeout: 5)
    XCTAssertEqual(self.getBusinessSearchCallCount, 1)
  }
  
  func test_then_actual_businessViewModels_are_from_expected_businesses() {
    guard let actualBusinessViewModels = self.actualBusinessViewModels else {
      XCTFail()
      return
    }
    for (index, businessViewModel) in actualBusinessViewModels.enumerated() {
      XCTAssertEqual(businessViewModel.name.value, self.expectedBusinesses[index].name)
    }
  }
}
