//
//  PlaylistDetailsResponse.swift
//  Youtube
//
//  Created by Hugo Plante on 2020-09-02.
//  Copyright © 2020 HPS. All rights reserved.
//

import Foundation

struct PlaylistDetailsResponse: Decodable, PaginationResponse {
    let nextPageToken: String?
    let tracks: [Track]

    enum CodingKeys: String, CodingKey {
        case tracks = "items"
        case nextPageToken
    }
}
