//
//  Recommendations.swift
//  SpotifyRecommender
//
//  Created by 90303054 on 5/17/20.
//  Copyright © 2020 90303054. All rights reserved.
//

import Foundation
struct Track: Codable {
    var name: String
    var duration: Int
    var artists: [Artist]
    var album: Album
    var externalURL: [String : String]
    var uri: String
    var id: String
    enum CodingKeys: String, CodingKey {
        case uri
        case id
        case artists
        case album
        case name
        case duration = "duration_ms"
        case externalURL = "external_urls"
    }
}

struct Album: Codable {
    var name: String
    var id: String
    var uri: String
    var images: [AlbumImage]
}
struct AlbumImage: Codable {
    var height: Int
    var width: Int
    var url: String
}

struct Artist: Codable {
    var name: String
    var id: String
    var uri: String
}

struct Recommendations: Codable {
    var tracks: [Track]
}


