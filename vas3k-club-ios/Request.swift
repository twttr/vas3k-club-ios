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
    let baseUrl = "https://vas3k.club"
    
    private func send(url: String, completion: @escaping (String) -> ()) {
        let cookie = "token=hK2pfmKRGsiFHNkPnV6j5iDAb3f50oSD" as String
        var request = URLRequest(url: URL(string: url)!)
        request.setValue(cookie, forHTTPHeaderField: "Cookie")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                print(error.debugDescription)
            } else {
                if let unwrappedData = String(data: data!, encoding: .utf8) {
                    completion(unwrappedData)
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
                let html = try! SwiftSoup.parse(response)
                let htmlPosts = try html.select("div.feed-post-post")
                print(htmlPosts)
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
            } catch Exception.Error( _, let message) {
                print(message)
            } catch {
                print("error")
            }
        }
    }
    
}
