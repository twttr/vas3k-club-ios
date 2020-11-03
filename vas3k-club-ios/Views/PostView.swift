//
//  PostView.swift
//  vas3k-club-ios
//
//  Created by Romanishkin, Pavel on 26.10.20.
//  Copyright © 2020 Romanishkin, Pavel. All rights reserved.
//

import SwiftUI

struct PostView: View {
    @ObservedObject var postViewModel: PostViewModel
    var body: some View {
        ScrollView{
            VStack{
                Text(postViewModel.post.text!).padding()
            }.navigationBarTitle(postViewModel.post.title!).lineLimit(nil)
        }
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView(postViewModel: PostViewModel(postId: 1))
    }
}

class PostViewModel: ObservableObject {
    var data = DataFetch.init()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @Published var post: Post = Post()
    init(postId: Int16) {
        data.fetchPost(input: postId) { (fetchedPost) in
            DispatchQueue.main.async { [self] in
                post = fetchedPost
            }
        }
    }
}
