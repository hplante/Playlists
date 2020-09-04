//
//  PlaylistDetailsView.swift
//  Youtube
//
//  Created by Hugo Plante on 2020-09-02.
//  Copyright © 2020 HPS. All rights reserved.
//

import SwiftUI

struct PlaylistDetailsView: View {
    @ObservedObject var viewModel: PlaylistDetailsViewModel

    var body: some View {
        List {
            Section(header: PlaylistHeader(playlist: viewModel.playlist)) {
                ForEach(viewModel.videos) { video in
                    PlaylistTrackRow(video: video)
                }
            }
        }
        .navigationBarTitle(viewModel.playlist.title)
        .onAppear() {
            self.viewModel.fetchPlaylistDetails()
        }
    }
}

struct PlaylistHeader: View {
    @State var playlist: Playlist
    var body: some View {
        Text("\(playlist.videoCount) videos").font(.headline)
    }
}

struct PlaylistDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistDetailsView(viewModel: PlaylistDetailsViewModel(youtubeFetcher: YoutubeFetcher(), playlist: Playlist.preview))
    }
}

