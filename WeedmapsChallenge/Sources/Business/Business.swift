//
//  Copyright © 2018 Weedmaps, LLC. All rights reserved.
//

import Foundation

struct BusinessResults: Decodable {
  let total: Int
  let businesses: [Business]
}

struct Business: Decodable {
  let name: String?
  let url: String?
  let rating: Decimal?
  let imageURL: String?
  
  enum CodingKeys : String, CodingKey {
    case name
    case url
    case rating
    case imageURL = "image_url"
  }
}
