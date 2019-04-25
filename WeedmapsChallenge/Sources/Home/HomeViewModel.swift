//
//  HomeViewModel.swift
//  WeedmapsChallenge
//
//  Created by Jason Rapai on 4/23/19.
//  Copyright © 2019 Weedmaps, LLC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol HomeViewModelDelegate: class {
  func homeViewModel(_ source: HomeViewModel, openBusinessInApp businessViewModel: BusinessViewModel)
}

class HomeViewModel {
  private weak var delegate: HomeViewModelDelegate?
  private let yelpAPIService: YelpAPIServiceProtocol
  private let locationService: LocationServiceProtocol
  private let alertService: AlertServiceProtocol
  private let imageCachingService: ImageCachingServiceProtocol
  
  private var searchDataTask: URLSessionTask?
  
  private let fetchLimit: Int = 15
  private var lastOffset: Int = 0
  
  private(set) var businesses: [BusinessViewModel] = []
  private let _sectionUpdates: PublishRelay<Void> = PublishRelay()
  let sectionUpdates: Signal<Void>
  
  let searchTerm: BehaviorRelay<String?> = BehaviorRelay(value: nil)
  let loadAdditionalItems: PublishRelay<Void> = PublishRelay()
  
  private var disposeBag: DisposeBag!
  
  init(delegate: HomeViewModelDelegate, yelpAPIService: YelpAPIServiceProtocol, locationService: LocationServiceProtocol, alertService: AlertServiceProtocol, imageCachingService: ImageCachingServiceProtocol) {
    self.delegate = delegate
    self.yelpAPIService = yelpAPIService
    self.locationService = locationService
    self.alertService = alertService
    self.imageCachingService = imageCachingService
    self.sectionUpdates = self._sectionUpdates.asSignal()
    
    bindInputs()
  }
  
  private func bindInputs() {
    self.disposeBag = DisposeBag()
    
    let location = self.locationService.currentObservable
      .filter { $0 != nil }
      .map { $0! }
    let searchTerm = self.searchTerm.map { term -> String in term ?? "" }
    
    Observable.combineLatest(
      location,
      searchTerm
        .debounce(0.5, scheduler: MainScheduler.instance)
        .distinctUntilChanged().debug())
      .observeOn(ConcurrentDispatchQueueScheduler(queue: .global(qos: .userInitiated)))
      .subscribe(onNext: { location, term in
        self.lastOffset = 0
        self.fetchItems(term, location: location, offset: 0)
      })
      .disposed(by: self.disposeBag)
    
    let locationAndTerm = Observable.combineLatest(location, searchTerm)
    
    self.loadAdditionalItems
      .throttle(3.0, scheduler: ConcurrentDispatchQueueScheduler(queue: .global(qos: .userInitiated)))
      .withLatestFrom(locationAndTerm)
      .subscribe(onNext: { location, term in
        self.lastOffset = self.lastOffset + 1
        self.fetchItems(term, location: location, offset: self.lastOffset * self.fetchLimit)
      })
      .disposed(by: self.disposeBag)
  }
  
  private func fetchItems(_ term: String?, location: Location, offset: Int) {
    self.searchDataTask?.cancel()
    self.searchDataTask = self.yelpAPIService
      .getBusinessSearch(searchTerm: term, location: location, limit: self.fetchLimit, offset: offset) { result in
        switch result {
        case .failure(let error):
          self.alertService.prompt(
            title: "Network Error",
            body: error.localizedDescription,
            actionTitle: nil, actionHandler: nil)
          
        case .success(let businesses):
          let businessViewModels = businesses
            .map { BusinessViewModel(model: $0, imageCachingService: self.imageCachingService) }
          if offset == 0 {
            self.businesses = businessViewModels
          } else {
            self.businesses.append(contentsOf: businessViewModels)
          }
          self._sectionUpdates.accept(())
        }
    }
  }
  
  func didSelectBusiness(_ businessViewModel: BusinessViewModel) {
    self.alertService.actionSheet(actions: [
      ActionSheetAction(
        text: "Open in App",
        handler: {
          self.delegate?.homeViewModel(self, openBusinessInApp: businessViewModel)
      }),
      ActionSheetAction(
        text: "Open in Safari",
        handler: {
          guard let urlString = businessViewModel.url.value,
            let url = URL(string: urlString) else { return }
          UIApplication.shared.open(url, options: [:], completionHandler: nil)
      }),
    ])
  }
}
