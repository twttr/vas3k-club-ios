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
    @EnvironmentObject var viewRouter: ViewRouter
    var body: some View {
        NavigationView {
            List(postsViewModel.postsList) { post in
                NavigationLink(destination: PostView(postViewModel: PostViewModel(postId: post.id))) {
                    VStack(alignment: .leading) {
                        Text(post.title)
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ViewRouter())
    }
}

class PostsViewModel: ObservableObject {
    var data = DataFetch.init()
    @Published var postsList = [Post]()
    
    init() {
        data.fetchPosts { (posts) in
            DispatchQueue.main.async { [self] in
                postsList = posts
            }
        }
    }
}
