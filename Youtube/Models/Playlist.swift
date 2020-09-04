//
//  YoutubePlaylist.swift
//  Youtube
//
//  Created by Hugo Plante on 2020-09-02.
//  Copyright © 2020 HPS. All rights reserved.
//

import Foundation

struct Playlist: Decodable, Identifiable {
    let id: String
    let title: String
    let thumbnailUrl: URL
    let videoCount: Int
    let privacyStatus: String

    enum CodingKeys: String, CodingKey {
        case id, snippet, contentDetails, status
    }

    enum SnippetCodingKeys: String, CodingKey {
        case title, thumbnails
    }

    enum StatusCodingKeys: String, CodingKey {
        case privacyStatus
    }

    enum ThumbnailsCodingKeys: String, CodingKey {
        case `default`
    }

    enum ThumbnailCodingKeys: String, CodingKey {
        case url
    }

    enum ContentDetailsCodingKeys: String, CodingKey {
        case itemCount
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)

        let snippetContainer = try container.nestedContainer(keyedBy: SnippetCodingKeys.self, forKey: .snippet)

        title = try snippetContainer.decode(String.self, forKey: .title)

        let statusContainer = try container.nestedContainer(keyedBy: StatusCodingKeys.self, forKey: .status)

        privacyStatus = try statusContainer.decode(String.self, forKey: .privacyStatus)

        let contentDetailsContainer = try container.nestedContainer(keyedBy: ContentDetailsCodingKeys.self, forKey: .contentDetails)

        videoCount = try contentDetailsContainer.decode(Int.self, forKey: .itemCount)

        let thumbnailsContainer = try snippetContainer.nestedContainer(keyedBy: ThumbnailsCodingKeys.self, forKey: .thumbnails)

        let standardThumbnailsCotainer = try thumbnailsContainer.nestedContainer(keyedBy: ThumbnailCodingKeys.self, forKey: .default)

        thumbnailUrl = try standardThumbnailsCotainer.decode(URL.self, forKey: .url)


    }
}

extension Playlist {
    var isPublic: Bool {
        privacyStatus == "public"
    }
}

extension Playlist {
    private init(id: String, title: String, thumbnailUrl: URL, videoCount: Int, privacyStatus: String) {
        self.id = id
        self.title = title
        self.thumbnailUrl = thumbnailUrl
        self.videoCount = videoCount
        self.privacyStatus = privacyStatus
    }

    static let preview = Playlist(id: "id", title: "title", thumbnailUrl: URL(staticString: "https://i.ytimg.com/vi/m4JwEbSSflg/sddefault.jpg"), videoCount: 3, privacyStatus: "public")
}
