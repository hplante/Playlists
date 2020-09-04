//
//  YoutubeFetcher.swift
//  Youtube
//
//  Created by Hugo Plante on 2020-09-02.
//  Copyright © 2020 HPS. All rights reserved.
//

import Combine
import Foundation
import GoogleSignIn

func decode<T: Decodable>(_ data: Data) -> AnyPublisher<T, YoutubeError> {
  let decoder = JSONDecoder()
  decoder.dateDecodingStrategy = .secondsSince1970

  return Just(data)
    .decode(type: T.self, decoder: decoder)
    .mapError { error in
      .parsing(description: error.localizedDescription)
    }
    .eraseToAnyPublisher()
}

protocol YoutubeFetchable {
    func playlists(pageToken: String?) -> AnyPublisher<PlaylistsResponse, YoutubeError>
    func playlistDetails(playlistId: String, pageToken: String?) -> AnyPublisher<PlaylistDetailsResponse, YoutubeError>
    func videos(videoIds: [String]) -> AnyPublisher<VideosResponse, YoutubeError>
}

extension YoutubeFetchable {
    func playlists() -> AnyPublisher<PlaylistsResponse, YoutubeError> {
        return playlists(pageToken: nil)
    }
}

class YoutubeFetcher {
  private let session: URLSession

  init(session: URLSession = .shared) {
    self.session = session
  }
}

// MARK: - YoutubeFetcher
extension YoutubeFetcher: YoutubeFetchable {
    func playlists(pageToken: String?) -> AnyPublisher<PlaylistsResponse, YoutubeError> {
        return fetch(with: makePlaylistsComponents(withPageToken: pageToken))
    }

    func playlistDetails(playlistId: String, pageToken: String?) -> AnyPublisher<PlaylistDetailsResponse, YoutubeError> {
        return fetch(with: makePlaylistDetailsComponents(withPlaylistId: playlistId, pageToken: pageToken))
    }

    func videos(videoIds: [String]) -> AnyPublisher<VideosResponse, YoutubeError> {
        return fetch(with: makeVideosComponents(withVideoIds: videoIds))
    }

    private func fetch<T>(with components: URLComponents) -> AnyPublisher<T, YoutubeError> where T: Decodable {
        guard let url = components.url else {
            let error = YoutubeError.network(description: "Couldn't create URL")
            return Fail(error: error).eraseToAnyPublisher()
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        guard let accesToken = GIDSignIn.sharedInstance().currentUser?.authentication.accessToken else {
            let error = YoutubeError.network(description: "Couldn't get access token")
            return Fail(error: error).eraseToAnyPublisher()
        }
        urlRequest.addValue("Bearer \(accesToken)", forHTTPHeaderField: "Authorization")
        return session.dataTaskPublisher(for: urlRequest)
            .mapError { error in
                .network(description: error.localizedDescription)
            }
            .flatMap(maxPublishers: .max(1)) { pair in
                decode(pair.data)
            }
            .eraseToAnyPublisher()
    }
}

// MARK: - Youtube API
private extension YoutubeFetcher {
    struct YoutubeAPI {
        static let scheme = "https"
        static let host = "www.googleapis.com"
        static let path = "/youtube"
        static let key = Constants.Google.apiKey
    }

    func makePlaylistsComponents(withPageToken pageToken: String?) -> URLComponents {
        var components = URLComponents()
        components.scheme = YoutubeAPI.scheme
        components.host = YoutubeAPI.host
        components.path = YoutubeAPI.path + "/v3/playlists"

        var queryItems = [
            URLQueryItem(name: "part", value: "snippet,contentDetails,status"),
            URLQueryItem(name: "maxResults", value: "5"),
            URLQueryItem(name: "mine", value: "true"),
            URLQueryItem(name: "key", value: YoutubeAPI.key)
        ]

        if let pageToken = pageToken {
            queryItems.append(URLQueryItem(name: "pageToken", value: pageToken))
        }

        components.queryItems = queryItems

        return components
    }

    func makePlaylistDetailsComponents(withPlaylistId playlistId: String, pageToken: String?) -> URLComponents {
        var components = URLComponents()
        components.scheme = YoutubeAPI.scheme
        components.host = YoutubeAPI.host
        components.path = YoutubeAPI.path + "/v3/playlistItems"

        var queryItems = [
            URLQueryItem(name: "part", value: "snippet,contentDetails"),
            URLQueryItem(name: "maxResults", value: "5"),
            URLQueryItem(name: "playlistId", value: playlistId),
            URLQueryItem(name: "key", value: YoutubeAPI.key)
        ]

        if let pageToken = pageToken {
            queryItems.append(URLQueryItem(name: "pageToken", value: pageToken))
        }

        components.queryItems = queryItems

        return components
    }

    func makeVideosComponents(withVideoIds videoIds: [String]) -> URLComponents {
        var components = URLComponents()
        components.scheme = YoutubeAPI.scheme
        components.host = YoutubeAPI.host
        components.path = YoutubeAPI.path + "/v3/videos"

        var queryItems = [
            URLQueryItem(name: "part", value: "snippet,contentDetails"),
            URLQueryItem(name: "key", value: YoutubeAPI.key)
        ]

        for videoId in videoIds {
            queryItems.append(URLQueryItem(name: "id", value: videoId))
        }

        components.queryItems = queryItems

        return components
    }
}
