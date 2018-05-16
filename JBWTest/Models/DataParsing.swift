//
//  DataParsing.swift
//  JBWTest
//
//  Created by Kseniia Poternak on 15.05.2018.
//  Copyright © 2018 Kseniia Poternak. All rights reserved.
//

import Foundation

// Struct for parsing error's messages
struct ErrorMessage {

    let message: String
    let success: Int

    struct Keys {
        static let errors = "errors"
        static let message = "message"
        static let success = "success"
    }

    init?(json: [String: Any]) {
        guard let success = json["success"] as? Int,
            let errors = json[Keys.errors] as? [[String: Any]],
            let error = errors.first,
            let message = error[Keys.message] as? String
            else { return nil }

        self.message = message
        self.success = success
    }
}

// Struct for parsing access_token or error's messages
struct AccessToken {

    let token: String
    let success: Int

    struct Keys {
        static let data = "data"
        static let accessToken = "access_token"
        static let success = "success"
    }

    init?(json: [String: Any]) {
        guard let success = json["success"] as? Int,
            let data = json[Keys.data] as? [String: Any],
            let accessTokenString = data[Keys.accessToken] as? String
            else { return nil }

        self.token = accessTokenString
        self.success = success
    }

}
