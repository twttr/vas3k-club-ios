//
//  ViewRouter.swift
//  vas3k-club-ios
//
//  Created by Romanishkin, Pavel on 24.10.20.
//  Copyright © 2020 Romanishkin, Pavel. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class ViewRouter: ObservableObject {
    let objectWillChange = PassthroughSubject<ViewRouter,Never>()
    var defaults = UserDefaults.standard
    var currentPage: String {
        get {
            if let _ = defaults.object(forKey: "token") {
                return "ContentView"
            } else {
                return "LoginView"
            }
        }
        set {
            DispatchQueue.main.async {
                self.objectWillChange.send(self)
            }
        }
    }
}
