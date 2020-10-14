//
//  ContentView.swift
//  vas3k-club-ios
//
//  Created by Romanishkin, Pavel on 13.10.20.
//  Copyright © 2020 Romanishkin, Pavel. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var posts: [Post] = []
    var body: some View {
        List(posts) { post in
            VStack(alignment: .leading) {
                Text(post.title)
                Text(post.text.substring(from: 0, to: 100))
                    .font(.subheadline)
            }
        }.onAppear(perform: loadPost)
    }
    
    func loadPost(){
        let req = Request.init()
        req.send(url: "https://vas3k.club/post/5631/", completion: { data in
            let post = req.convertToPost(input: data)
            self.posts = [post]
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
