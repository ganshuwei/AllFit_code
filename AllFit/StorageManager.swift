//
//  StorageManager.swift
//  AllFit
//
//  Created by Jiecheng on 11/22/22.
//

import Foundation
import FirebaseStorage

final class StorageManager{
    
    enum StorageMessage: Error{
        case failToUpload
        case failToGetDoenloadUrl
    }
   
    static let share = StorageManager()
    
    private let storage = Storage.storage().reference()
    
    public typealias UploadPictureCompletion = (Result<String, Error>) -> Void
    
    public func uploadProfilePicture(with data: Data, fileName: String, completion: @escaping UploadPictureCompletion){
        storage.child("images/\(fileName)").putData(data, metadata: nil, completion: {metadata, error in
            guard error == nil else{
                // Fail to Upload Picture
                print("Failed to upload the picture to the firebase storage")
                completion(.failure(StorageMessage.failToUpload))
                return
            }
            
            self.storage.child("images/\(fileName)").downloadURL(completion: {url, error in
                guard let url = url else{
                    print("Cannot get the download url for the uploaded picture")
                    completion(.failure(StorageMessage.failToGetDoenloadUrl))
                    return
                }
                let urlString = url.absoluteString
                print("The download url for uploaded picture is \(urlString)")
                completion(.success(urlString))
            })
        })
    }
    
    public func fetchPicUrl(for path: String, completion: @escaping (Result<URL, Error>) -> Void){
        let reference = storage.child(path)
        
        reference.downloadURL(completion: {url, error in
            guard let url = url, error == nil else{
                completion(.failure(StorageMessage.failToGetDoenloadUrl))
                return
            }
            completion(.success(url))
        })
    }
}

