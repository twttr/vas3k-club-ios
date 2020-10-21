//
//  ContentView.swift
//  vas3k-club-ios
//
//  Created by Romanishkin, Pavel on 13.10.20.
//  Copyright © 2020 Romanishkin, Pavel. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var postsViewModel = PostsViewModel()
    var body: some View {
        List(postsViewModel.postsList) { post in
            VStack(alignment: .leading) {
                Text(post.title)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

class PostsViewModel: ObservableObject {
    var request = Request.init()
    @Published var postsList = [Post]()
    
    init() {
        request.fetchPosts { (posts) in
            DispatchQueue.main.async { [self] in
                postsList = posts
                self.objectWillChange.send()
            }
        }
    }
}
