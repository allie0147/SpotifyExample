//
//  UserProfile.swift
//  SpotifyExample
//
//  Created by Allie Kim on 2021/04/28.
//

import Foundation

struct UserProfile: Codable {
    let country: String
    let display_name: String
    let email: String
//    let explicit_content: [String: Bool]
//    let external_urls: [String: String]
//    let followers: [String: Codable?]
    let id: String
    let product: String
    let type: String
    let images: [APIImage]
}
