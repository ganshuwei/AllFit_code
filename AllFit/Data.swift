//
//  User.swift
//  test
//
//  Created by Jiecheng on 11/11/22.
//

import Foundation
import UIKit

struct User{
    var userEmail:String
    var firstName: String = "firstName"
    var lastName:String = "Last Name"
    var bio:String = "bio"
    var birthday:String = "birthday"
    var profilePhoto:UIImage?
    var safeEmail:String{
        var safeEmail = userEmail.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
}

struct WorkOut {
    let workOutStar:Double
    let workOutImage:UIImage?
    let workOutName: String
    let userName:String
    let userPhoto: UIImage?
    let workoutId : Int
    let workout_exercises: [Exercise]
    var favor = false
}

// For test
var workOuts : [WorkOut] = [
    WorkOut(workOutStar: 4.8, workOutImage: UIImage(named: "workout1"), workOutName: "Run", userName: "Mike", userPhoto: UIImage(systemName:  "person.crop.circle"),workoutId: 1, workout_exercises: []),
    WorkOut(workOutStar: 4.3, workOutImage: UIImage(named: "workout2"), workOutName: "Pushups", userName: "David", userPhoto: UIImage(systemName: "person.crop.circle"),workoutId: 2, workout_exercises: []),
    WorkOut(workOutStar: 4.2, workOutImage: UIImage(named: "workout3"), workOutName: "Core", userName: "Johnson", userPhoto: UIImage(systemName: "person.crop.circle"),workoutId: 3, workout_exercises: []),
    WorkOut(workOutStar: 4.9, workOutImage: UIImage(named: "workout4"), workOutName: "Strong", userName: "Lucy", userPhoto: UIImage(systemName: "person.crop.circle"),workoutId: 4, workout_exercises: []),
    WorkOut(workOutStar: 4.6, workOutImage: UIImage(named: "workout5"), workOutName: "Balance", userName: "Emma", userPhoto: UIImage(systemName: "person.crop.circle"),workoutId: 5, workout_exercises: []),
    WorkOut(workOutStar: 4.4, workOutImage: UIImage(named: "workout6"), workOutName: "Keep", userName: "George", userPhoto: UIImage(systemName: "person.crop.circle"),workoutId: 6, workout_exercises: [])
]

var favourite: [WorkOut] = []

var personal: [WorkOut] = []

// ===== Mel code =====

struct Exercise: Encodable, Decodable {
 var exercise_name: String?
 var exercise_type: String
 var exercise_repOrTime: Int!
 var exercise_equipment: [String]
}

var exerciseArray: [Exercise] = []

var testUser = User(userEmail: "", profilePhoto: UIImage(systemName: "person"))

