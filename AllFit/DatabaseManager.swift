//
//  DatabaseManager.swift
//  AllFit
//
//  Created by Jiecheng on 11/13/22.
//

import Foundation
import Firebase
import FirebaseDatabase

final class DatabaseManager{
    static let shared = DatabaseManager()
    
    enum DataBaseMessage : Error {
        case failToFetch
    }
    
    private let database = Database.database().reference()
    
    static func safeEmail(userEmail : String) -> String{
        var safeEmail = userEmail.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
}

extension DatabaseManager{
    
    //Check whehter the new user exists in the database
    public func checkExistUser(with email: String, completion: @escaping((Bool) -> Void)){
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        database.child("users").child(safeEmail).observeSingleEvent(of: .value, with: { snapshot in
            guard snapshot.value as? String != nil else{
                completion(false)
                return
            }
            completion(true)
        })
    }
    
    
    // Create a new user in the database
    public func addNewUser(with user: User, completion: @escaping((Bool) -> Void)){
        database.child("users").child(user.safeEmail).setValue(["username":user.username,"first_name":user.firstName, "last_name": user.lastName, "bio": user.bio, "birthday": user.birthday], withCompletionBlock:{ error, _ in
            
            guard error == nil else{
                print("Fail to edit the user personal information.")
                completion(false)
                return
            }
            completion(true)
        })
    }
        
    public func fetchData(childNode: String, completion: @escaping (Result<Any, Error>) -> Void){
        database.child("users").child("\(childNode)").observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value else {
                completion(.failure(DataBaseMessage.failToFetch))
                return
            }
            completion(.success(value))
        }
    }
}

