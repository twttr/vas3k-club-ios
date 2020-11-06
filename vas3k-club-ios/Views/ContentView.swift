//
//  ContentView.swift
//  vas3k-club-ios
//
//  Created by Romanishkin, Pavel on 13.10.20.
//  Copyright © 2020 Romanishkin, Pavel. All rights reserved.
//

import SwiftUI
import CoreData
import SwiftUIRefresh

struct ContentView: View {
    @ObservedObject var postsViewModel = PostsViewModel()
    @EnvironmentObject var viewRouter: ViewRouter
    @State private var isShowing = false
    var body: some View {
        NavigationView {
            List(postsViewModel.postsList) { post in
                NavigationLink(destination: PostView(postViewModel: PostViewModel(postId: post.id))) {
                    VStack(alignment: .leading) {
                        Text(post.title!)
                    }
                }
            }.pullToRefresh(isShowing: $isShowing) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.isShowing = true
                    postsViewModel.updateList { (_) in
                        self.isShowing = false
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
        updateList {_ in }
    }
    
    func updateList(completion: @escaping (Bool) -> ()) ->() {
        self.data.fetchPosts { (_) in
            DispatchQueue.main.async {
                let fetchRequest = NSFetchRequest<Post>.init(entityName: "Post")
                self.postsList = try! self.context.fetch(fetchRequest)
                completion(true)
            }
        }
    }
}
