//
//  Request.swift
//  vas3k-club-ios
//
//  Created by Romanishkin, Pavel on 13.10.20.
//  Copyright © 2020 Romanishkin, Pavel. All rights reserved.
//

import Foundation
import SwiftSoup

class Request {
    let defaults = UserDefaults.standard
    let baseUrl = "https://vas3k.club/"
    
    private func send(url: String, payload: [String: String]? = nil, completion: @escaping ([String: Any]) -> ()) {
        var request = URLRequest(url: URL(string: url)!)
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
    
//    func fetchPost(input: String, completion: @escaping (Post) -> ()) {
//        var postData: [String: String] = [:]
//        send(url: input) { (response) in
//            do {
//                let htmlPost = try! SwiftSoup.parse(response)
//                postData["title"] = try htmlPost.select("title").first()!.text()
//                postData["text"] = try htmlPost.select("div.text-body").first()!.text()
//                let post = Post.init(title: postData["title"]!, text: postData["text"]!)
//                completion(post)
//            } catch Exception.Error( _, let message) {
//                print(message)
//            } catch {
//                print("error")
//            }
//        }
//    }
    
    func fetchPosts(completion: @escaping ([Post]) -> ()) {
        send(url: baseUrl) { (response) in
            do {
                var posts = [] as [Post]
                let html = try! SwiftSoup.parse(response["payload"] as! String)
                let htmlPosts = try html.select("div.feed-post-post")
                for htmlPost in htmlPosts {
                    var postData: [String: Any] = [:]
                    let postTitle = try htmlPost.select("div.feed-post-title").first()!.select("a").first()!
                    let stringId = try htmlPost.select("a.u-url").first()!.attr("href")
                    postData["id"] = Int(stringId.components(separatedBy:CharacterSet.decimalDigits.inverted).joined())
                    postData["title"] = try postTitle.text()
                    let post = Post.init(id: postData["id"] as! Int, title: postData["title"]! as! String)
                    posts.append(post)
                }
                completion(posts)
            } catch {
                print("error")
            }
        }
    }
    
    func sendFirstLoginRequest(email: String, completion: @escaping (() -> ())){
        send(url: baseUrl + "auth/email/", payload: ["email_or_login": email]) { _ in}
    }
    
    func sendSecondLoginRequest(email: String, code: String, completion: @escaping (() -> ())){
        send(url: baseUrl + "auth/email/code/?code=\(code)&email=\(email)") { (response) in
            for cookie in HTTPCookieStorage.shared.cookies! {
                if cookie.name == "token" {
                    self.defaults.set(cookie.value, forKey: "token")
                    completion()
                }
            }
        }
        
    }
    
}
