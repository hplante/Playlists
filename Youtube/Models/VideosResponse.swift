//
//  VideosResponse.swift
//  Youtube
//
//  Created by Hugo Plante on 2020-09-03.
//  Copyright © 2020 HPS. All rights reserved.
//

import Foundation

struct VideosResponse: Decodable, PaginationResponse {
    let nextPageToken: String?
    let videos: [Video]

    enum CodingKeys: String, CodingKey {
        case videos = "items"
        case nextPageToken
    }
}
