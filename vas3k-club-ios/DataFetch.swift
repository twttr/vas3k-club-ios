//
//  DataFetch.swift
//  vas3k-club-ios
//
//  Created by Romanishkin, Pavel on 26.10.20.
//  Copyright © 2020 Romanishkin, Pavel. All rights reserved.
//

import Foundation
import SwiftSoup
import CoreData
import UIKit

class DataFetch {
    let request = Request.shared
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func fetchPosts(completion: @escaping (Bool) -> ()) {
        request.send() { (response) in
            self.fillPostsArray(response: response) { (posts) in
                completion(true)
            }
        }
    }
    
    func performSearch(query: String, completion: @escaping((Bool) -> ())){
        request.send(url: "search/?q=\(query)") { response in
            self.fillPostsArray(response: response) { (posts) in
                completion(true)
            }
        }
    }
    
        func fetchPost(input: Int16, completion: @escaping (Post) -> ()) {
            request.send(url: "post/\(input)/") { (response) in
                self.fillPost(id: input, response: response) { (post) in
                    completion(post)
                }
            }
        }
    
    private func fillPost(id: Int16, response: [String: Any], completion: @escaping (Post) -> ()){
        do {
            var postData: [String: String] = [:]
            let html = try! SwiftSoup.parse(response["payload"] as! String)
            postData["title"] = try html.select("title").first()!.text()
            postData["text"] = try html.select("div.text-body").first()!.text()
            let fetchRequest : NSFetchRequest<Post> = Post.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", id)
            let fetchedResults = try context.fetch(fetchRequest)
            if let aPost = fetchedResults.first {
                aPost.setValue(postData["text"], forKey: "text")
                try! context.save()
                completion(aPost)
            }
        } catch Exception.Error( _, let message) {
            print(message)
        } catch {
            print(error)
        }
    }
    
    private func fillPostsArray(response: [String: Any], completion: @escaping (Bool) -> ()){
        do {
            let html = try! SwiftSoup.parse(response["payload"] as! String)
            let htmlPosts = try html.select("div.feed-post-post")
            for htmlPost in htmlPosts {
                var postData: [String: Any] = [:]
                let postTitle = try htmlPost.select("div.feed-post-title").first()!.select("a").first()!
                let stringId = try htmlPost.select("a.u-url").first()!.attr("href")
                postData["id"] = Int16(stringId.components(separatedBy:CharacterSet.decimalDigits.inverted).joined())
                let fetchRequest : NSFetchRequest<Post> = Post.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %d", postData["id"] as! Int16)
                let fetchedResults = try context.fetch(fetchRequest)
                if let _ = fetchedResults.first {
                    //skip
                } else {
                    postData["title"] = try postTitle.text()
                    let post = Post(context: context)
                    post.id = postData["id"] as! Int16
                    post.title = postData["title"] as? String
                }
            }
            try context.save()
            completion(true)
        } catch {
            print(error)
        }
    }
}
