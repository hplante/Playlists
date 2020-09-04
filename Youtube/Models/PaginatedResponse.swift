//
//  PaginationResponse.swift
//  Youtube
//
//  Created by Hugo Plante on 2020-09-04.
//  Copyright © 2020 HPS. All rights reserved.
//

import Foundation

protocol PaginationResponse {
    var nextPageToken: String? { get }
}
