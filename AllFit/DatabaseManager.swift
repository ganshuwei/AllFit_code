//
//  DatabaseManager.swift
//  AllFit
//
//  Created by Jiecheng on 11/13/22.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager{
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
}

extension DatabaseManager{
    
    //Check whehter the new user exists in the database
    

    
    public func checkExistUser(with email: String, completion: @escaping((Bool) -> Void)){
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        database.child(safeEmail).observeSingleEvent(of: .value, with: { snapshot in
            guard snapshot.value as? String != nil else{
                completion(false)
                return
            }
            completion(true)
        })
    }
    
    
    
    // Create a new user in the database
    public func addNewUser(with user: User){
        let safe = user.safeEmail
        database.child(safe).setValue(["first_name":user.firstName, "last_name": user.lastName, "bio": user.bio, "birthday": user.birthday])
    }
}

