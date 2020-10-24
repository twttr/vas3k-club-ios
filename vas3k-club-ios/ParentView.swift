//
//  ParentView.swift
//  vas3k-club-ios
//
//  Created by Romanishkin, Pavel on 24.10.20.
//  Copyright © 2020 Romanishkin, Pavel. All rights reserved.
//

import SwiftUI

struct ParentView: View {
    @ObservedObject var viewRouter: ViewRouter
    var body: some View {
        if viewRouter.currentPage == "LoginView" {
            LoginView(viewRouter: viewRouter)
        } else if viewRouter.currentPage == "ContentView" {
            ContentView(viewRouter: viewRouter)
        }
    }
}

struct ParentView_Previews: PreviewProvider {
    static var previews: some View {
        ParentView(viewRouter: ViewRouter())
    }
}
