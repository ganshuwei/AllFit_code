//
//  User.swift
//  test
//
//  Created by Jiecheng on 11/11/22.
//

import Foundation

struct User:Decodable{
    var userEmail:String
//    let fullName:String?
//    let bio:String?
//    let birthday:Date?
//    let password:Int
//    let profilePhotoUrl:String?
}

struct WorkOut:Decodable{
    let workOutStar:Double
    let workOutImage:String?
    let workOutName: String
    let userEmail:String
    let userPhoto: String?
}


