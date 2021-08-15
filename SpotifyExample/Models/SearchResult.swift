//
//  SearchResult.swift
//  SpotifyExample
//
//  Created by Allie Kim on 2021/05/03.
//

import Foundation

enum SearchResult {
    case artist(model: Artist)
    case album(model: Album)
    case track(model: AudioTrack)
    case playlist(model: Playlist)
}
