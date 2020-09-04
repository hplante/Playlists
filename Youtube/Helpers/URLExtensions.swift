//
//  URLExtensions.swift
//  Youtube
//
//  Created by Hugo Plante on 2020-09-04.
//  Copyright © 2020 HPS. All rights reserved.
//

import Foundation

extension URL {
    init(staticString string: StaticString) {
        guard let url = URL(string: "\(string)") else {
            preconditionFailure("Invalid static URL string: \(string)")
        }
        self = url
    }
}
