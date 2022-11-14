//
//  CreateExerciseView.swift
//  AllFit
//
//  Created by user on 11/13/22.
//

import Foundation
import Firebase
import FirebaseAuth

class CreateExerciseView: UIViewController{
    
    @IBOutlet weak var exerciseImage: UIImageView!
    @IBOutlet weak var exerciseName: UITextField!
    @IBOutlet weak var exerciseType: UISegmentedControl!
    @IBOutlet weak var repsOrTime: UITextField!
    @IBOutlet weak var dumbellBtn: UIButton!
    @IBOutlet weak var matBtn: UIButton!
    @IBOutlet weak var bikeBtn: UIButton!
    @IBOutlet weak var submitExercise: UIButton!
    
//    struct Exercise: Encodable, Decodable {
//     var exercise_name: String?
//     var exercise_type: String
//     var exercise_repOrTime: Int!
//     var exercise_equipment: [String]
//    }
//
//    var exerciseArray: [Exercise] = []
//
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

    }
    @IBAction func submitExerciseClick(_ sender: Any) {
        print("exercise submited")
        //get values from interface
        let equipmentList=["dumbell","mat"]
        let exerciseTypeIndex = exerciseType.selectedSegmentIndex
        var exerciseTypeString=""
        if exerciseTypeIndex == 0{
            exerciseTypeString = "dumbell"
        }
        else if exerciseTypeIndex == 1{
            exerciseTypeString = "mat"
        }
        else if exerciseTypeIndex == 2{
            exerciseTypeString = "bike"
        }
        //add exercise to array of exercises
        let exerciseInfo = Exercise(
                          exercise_name: String(exerciseName.text!),
                          exercise_type: exerciseTypeString,
                          exercise_repOrTime: Int(repsOrTime.text!),
                          exercise_equipment: equipmentList
                            )
        //get list of exercises
        exerciseArray.append(exerciseInfo)
        print("exercise array is ",exerciseArray)

        //reload table
//        CreateWorkoutView.exerciseTable.reloadData()
        
//        let defaults = UserDefaults.standard
//        if let data = defaults.data(forKey: "MyExercises") {
//            var exerciseArray = try! PropertyListDecoder().decode([Exercise].self, from: data)
//            //add new exercise to list of exercises
//            exerciseArray.append(exerciseInfo)
//            if let data = try? PropertyListEncoder().encode(exerciseArray) {
//                    UserDefaults.standard.set(data, forKey: "MyExercises")
//            }
//            print("exercise array is ",exerciseArray)
//        }
    }
}


