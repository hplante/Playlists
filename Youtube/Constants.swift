//
//  Constants.swift
//  Youtube
//
//  Created by Hugo Plante on 2020-09-02.
//  Copyright © 2020 HPS. All rights reserved.
//

import Foundation

enum Constants {

    enum GoogleSignIn {
        static let clientID = Bundle.main.infoDictionary?["GOOGLE_CLIENT_ID"] as? String
        static let scopes: [String] = ["https://www.googleapis.com/auth/youtube.readonly"]
    }

    enum Google {
        static let apiKey = Bundle.main.infoDictionary?["GOOGLE_API_KEY"] as? String
    }
}
