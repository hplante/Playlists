//
//  PlaylistsResponse.swift
//  Youtube
//
//  Created by Hugo Plante on 2020-09-02.
//  Copyright © 2020 HPS. All rights reserved.
//

import Foundation

struct PlaylistsResponse: Decodable, PaginationResponse {
    let nextPageToken: String?
    let playlists: [Playlist]

    enum CodingKeys: String, CodingKey {
        case playlists = "items"
        case nextPageToken
    }
}
