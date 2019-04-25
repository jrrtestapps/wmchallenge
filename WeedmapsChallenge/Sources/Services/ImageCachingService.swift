//
//  ImageCachingService.swift
//  WeedmapsChallenge
//
//  Created by Jason Rapai on 4/23/19.
//  Copyright © 2019 Weedmaps, LLC. All rights reserved.
//

import UIKit
import Alamofire

protocol ImageCachingServiceProtocol: class {
  @discardableResult
  func image(for uri: String, completion: @escaping (Swift.Result<UIImage, Error>) -> Void) -> URLSessionTask?
}

class ImageCachingService: ImageCachingServiceProtocol {
  private var cache: [String: UIImage] = [:]
  
  @discardableResult
  func image(for uri: String, completion: @escaping (Swift.Result<UIImage, Error>) -> Void) -> URLSessionTask? {
    let uri = uri.replacingOccurrences(of: "http:", with: "https:")
    if let image = self.cache[uri] {
      completion(.success(image))
      return nil
    }
    guard let url = URL(string: uri) else {
      completion(.failure(APIServiceError.invalidURL))
      return nil
    }
    return Alamofire.request(
      url,
      method: .get)
      .validate()
      .responseData { response in
        if let error = response.result.error {
          completion(.failure(error))
          return
        } else if let data = response.result.value,
          let image = UIImage(data: data) {
          self.cache[uri] = image
          completion(.success(image))
        } else {
          completion(.failure(APIServiceError.unableToDecodeResults))
        }
      }
      .task
  }
}
