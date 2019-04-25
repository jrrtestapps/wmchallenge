//
//  YelpAPIService.swift
//  WeedmapsChallenge
//
//  Created by Jason Rapai on 4/23/19.
//  Copyright © 2019 Weedmaps, LLC. All rights reserved.
//

import Foundation
import Alamofire

protocol YelpAPIServiceProtocol: class {
  @discardableResult
  func getBusinessSearch(searchTerm: String?, location: Location, limit: Int, offset: Int, completion: @escaping (Swift.Result<[Business], Error>) -> Void) -> URLSessionTask?
}

class YelpAPIService: YelpAPIServiceProtocol {
  private let apiKey: String = "CyGqU438adnsrQJ77SDDnxJuB0dYXGNxvSlPaxsF9Kf8TP9Oddfr6xVyeCD9m3mK0JIEYEdnZil-uHafDCCgM696cVCIiPzbAgvEZHxLiqZrNCSw2a8VBxByGuW_XHYx"
  let baseURI: String
  
  private var headers: HTTPHeaders {
    return ["Authorization": "Bearer \(self.apiKey)"]
  }
  
  init(baseURI: String) {
    self.baseURI = baseURI
  }
  
  @discardableResult
  func getBusinessSearch(searchTerm: String?, location: Location, limit: Int, offset: Int, completion: @escaping (Swift.Result<[Business], Error>) -> Void) -> URLSessionTask? {
    guard let url = URL(string: "\(self.baseURI)/businesses/search") else {
      completion(.failure(APIServiceError.invalidURL))
      return nil
    }
    
    var parameters: [String: Any] = [
      "limit": limit,
      "offset": offset,
      "latitude": location.latitude,
      "longitude": location.longitude,
    ]
    
    if let term = searchTerm {
      parameters["term"] = term
    }
    
    return Alamofire.SessionManager.default.request(
      url,
      method: .get,
      parameters: parameters,
      headers: self.headers)
      .validate()
      .responseData { response in
        if let error = response.result.error {
          completion(.failure(error))
          return
        } else if let data = response.result.value,
          let businessResults = try? JSONDecoder().decode(BusinessResults.self, from: data) {
          completion(.success(businessResults.businesses))
        } else {
          completion(.failure(APIServiceError.unableToDecodeResults))
        }
      }
      .task
  }
}

class MockYelpAPIService: YelpAPIServiceProtocol {
  var getBusinessSearchTestClosure: ((_ searchTerm: String?, _ location: Location, _ limit: Int, _ offset: Int, _ completion: @escaping ((Swift.Result<[Business], Error>) -> Void)) -> URLSessionTask?)?
  func getBusinessSearch(searchTerm: String?, location: Location, limit: Int, offset: Int, completion: @escaping ((Swift.Result<[Business], Error>) -> Void)) -> URLSessionTask? {
//    completion(.success([
//      Business(name: "testName", url: "https://www.yelp.com", rating: 4, imageURL: "http://s3-media2.fl.yelpcdn.com/bphoto/MmgtASP3l_t4tPCL1iAsCg/o.jpg"),
//      Business(name: "testName2", url: "https://www.yelp.com", rating: 3.5, imageURL: "http://s3-media2.fl.yelpcdn.com/bphoto/MmgtASP3l_t4tPCL1iAsCg/o.jpg"),
//      Business(name: "testName3 is a much longer name that should wrap", url: "https://www.yelp.com", rating: 5, imageURL: "http://s3-media2.fl.yelpcdn.com/bphoto/MmgtASP3l_t4tPCL1iAsCg/o.jpg"),
//    ]))
    return getBusinessSearchTestClosure?(searchTerm, location, limit, offset, completion)
  }
}
