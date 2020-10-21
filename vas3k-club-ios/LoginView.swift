//
//  LoginView.swift
//  vas3k-club-ios
//
//  Created by Romanishkin, Pavel on 16.10.20.
//  Copyright © 2020 Romanishkin, Pavel. All rights reserved.
//

import SwiftUI

@available(iOS 14.0, *)
struct LoginView: View {
    var request = Request.init()
    @State var email: String = ""
    @State var password: String = ""
    var body: some View {
            VStack {
                TextField("Enter e-mail", text: $email)
                    .padding()
                    .background(Color(UIColor.lightGray))
                    .cornerRadius(5.0)
                    .padding(.bottom, 10)
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(UIColor.lightGray))
                    .cornerRadius(5.0)
                    .padding(.bottom, 10)
                Button(action: { self.login() })
                    { Text(loginButtonText) }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 220, height: 60)
                    .background(loginButtonColor)
                    .cornerRadius(15.0)
            }.padding().fullScreenCover(isPresented:  Binding<Bool>(
                get: { request.loggedIn },
                set: { request.loggedIn = $0 }
            ), content: { ContentView() })
    }
    
    func login() {
        if password.isEmpty {
            self.request.sendFirstLoginRequest(email: self.email) {}
        } else {
            self.request.sendSecondLoginRequest(email: self.email, code: self.password) {}
        }
    }
    
    var loginButtonText: String {
        if email.isEmpty && password.isEmpty {
            return "Enter email"
        } else if password.isEmpty {
            return "Request code"
        } else {
            return "Login"
        }
    }
    
    var loginButtonColor: Color {
        return email.isEmpty && password.isEmpty ? Color(UIColor.lightGray) : .blue
    }
}

@available(iOS 14.0, *)
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
