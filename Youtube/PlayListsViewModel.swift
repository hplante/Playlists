//
//  PlayListsViewModel.swift
//  Youtube
//
//  Created by Hugo Plante on 2020-09-02.
//  Copyright © 2020 HPS. All rights reserved.
//

import Foundation
import Combine

class PlaylistListViewModel: ObservableObject {

    let urlSession = URLSession(configuration: URLSessionConfiguration.default)
    @Published var playlists: [Playlist] = []

}

extension PlaylistListViewModel {

    func getPLaylists() {
        guard let baseURL = URL(string: "https://www.googleapis.com/youtube") else { return }

        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        urlComponents?.path = "v3/playlists"
        urlComponents?.queryItems = [
           URLQueryItem(name: "part", value: "snippet,contentDetails"),
           URLQueryItem(name: "maxResults", value: "25"),
           URLQueryItem(name: "mine", value: "true"),
           URLQueryItem(name: "key", value: Constants.Google.apiKey)
        ]

        guard let requestURL = urlComponents?.url else { return }

        let urlRequest = URLRequest(url: requestURL)

        _ = urlSession.dataTaskPublisher(for: urlRequest).map { (data, response) -> Data in

            return data

        }.tryMap { (data) -> Playlist in

            let jsonDecoder = JSONDecoder()

            return try jsonDecoder.decode(Playlist.self, from: data)

        }.receive(on: DispatchQueue.main).sink(receiveCompletion: { (subscriber) in

            switch subscriber {
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            case .finished:
                break
            }

        }) {[weak self] (playlist) in

            self?.playlists.insert(playlist, at: 0)

        }

    }

}

