//
//  PlayListsViewModel.swift
//  Youtube
//
//  Created by Hugo Plante on 2020-09-02.
//  Copyright © 2020 HPS. All rights reserved.
//

import SwiftUI
import Combine

class PlaylistListViewModel: ObservableObject {
    @Published var playlists: [Playlist] = []
    let youtubeFetcher: YoutubeFetchable

    private var pageToken: String? = nil
    private var disposables = Set<AnyCancellable>()

    private let loadedPagePublisher = PassthroughSubject<PlaylistsResponse, YoutubeError>()
    private let finishedPublisher: AnyPublisher<[Playlist], YoutubeError>

    init(youtubeFetcher: YoutubeFetchable) {
        self.youtubeFetcher = youtubeFetcher
        self.finishedPublisher = loadedPagePublisher
        .reduce([Playlist](), { allItems, response in
            return response.playlists + allItems
        })
        .eraseToAnyPublisher()
    }

    func fetchPlaylists() {
        pageToken = nil
        finishedPublisher
          .receive(on: DispatchQueue.main)
          .sink(
            receiveCompletion: { [weak self] value in
                guard let self = self else { return }
                switch value {
                case .failure:
                    self.playlists = []
                case .finished:
                    break
                }
            },
            receiveValue: { [weak self] playlists in
                guard let self = self else { return }
                self.playlists = playlists.filter { !$0.isPublic }
            })
          .store(in: &disposables)

        initiateLoadSequence()
    }

    private func loadPage() -> AnyPublisher<PlaylistsResponse, YoutubeError> {
        return youtubeFetcher.playlists(pageToken: pageToken)
    }

    func initiateLoadSequence() {
      loadPage()
        .sink(
            receiveCompletion: { result in
                switch result {
                case .failure(let error):
                    self.loadedPagePublisher.send(completion: .failure(error))
                case .finished:
                    break
                }
            },
            receiveValue: { response in
            self.loadedPagePublisher.send(response)

            if response.nextPageToken == nil {
                self.loadedPagePublisher.send(completion: .finished)
            } else {
                self.pageToken = response.nextPageToken
                self.initiateLoadSequence()
            }
        })
        .store(in: &disposables)
    }
}
