//
//  Request.swift
//  vas3k-club-ios
//
//  Created by Romanishkin, Pavel on 13.10.20.
//  Copyright © 2020 Romanishkin, Pavel. All rights reserved.
//

import Foundation

class Request {
    let defaults = UserDefaults.standard
    let baseURL: String
    static let shared = Request(baseURL: "https://vas3k.club/")
    
    private init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    func send(url: String = "", payload: [String: String]? = nil, completion: @escaping ([String: Any]) -> ()) {
        var request = URLRequest(url: URL(string: baseURL + url)!)
        request.httpMethod = "GET"
        if let requestToken = defaults.object(forKey: "token") as? String {
            request.setValue("token=\(requestToken)", forHTTPHeaderField: "cookie")
        }
        if payload != nil {
            request.httpMethod = "POST"
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            var requestBody = URLComponents()
            requestBody.queryItems = []
            for (name, value) in payload! {
                requestBody.queryItems?.append(URLQueryItem(name: name, value: value))
            }
            request.httpBody = requestBody.percentEncodedQuery?.data(using: .utf8)
            request.setValue("\(String(describing: request.httpBody?.count))", forHTTPHeaderField: "Content-Length")
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            var headers: [AnyHashable: Any]
            if error != nil {
                print(error.debugDescription)
            } else {
                if let unwrappedData = String(data: data!, encoding: .utf8), let httpResponse = response as? HTTPURLResponse {
                    headers = httpResponse.allHeaderFields
                    completion(["payload": unwrappedData, "headers": headers])
                }
            }
        }.resume()
    }
    
    func sendFirstLoginRequest(email: String, completion: @escaping (() -> ())){
        send(url: "auth/email/", payload: ["email_or_login": email]) { _ in}
    }
    
    func sendSecondLoginRequest(email: String, code: String, completion: @escaping (() -> ())){
        send(url: "auth/email/code/?code=\(code)&email=\(email)") { (response) in
            for cookie in HTTPCookieStorage.shared.cookies! {
                if cookie.name == "token" {
                    self.defaults.set(cookie.value, forKey: "token")
                    completion()
                }
            }
        }
        
    }
}
