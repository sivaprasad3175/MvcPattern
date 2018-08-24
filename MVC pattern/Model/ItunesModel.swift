//
//  ItunesModel.swift
//  MVC pattern
//
//  Created by siva prasad on 24/08/18.
//  Copyright © 2018 SIVA PRASAD. All rights reserved.
//

import Foundation
class ItunesModel {
    struct appleApi: Decodable {
        let feed: Feed
    }
    struct Feed: Decodable {
        let results: [Results]
    }
    struct Results: Decodable {
        let name: String
        let artworkUrl100: String
    }
}
