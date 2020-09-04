//
//  PlaylistRow.swift
//  Youtube
//
//  Created by Hugo Plante on 2020-09-02.
//  Copyright © 2020 HPS. All rights reserved.
//

import SwiftUI

struct PlaylistListRow: View {
    var playlist: Playlist
    var body: some View {
        VStack {
            Text(playlist.title)
        }
    }
}

struct PlaylistRow_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistListRow(playlist: Playlist.preview)
    }
}
