//
//  User.swift
//  test
//
//  Created by Jiecheng on 11/11/22.
//

import Foundation
import UIKit

struct User:Decodable{
    var userEmail:String
//    let fullName:String?
//    let bio:String?
//    let birthday:Date?
//    let password:Int
//    let profilePhotoUrl:String?
}

struct WorkOut {
    let workOutStar:Double
    let workOutImage:UIImage?
    let workOutName: String
    let userName:String
    let userPhoto: UIImage?
    let workoutId : Int
}

// For test
let workOuts : [WorkOut] = [
    WorkOut(workOutStar: 4.8, workOutImage: UIImage(named: "workout1"), workOutName: "Run", userName: "Mike", userPhoto: UIImage(systemName:  "person.crop.circle"),workoutId: 1),
    WorkOut(workOutStar: 4.3, workOutImage: UIImage(named: "workout2"), workOutName: "Pushups", userName: "David", userPhoto: UIImage(systemName: "person.crop.circle"),workoutId: 2),
    WorkOut(workOutStar: 4.2, workOutImage: UIImage(named: "workout3"), workOutName: "Core", userName: "Johnson", userPhoto: UIImage(systemName: "person.crop.circle"),workoutId: 3),
    WorkOut(workOutStar: 4.9, workOutImage: UIImage(named: "workout4"), workOutName: "Strong", userName: "Lucy", userPhoto: UIImage(systemName: "person.crop.circle"),workoutId: 4),
    WorkOut(workOutStar: 4.6, workOutImage: UIImage(named: "workout5"), workOutName: "Balance", userName: "Emma", userPhoto: UIImage(systemName: "person.crop.circle"),workoutId: 5),
    WorkOut(workOutStar: 4.4, workOutImage: UIImage(named: "workout6"), workOutName: "Keep", userName: "George", userPhoto: UIImage(systemName: "person.crop.circle"),workoutId: 6)
]

var favourite: [WorkOut] = []

var personal: [WorkOut] = []


