//
//  Video.swift
//  Youtube
//
//  Created by Hugo Plante on 2020-09-03.
//  Copyright © 2020 HPS. All rights reserved.
//

import Foundation

struct Video: Decodable, Identifiable {
    let id: String
    let title: String
    let thumbnailUrl: URL
    let author: String
    let duration: String

    enum CodingKeys: String, CodingKey {
        case id, snippet, contentDetails
    }

    enum SnippetCodingKeys: String, CodingKey {
        case title, thumbnails, channelTitle
    }

    enum ThumbnailsCodingKeys: String, CodingKey {
        case standard
    }

    enum ThumbnailCodingKeys: String, CodingKey {
        case url
    }

    enum ContentDetailsCodingKeys: String, CodingKey {
        case duration
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)

        let snippetContainer = try container.nestedContainer(keyedBy: SnippetCodingKeys.self, forKey: .snippet)

        title = try snippetContainer.decode(String.self, forKey: .title)
        author = try snippetContainer.decode(String.self, forKey: .channelTitle)

        let contentDetailsContainer = try container.nestedContainer(keyedBy: ContentDetailsCodingKeys.self, forKey: .contentDetails)

        let durationString = try contentDetailsContainer.decode(String.self, forKey: .duration)
        let durationDateComponent = DateComponents.durationFrom8601String(durationString: durationString)
        var duration = String(format: "%d:%02d", durationDateComponent.minute ?? 0, durationDateComponent.second ?? 0)
        if let hour = durationDateComponent.hour,  hour > 0 {
            duration = String(format: "%d:%@", hour, duration) // TODO: ok should continue days an so on
        }
        self.duration = duration

        let thumbnailsContainer = try snippetContainer.nestedContainer(keyedBy: ThumbnailsCodingKeys.self, forKey: .thumbnails)

        let standardThumbnailsCotainer = try thumbnailsContainer.nestedContainer(keyedBy: ThumbnailCodingKeys.self, forKey: .standard)

        thumbnailUrl = try standardThumbnailsCotainer.decode(URL.self, forKey: .url)
    }
}

extension Video {
    private init(id: String, title: String, thumbnailUrl: URL, author: String, duration: String) {
        self.id = id
        self.title = title
        self.thumbnailUrl = thumbnailUrl
        self.author = author
        self.duration = duration
    }

    static let preview = Video(id: "id", title: "title", thumbnailUrl: URL(staticString: "https://i.ytimg.com/vi/m4JwEbSSflg/sddefault.jpg"), author: "author", duration: "32:34")
}
