//
//  ContentView.swift
//  vas3k-club-ios
//
//  Created by Romanishkin, Pavel on 13.10.20.
//  Copyright © 2020 Romanishkin, Pavel. All rights reserved.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @ObservedObject var postsViewModel = PostsViewModel()
    @EnvironmentObject var viewRouter: ViewRouter
    var body: some View {
        NavigationView {
            List(postsViewModel.postsList) { post in
                NavigationLink(destination: PostView(postViewModel: PostViewModel(postId: post.id))) {
                    VStack(alignment: .leading) {
                        Text(post.title!)
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
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @Published var postsList: [Post] = [Post]()
    
    init() {
        self.data.fetchPosts { (_) in
            DispatchQueue.main.async {
                let fetchRequest = NSFetchRequest<Post>.init(entityName: "Post")
                self.postsList = try! self.context.fetch(fetchRequest)
            }
        }
    }
}
