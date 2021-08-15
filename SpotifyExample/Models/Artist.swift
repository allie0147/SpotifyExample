//
//  Artist.swift
//  SpotifyExample
//
//  Created by Allie Kim on 2021/04/28.
//

import Foundation

struct Artist: Codable {
    let id: String
    let name: String
    let type: String
    let external_urls: [String: String]
    let images: [APIImage]?
}
