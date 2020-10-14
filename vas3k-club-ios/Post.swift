//
//  Post.swift
//  vas3k-club-ios
//
//  Created by Romanishkin, Pavel on 13.10.20.
//  Copyright © 2020 Romanishkin, Pavel. All rights reserved.
//

import Foundation

struct Post: Hashable, Identifiable {
    var id: String? = nil
    var type: String? = nil
    var slug: Int? = nil
    var author_slug: String? = nil
    var title: String
    var text: String
    var upvotes: Int? = nil
    var published_at: Date? = nil
    var updated_at: Date? = nil
    var last_activity_at: Date? = nil
}
