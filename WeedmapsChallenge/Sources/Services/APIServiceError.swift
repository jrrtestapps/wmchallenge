//
//  APIServiceError.swift
//  WeedmapsChallenge
//
//  Created by Jason Rapai on 4/23/19.
//  Copyright © 2019 Weedmaps, LLC. All rights reserved.
//

import Foundation

enum APIServiceError: Error {
  case invalidURL
  case unableToDecodeResults
}
