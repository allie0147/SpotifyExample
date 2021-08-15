//
//  RecommendationsResponse.swift
//  SpotifyExample
//
//  Created by Allie Kim on 2021/04/30.
//

import Foundation

struct RecommendationsResponse: Codable {
    let tracks: [AudioTrack]
}
