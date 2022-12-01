//
//  PreviewExerciseVC.swift
//  AllFit
//
//  Created by user on 12/1/22.
//

import Foundation
import UIKit
import FirebaseAuth
import Firebase

class detailedExerciseController: UIViewController {
    
    var exerciseName: String!
    var equipmentList: [String]=[]
    var exerciseType: String!
    var repOrTimeNum: String!
    var exerciseImage: UIImage!

    @IBOutlet weak var displayExerciseName: UILabel!
    @IBOutlet weak var displayExerciseNameTitle: UILabel!
    @IBOutlet weak var displayDumbell: UIButton!
    @IBOutlet weak var displayMat: UIButton!
    @IBOutlet weak var displayBike: UIButton!
    @IBOutlet weak var displayType: UILabel!
    @IBOutlet weak var displayExerciseCount: UILabel!
    @IBOutlet weak var displayExerciseImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("in detailed exercise VC")
        print("equipmentlist is ",equipmentList)
        
        displayDumbell.tintColor=UIColor.systemGray5
        displayMat.tintColor=UIColor.systemGray5
        displayBike.tintColor=UIColor.systemGray5

        displayExerciseName.text = exerciseName
        if equipmentList.contains("dumbell"){
            displayDumbell.tintColor=UIColor.systemBlue
            displayDumbell.layer.cornerRadius=5
        }
        else{
            displayDumbell.tintColor=UIColor.systemGray5
        }
        
        if equipmentList.contains("mat"){
            displayMat.tintColor=UIColor.systemBlue
            displayMat.layer.cornerRadius=5
        }
        else{
            displayMat.tintColor=UIColor.systemGray5
        }
        
        if equipmentList.contains("bike"){
            displayBike.tintColor=UIColor.systemBlue
            displayBike.layer.cornerRadius=5
        }
        else{
            displayBike.tintColor=UIColor.systemGray5
        }
        
        displayType.text=exerciseType
        displayExerciseCount.text=repOrTimeNum
        displayExerciseImage.image=exerciseImage
    }
    
}

