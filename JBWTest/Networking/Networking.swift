//
//  Networking.swift
//  JBWTest
//
//  Created by Kseniia Poternak on 15.05.2018.
//  Copyright © 2018 Kseniia Poternak. All rights reserved.
//

import Foundation
import UIKit

private struct NetworkingConstants {
    static let signUpURL = "https://apiecho.cf/api/signup/"
    static let logInURL = "https://apiecho.cf/api/login/"
    static let getTextURL = "https://apiecho.cf/api/get/text/"
    static let value = "application/json"
    static let postHeader = "Content-Type"
    static let post = "POST"
    static let nameForLocale = "?locale="
    static let tokenType = "Bearer"
    static let getHeader = "Authorization"
}

class Networking {

    static let shared = Networking()

    /// Post request for sign up
    func signUp (name: String, email: String, password: String,
                 completionHandler: @escaping
        (_ messages: [ErrorMessage]) -> Void) {

        let baseURL = NetworkingConstants.signUpURL
        guard let url = URL(string: baseURL) else { return }
        var request = URLRequest(url: url)
        request.setValue(NetworkingConstants.value, forHTTPHeaderField: NetworkingConstants.postHeader)
        request.httpMethod = NetworkingConstants.post

        let parameters = ["name": name,
                          "email": email,
                          "password": password]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters,
                                                          options: .prettyPrinted)
        } catch {
            print(error.localizedDescription)
        }

        let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data,
                                                                      options: .mutableContainers) as? [String: Any]
                        else { return }

                    var messageInObject = [ErrorMessage]()
                    if let access = ErrorMessage(json: json) {
                        messageInObject.append(access)
                    }
                    completionHandler(messageInObject)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        task.resume()
    }

    /// Post request for log in.
    func logIn(email: String, password: String,
               completionHandler: @escaping
        (_ tokens: [AccessToken],
        _ messages: [ErrorMessage]) -> Void) {

        let baseURL = NetworkingConstants.logInURL
        guard let url = URL(string: baseURL) else { return }
        var request = URLRequest(url: url)
        request.setValue(NetworkingConstants.value,
                         forHTTPHeaderField: NetworkingConstants.postHeader)
        request.httpMethod = NetworkingConstants.post

        let parameters = ["email": email,
                          "password": password]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters,
                                                          options: .prettyPrinted)
        } catch {
            print(error.localizedDescription)
        }

        let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data,
                                                                      options: .mutableContainers) as? [String: Any]
                        else { return }

                    var accessObject = [AccessToken]()
                    var messageInObject = [ErrorMessage]()

                    if let access = AccessToken(json: json) {
                        accessObject.append(access)
                    }
                    if let access = ErrorMessage(json: json) {
                        messageInObject.append(access)
                    }
                    completionHandler(accessObject, messageInObject)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        task.resume()
    }

    /// Get request for receiving text
    func getText(locale: String, accessToken: String, completionHandler: @escaping (_ text: String) -> Void) {
        var baseURL = NetworkingConstants.getTextURL
        let parameters = locale
        baseURL.append("\(NetworkingConstants.nameForLocale)\(parameters)/")
        guard let url = URL(string: baseURL) else { return }
        var request = URLRequest(url: url)
        request.setValue("\(NetworkingConstants.tokenType) \(accessToken)",
            forHTTPHeaderField: NetworkingConstants.getHeader)

        let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data,
                                                                      options: .mutableContainers) as? [String: Any],
                        let textData = json["data"] as? String
                        else { return }

                    completionHandler(textData)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        task.resume()
    }
}
