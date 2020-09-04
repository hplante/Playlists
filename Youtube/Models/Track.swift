//
//  Video.swift
//  Youtube
//
//  Created by Hugo Plante on 2020-09-02.
//  Copyright © 2020 HPS. All rights reserved.
//

import Foundation

struct Track: Decodable, Identifiable {
    let id: String
    let videoId: String

    enum CodingKeys: String, CodingKey {
        case id, snippet, contentDetails
    }

    enum ContentDetailsCodingKeys: String, CodingKey {
        case videoId
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)

        let contentDetailsContainer = try container.nestedContainer(keyedBy: ContentDetailsCodingKeys.self, forKey: .contentDetails)

        videoId = try contentDetailsContainer.decode(String.self, forKey: .videoId)
    }
}

extension Track {
    private init(id: String, videoId: String) {
        self.id = id
        self.videoId = videoId
    }

    static let preview = Track(id: "id", videoId: "videoId")
}
