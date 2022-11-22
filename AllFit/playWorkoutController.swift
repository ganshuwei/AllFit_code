//
//  playWorkoutController.swift
//  AllFit
//
//  Created by user on 11/22/22.
//

import Foundation
import UIKit

class playWorkoutController : UIViewController{
    
    
    var wkoutImage: UIImage!
    var wkoutName: String!
//    var wkoutCreator: String!
//    var wkoutDuration: String!
//    var wkoutDifficulty: String!
//    var wkoutEquipment: String!
//    var wkoutDescription: String!
    var wkoutExercises: [Exercise] = []
    var exerciseIndex=0
    
    @IBOutlet weak var workoutName: UILabel!
    @IBOutlet weak var workoutTime: UILabel!
    @IBOutlet weak var exerciseName: UILabel!
    @IBOutlet weak var exerciseTime: UILabel!
    
    override func viewDidLoad() {
        print("in play workout view controller")
        super.viewDidLoad()
        
        workoutName.text=wkoutName
        exerciseName.text=wkoutExercises[exerciseIndex].exercise_name
        
    }
    @IBAction func nextExercise(_ sender: Any) {
        exerciseIndex+=1
        exerciseName.text=wkoutExercises[exerciseIndex].exercise_name
    }
}

