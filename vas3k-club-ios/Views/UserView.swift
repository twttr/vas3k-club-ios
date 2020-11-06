//
//  UserView.swift
//  vas3k-club-ios
//
//  Created by Romanishkin, Pavel on 25.10.20.
//  Copyright © 2020 Romanishkin, Pavel. All rights reserved.
//

import SwiftUI
import CoreData

struct UserView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View {
        VStack {
            Button(action: { self.logout() })
                { Text("Log Out") }
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(width: 220, height: 60)
                .background(Color(UIColor.blue))
                .cornerRadius(15.0)
        }.padding()
    }
    
    func logout() -> (){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Post")
        let defaults = UserDefaults.standard
        
        if let _ = defaults.object(forKey: "token") as? String {
            defaults.removeObject(forKey: "token")
        }
        do
            {
                let results = try context.fetch(request)
                for managedObject in results
                {
                    let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                    context.delete(managedObjectData)
                }
            } catch let error as NSError {
                print(error)
            }
        self.viewRouter.currentPage = "LoginView"
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
    }
}
