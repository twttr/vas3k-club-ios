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
    
    func send(url: String, completion: @escaping (String) -> ()) {
        let cookie = "token=hK2pfmKRGsiFHNkPnV6j5iDAb3f50oSD" as String
        var request = URLRequest(url: URL(string: url)!)
        request.setValue(cookie, forHTTPHeaderField: "Cookie")

        URLSession.shared.dataTask(with: request) { data, response, error in

            if error != nil || data == nil {
                print("Client error!")
                return
            }

            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Server error!")
                return
            }
            
            if let unwrappedData = String(data: data!, encoding: .utf8) {
                completion(unwrappedData)
            }
        }.resume()
    }
    
    func convertToPost(input: String) -> Post {
        var postData: [String: String] = [:]
        do {
            let doc: Document = try SwiftSoup.parse(input)
            postData["title"] = try doc.select("title").first()!.text()
            postData["text"] = try doc.select("div.text-body").first()!.text()
        } catch Exception.Error( _, let message) {
            print(message)
        } catch {
            print("error")
        }
        let post = Post.init(title: postData["title"]!, text: postData["text"]!)
        
        return post
    }
    
}
