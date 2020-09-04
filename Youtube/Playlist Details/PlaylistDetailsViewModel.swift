//
//  PlaylistDetailsViewModel.swift
//  Youtube
//
//  Created by Hugo Plante on 2020-09-02.
//  Copyright © 2020 HPS. All rights reserved.
//

import SwiftUI
import Combine

class PlaylistDetailsViewModel: ObservableObject {
    @Published var playlist: Playlist
    @Published var videos: [Video] = []

    private let youtubeFetcher: YoutubeFetchable
    private var disposables = Set<AnyCancellable>()

    init(youtubeFetcher: YoutubeFetchable, playlist: Playlist, scheduler: DispatchQueue = DispatchQueue(label: "PlaylistDetailsViewModel")) {
        self.youtubeFetcher = youtubeFetcher
        self.playlist = playlist
    }

    func fetchPlaylistDetails() {
        let loader = RecursivePlaylistLoader(playlistId: playlist.id, youtubeFetcher: youtubeFetcher)
        let videoIds = loader.finishedPublisher.compactMap {
            $0.map { $0.videoId }
        }
        let videos = videoIds.flatMap {
            self.youtubeFetcher.videos(videoIds: $0 )
        }
        videos.receive(on: DispatchQueue.main)
        .sink(
            receiveCompletion: { [weak self] value in
                guard let self = self else { return }
                switch value {
                case .failure:
                    self.videos = []
                case .finished:
                    break
                }
            },
            receiveValue: { [weak self] videosResponse in
                guard let self = self else { return }
                self.videos = videosResponse.videos
        })
        .store(in: &disposables)

        loader.initiateLoadSequence()
    }
}


class RecursivePlaylistLoader {
    let youtubeFetcher: YoutubeFetchable

    var playlistId: String
    var pageToken: String? = nil

    private let loadedPagePublisher = PassthroughSubject<PlaylistDetailsResponse, YoutubeError>()
    let finishedPublisher: AnyPublisher<[Track], YoutubeError>

    var cancellables = Set<AnyCancellable>()

    init(playlistId: String, youtubeFetcher: YoutubeFetchable) {
        self.playlistId = playlistId
        self.youtubeFetcher = youtubeFetcher

        self.finishedPublisher = loadedPagePublisher
            .reduce([Track](), { allItems, response in
                return response.tracks + allItems
            })
            .eraseToAnyPublisher()
    }

    private func loadPage() -> AnyPublisher<PlaylistDetailsResponse, YoutubeError> {
        return youtubeFetcher.playlistDetails(playlistId: playlistId, pageToken: pageToken)
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
        .store(in: &cancellables)
    }
}
