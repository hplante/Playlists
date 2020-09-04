//
//  PlaylistRow.swift
//  Youtube
//
//  Created by Hugo Plante on 2020-09-02.
//  Copyright © 2020 HPS. All rights reserved.
//

import SwiftUI

struct PlaylistTrackRow: View {
    @Environment(\.imageCache) var cache: ImageCache
    var video: Video
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            ZStack {
                AsyncImage(
                    url: video.thumbnailUrl,
                    cache: self.cache,
                    placeholder: Text("Loading ...").frame(width: 128, height: 72),
                    configuration: {
                        AnyView($0.resizable().aspectRatio(contentMode: .fill).frame(width: 128, height: 72).clipped())
                    }
                )
                VStack(alignment: .trailing) {
                    Spacer()
                    HStack() {
                        Spacer()
                        Text(video.duration).font(.caption).foregroundColor(.white).padding(2).background(Color.black)
                    }
                }.padding([.trailing, .bottom], 4)
            }.frame(width: 128, height: 72)
            VStack(alignment: .leading) {
                Text(video.title).font(.headline)
                Text(video.author).font(.subheadline)
            }
        }
    }
}

struct PlaylistTrackRow_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistTrackRow(video: Video.preview)
    }
}
