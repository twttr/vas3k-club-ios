//
//  ContentView.swift
//  vas3k-club-ios
//
//  Created by Romanishkin, Pavel on 13.10.20.
//  Copyright © 2020 Romanishkin, Pavel. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var request = Request.init()
    @State private var posts: [Post] = []
    
    var body: some View {
        List(posts) { post in
            VStack(alignment: .leading) {
                Text(post.title)
            }
        }.onAppear(perform: loadPosts)
    }
    
    func loadPosts(){
        request.fetchPosts { (posts) in
            self.posts = posts
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
