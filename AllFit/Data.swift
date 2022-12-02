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
    var username: String = "username"
    var firstName: String = "firstName"
    var lastName:String = "Last Name"
    var bio:String = "bio"
    var birthday:String = "birthday"
    var profilePhoto:UIImage?
    // Firebase real-time database not allow . and @
    var safeEmail:String{
        var safeEmail = userEmail.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
    var profilePhotoFileName: String{
        return "\(safeEmail)_profile_photo.png"
    }
}

struct WorkOut {
    var workOutStar:Double
    let workOutStarNum:Int
    let workOutImage:UIImage?
    let workOutName: String
    let workOutDifficulty:String
    let workOutDescription: String
    let userName:String
    let userPhoto: UIImage?
    let workoutId : String
    let workout_exercises: [Exercise]
    var favor = false
    var workoutDate: String
    var workoutTotalSeconds: Int
    var finishedWorkout: Bool
}

// For test
var workOuts : [WorkOut] = [
    WorkOut(workOutStar: 4.8, workOutStarNum: 10, workOutImage: UIImage(named: "workout1"), workOutName: "Run",workOutDifficulty:"Easy", workOutDescription:"bla",userName: "Mike", userPhoto: UIImage(systemName:  "person.crop.circle"),workoutId: "1", workout_exercises: [], workoutDate: "11/22/2022",workoutTotalSeconds: 100, finishedWorkout: true),
    WorkOut(workOutStar: 4.3, workOutStarNum: 10,workOutImage: UIImage(named: "workout2"), workOutName: "Pushups",workOutDifficulty:"Easy", workOutDescription:"bla",userName: "David", userPhoto: UIImage(systemName: "person.crop.circle"),workoutId: "2", workout_exercises: [],workoutDate: "11/22/2022",workoutTotalSeconds: 100,finishedWorkout: true),
    WorkOut(workOutStar: 4.2, workOutStarNum: 10,workOutImage: UIImage(named: "workout3"), workOutName: "Core",workOutDifficulty:"Easy", workOutDescription:"bla",userName: "Johnson", userPhoto: UIImage(systemName: "person.crop.circle"),workoutId: "3", workout_exercises: [],workoutDate: "11/22/2022",workoutTotalSeconds: 100,finishedWorkout: false),
    WorkOut(workOutStar: 4.9, workOutStarNum: 10,workOutImage: UIImage(named: "workout4"), workOutName: "Strong",workOutDifficulty:"Easy", workOutDescription:"bla",userName: "Lucy", userPhoto: UIImage(systemName: "person.crop.circle"),workoutId: "4", workout_exercises: [],workoutDate: "11/22/2022",workoutTotalSeconds: 100,finishedWorkout: true),
    WorkOut(workOutStar: 4.6, workOutStarNum: 10,workOutImage: UIImage(named: "workout5"), workOutName: "Balance",workOutDifficulty:"Easy", workOutDescription:"bla",userName: "Emma", userPhoto: UIImage(systemName: "person.crop.circle"),workoutId: "5", workout_exercises: [],workoutDate: "11/22/2022",workoutTotalSeconds: 100,finishedWorkout: false),
    WorkOut(workOutStar: 4.4, workOutStarNum: 10,workOutImage: UIImage(named: "workout6"), workOutName: "Keep",workOutDifficulty:"Easy", workOutDescription:"bla",userName: "George", userPhoto: UIImage(systemName: "person.crop.circle"),workoutId: "6", workout_exercises: [],workoutDate: "11/22/2022",workoutTotalSeconds: 100,finishedWorkout: false)
]

//var workOuts : [WorkOut] = []

var favourite: [WorkOut] = []

var personal: [WorkOut] = []

// ===== Mel code =====

struct Exercise{
 var exercise_name: String?
 var exercise_type: String
 var exercise_repOrTime: String!
 var exercise_repOrTimeValue: String!
 var exercise_equipment: [String]
 var exercise_time: Int
 let exercise_image: UIImage?
}

var exerciseArray: [Exercise] = []
var exerciseArrayFirebase: [[String:Any]] = [[:]]

var testUser = User(userEmail: "", profilePhoto: UIImage(systemName: "person"))

