//
//  APICaller.swift
//  SpotifyExample
//
//  Created by Allie Kim on 2021/04/28.
//

import Foundation

final class APICaller {
    static let shared = APICaller()

    private init() {
    }

    struct Constants {
        static let baseAPIURL = "https://api.spotify.com/v1"
    }

    enum HTTPMethod: String {
        case GET
        case POST
    }

    enum APIError: Error {
        case failedToGetData
    }

    private func createReqeust(
        with url: URL?,
        type: HTTPMethod,
        completion: @escaping (URLRequest) -> Void
    ) {
        AuthManager.shared.withValidToken { token in
            guard let apiURL = url else { return }
            // set request
            var request = URLRequest(url: apiURL)
            // set header
            request.setValue("Bearer \(token)",
                             forHTTPHeaderField: "Authorization")
            // set method
            request.httpMethod = type.rawValue
            // set timeout
            request.timeoutInterval = 30
            // return request
            completion(request)
        }
    }
    // MARK: -Albums
    public func getAlbumDetails(for album: Album, completion: @escaping(Result<AlbumDetailsResponse, Error>) -> Void) {
        createReqeust(
            with: URL(string: Constants.baseAPIURL + "/albums/" + album.id),
            type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    return completion(.failure(APIError.failedToGetData))
                }

                do {
//                    print(try JSONSerialization.jsonObject(with: data, options: .allowFragments))
                    let result = try JSONDecoder().decode(AlbumDetailsResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }

    // MARK: -Playlists
    public func getPlaylistDetails(for playlist: Playlist, completion: @escaping(Result<PlaylistDetailsResponse, Error>) -> Void) {
        createReqeust(
            with: URL(string: Constants.baseAPIURL + "/playlists/" + playlist.id),
            type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    return completion(.failure(APIError.failedToGetData))
                }

                do {
                    let result = try JSONDecoder().decode(PlaylistDetailsResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }


    // MARK: -Profile
    public func getCurrentUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        createReqeust(
            with: URL(string: Constants.baseAPIURL + "/me"),
            type: .GET
        ) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data = data, error == nil else {
                    return completion(.failure(APIError.failedToGetData))
                }

                do {
//                    let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    let result = try JSONDecoder().decode(UserProfile.self, from: data)
//                    print(result)
                    completion(.success(result))
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }

    // MARK: -Browse
    public func getNewReleases(completion: @escaping (Result<NewReleaseResponse, Error>) -> Void) {
        createReqeust(
            with: URL(string: Constants.baseAPIURL + "/browse/new-releases?limit=50"),
            type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    return completion(.failure(APIError.failedToGetData))
                }

                do {
//                    let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    let result = try JSONDecoder().decode(NewReleaseResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }

    public func getFeaturedPlaylist(completion: @escaping(Result<FeaturedPlaylistResponse, Error>) -> Void) {
        createReqeust(
            with: URL(string: Constants.baseAPIURL + "/browse/featured-playlists?limit=20"),
            type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    return completion(.failure(APIError.failedToGetData))
                }

                do {
                    let result = try JSONDecoder().decode(FeaturedPlaylistResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }

    public func getRecommendedGenres(completion: @escaping(Result<RecommendedGenresResponse, Error>) -> Void) {
        createReqeust(
            with: URL(string: Constants.baseAPIURL + "/recommendations/available-genre-seeds"),
            type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    return completion(.failure(APIError.failedToGetData))
                }

                do {
                    let result = try JSONDecoder().decode(RecommendedGenresResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }

    public func getRecommendations(genres: Set<String>, completion: @escaping(Result<RecommendationsResponse, Error>) -> Void) {

        let seeds = genres.joined(separator: ",")

        createReqeust(
            with: URL(string: Constants.baseAPIURL + "/recommendations?limit=40&seed_genres=\(seeds)"),
            type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    return completion(.failure(APIError.failedToGetData))
                }

                do {
                    let result = try JSONDecoder().decode(RecommendationsResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }

    // MARK: -Category
    public func getCategories(completion: @escaping(Result<[Category], Error>) -> Void) {
        createReqeust(
            with: URL(string: Constants.baseAPIURL + "/browse/categories?limit=50"),
            type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    return completion(.failure(APIError.failedToGetData))
                }
                do {
                    let result = try JSONDecoder().decode(AllCategoriesResponse.self, from: data)
                    completion(.success(result.categories.items))
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }

    public func getCategoryPlaylists(category: Category, completion: @escaping(Result<[Playlist], Error>) -> Void) {
        createReqeust(
            with: URL(string: Constants.baseAPIURL + "/browse/categories/\(category.id)/playlists?limit=50"),
            type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    return completion(.failure(APIError.failedToGetData))
                }
                do {
                    let result = try JSONDecoder().decode(CategoryPlaylistResponse.self, from: data)
                    completion(.success(result.playlists.items))
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }

    // MARK: -Search
    public func search(with query: String, completion: @escaping(Result<[SearchResult], Error>) -> Void) {
        let queryString = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

        createReqeust(
            with: URL(string: Constants.baseAPIURL + "/search?limit=10&type=album,artist,playlist,track&q=\(queryString)"),
            type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    return completion(.failure(APIError.failedToGetData))
                }

                do {
//                    let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
//                    print(result)
                    let result = try JSONDecoder().decode(SearchResultResponse.self, from: data)
                    
                    var searchResults: [SearchResult] = []
                    searchResults.append(contentsOf: result.tracks.items.compactMap { .track(model: $0) })
                    searchResults.append(contentsOf: result.albums.items.compactMap { .album(model: $0) })
                    searchResults.append(contentsOf: result.artists.items.compactMap { .artist(model: $0) })
                    searchResults.append(contentsOf: result.playlists.items.compactMap { .playlist(model: $0) })
                    
                    completion(.success(searchResults))
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
}
