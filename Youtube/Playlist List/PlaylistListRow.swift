//
//  PlaylistRow.swift
//  Youtube
//
//  Created by Hugo Plante on 2020-09-02.
//  Copyright © 2020 HPS. All rights reserved.
//

import SwiftUI

struct PlaylistListRow: View {
    @Environment(\.imageCache) var cache: ImageCache
    var playlist: Playlist
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            AsyncImage(
                url: playlist.thumbnailUrl,
                cache: self.cache,
                placeholder: Text("Loading ..."),
                configuration: {
                    AnyView($0.resizable().aspectRatio(contentMode: .fill).frame(width: 50, height: 50).clipped())
                }
            )
            VStack(alignment: .leading) {
                Text(playlist.title).font(.headline)
                Text("\(playlist.videoCount) videos").font(.subheadline)
            }
        }
    }
}

struct PlaylistListRow_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistListRow(playlist: Playlist.preview)
    }
}
