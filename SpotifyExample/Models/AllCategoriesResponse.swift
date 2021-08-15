//
//  CategoriesResponse.swift
//  SpotifyExample
//
//  Created by Allie Kim on 2021/05/03.
//

import Foundation

struct AllCategoriesResponse: Codable {
    let categories: Categories
}

struct Categories: Codable {
    let items: [Category]
}

struct Category: Codable {
    let id: String
    let icons: [APIImage]
    let name: String
}
