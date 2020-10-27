//
//  DataFetch.swift
//  vas3k-club-ios
//
//  Created by Romanishkin, Pavel on 26.10.20.
//  Copyright © 2020 Romanishkin, Pavel. All rights reserved.
//

import Foundation
import SwiftSoup

class DataFetch {
    let request = Request.shared
    
    func fetchPosts(completion: @escaping ([Post]) -> ()) {
        request.send() { (response) in
            self.fillPostsArray(response: response) { (posts) in
                completion(posts)
            }
        }
    }
    
    func performSearch(query: String, completion: @escaping(([Post]) -> ())){
        request.send(url: "search/?q=\(query)") { response in
            self.fillPostsArray(response: response) { (posts) in
                completion(posts)
            }
        }
    }
    
        func fetchPost(input: String, completion: @escaping (Post) -> ()) {
            request.send(url: "post/\(input)/") { (response) in
                self.fillPost(id: input, response: response) { (post) in
                    completion(post)
                }
            }
        }
    
    private func fillPost(id: String, response: [String: Any], completion: @escaping (Post) -> ()){
        do {
            var postData: [String: String] = [:]
            let html = try! SwiftSoup.parse(response["payload"] as! String)
            postData["title"] = try html.select("title").first()!.text()
            postData["text"] = try html.select("div.text-body").first()!.text()
            let post = Post.init(id: id, title: postData["title"]!, text: postData["text"]!)
            completion(post)
        } catch Exception.Error( _, let message) {
            print(message)
        } catch {
            print("error")
        }
    }
    
    private func fillPostsArray(response: [String: Any], completion: @escaping ([Post]) -> ()){
        do {
            var posts = [] as [Post]
            let html = try! SwiftSoup.parse(response["payload"] as! String)
            let htmlPosts = try html.select("div.feed-post-post")
            for htmlPost in htmlPosts {
                var postData: [String: Any] = [:]
                let postTitle = try htmlPost.select("div.feed-post-title").first()!.select("a").first()!
                let stringId = try htmlPost.select("a.u-url").first()!.attr("href")
                postData["id"] = stringId.components(separatedBy:CharacterSet.decimalDigits.inverted).joined()
                postData["title"] = try postTitle.text()
                let post = Post.init(id: postData["id"] as! String, title: postData["title"]! as! String)
                posts.append(post)
            }
            completion(posts)
        } catch {
            print("error")
        }
    }
    
}
