//
//  BusinessViewModel.swift
//  WeedmapsChallenge
//
//  Created by Jason Rapai on 4/24/19.
//  Copyright © 2019 Weedmaps, LLC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class BusinessViewModel {
  private let imageCachingService: ImageCachingServiceProtocol
  
  let name: BehaviorRelay<String?> = BehaviorRelay(value: nil)
  let url: BehaviorRelay<String?> = BehaviorRelay(value: nil)
  let imageURL: BehaviorRelay<String?> = BehaviorRelay(value: nil)
  let image: BehaviorRelay<UIImage?> = BehaviorRelay(value: nil)
  
  private var imageTask: URLSessionTask?
  
  init(model: Business, imageCachingService: ImageCachingServiceProtocol) {
    self.imageCachingService = imageCachingService
    
    self.name.accept(model.name)
    self.url.accept(model.url)
    self.imageURL.accept(model.imageURL)
    self.image.accept(nil)
    self.imageTask?.cancel()
  }
  
  func fetchImage() {
    guard let imageURL = self.imageURL.value else { return }
    self.imageTask = self.imageCachingService.image(for: imageURL) { result in
      switch result {
      case .failure(_):
        self.image.accept(nil)
      case .success(let image):
        self.image.accept(image)
      }
    }
  }
}
