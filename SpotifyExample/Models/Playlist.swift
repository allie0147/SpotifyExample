//
//  Playlist.swift
//  SpotifyExample
//
//  Created by Allie Kim on 2021/04/28.
//

import Foundation

struct Playlist: Codable {
    let description: String
    let external_urls: [String: String]
    let id: String
    let images: [APIImage]
    let name: String
    let owner: User
}
