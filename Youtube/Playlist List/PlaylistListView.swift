//
//  PlaylistsView.swift
//  Youtube
//
//  Created by Hugo Plante on 2020-09-02.
//  Copyright © 2020 HPS. All rights reserved.
//

import SwiftUI

struct PlaylistListView: View {
    @ObservedObject var viewModel: PlaylistListViewModel

    var body: some View {
        NavigationView {
            List(viewModel.playlists) { playlist in

                NavigationLink(destination: PlaylistDetailsView(viewModel: PlaylistDetailsViewModel(youtubeFetcher: self.viewModel.youtubeFetcher, playlist: playlist))) {
                    PlaylistListRow(playlist: playlist)
                }
            }
            .navigationBarTitle("Playlists")
        }
        .onAppear {
            self.viewModel.fetchPlaylists()
        }
    }
}

struct PlaylistsView_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistListView(viewModel: PlaylistListViewModel(youtubeFetcher: YoutubeFetcher()))
    }
}

