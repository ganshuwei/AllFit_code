//
//  DetailedWorkoutController2.swift
//  AllFit
//
//  Created by user on 11/30/22.
//

import Foundation
import UIKit

class DetailedWorkoutController2 : UIViewController,UIScrollViewDelegate{
    
    var wkoutImage: UIImage!
    var wkoutName: String!
//    var wkoutCreator: String!
    var wkoutRating: Double!
    var wkoutRatingNum: Int!

//    var wkoutDuration: String!
//    var wkoutDifficulty: String!
//    var wkoutEquipment: String!
//    var wkoutDescription: String!
    var wkoutExercises: [Exercise] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    @IBAction func openPlayWorkoutVC(_ sender: Any) {
        print("in open play workout")
//        let playWorkoutVC = playWorkoutController()
//
//        navigationController?.pushViewController(playWorkoutVC, animated: true)
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let playWorkoutVC = storyboard.instantiateViewController(withIdentifier: "playWorkoutVC") as! playWorkoutController
        
        playWorkoutVC.wkoutName=wkoutName
        playWorkoutVC.wkoutImage=wkoutImage
        playWorkoutVC.wkoutExercises=wkoutExercises
        playWorkoutVC.wkoutRating=wkoutRating
        playWorkoutVC.wkoutRatingNum=wkoutRatingNum

        navigationController?.pushViewController(playWorkoutVC, animated: true)
    }

}
