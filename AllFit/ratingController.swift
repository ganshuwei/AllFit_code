//
//  ratingController.swift
//  AllFit
//
//  Created by user on 11/27/22.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth

class ratingController : UIViewController{

    var wkoutImage: UIImage!
    var wkoutName: String!
    var wkoutRating: Double!
    var wkoutRatingNum: Int!
    var wkoutID: String!

    var thisUserRating:Double!
    
    @IBOutlet weak var star1: UIButton!
    @IBOutlet weak var star2: UIButton!
    @IBOutlet weak var star3: UIButton!
    @IBOutlet weak var star4: UIButton!
    @IBOutlet weak var star5: UIButton!
    
    @IBOutlet weak var submitOrSkipBtn: UIButton!
    
    override func viewDidLoad() {
        print("in rating view controller")
        super.viewDidLoad()
    }
    
    @IBAction func star1Press(_ sender: Any) {
        star1.setImage(UIImage(systemName: "star.fill"), for: UIControl.State.normal)
        star2.setImage(UIImage(systemName: "star"), for: UIControl.State.normal)
        star3.setImage(UIImage(systemName: "star"), for: UIControl.State.normal)
        star4.setImage(UIImage(systemName: "star"), for: UIControl.State.normal)
        star5.setImage(UIImage(systemName: "star"), for: UIControl.State.normal)
        thisUserRating=1
        //change label to submit
        submitOrSkipBtn.setTitle("Submit", for: UIControl.State.normal)
    }
    
    @IBAction func star2Press(_ sender: Any) {
        star1.setImage(UIImage(systemName: "star.fill"), for: UIControl.State.normal)
        star2.setImage(UIImage(systemName: "star.fill"), for: UIControl.State.normal)
        star3.setImage(UIImage(systemName: "star"), for: UIControl.State.normal)
        star4.setImage(UIImage(systemName: "star"), for: UIControl.State.normal)
        star5.setImage(UIImage(systemName: "star"), for: UIControl.State.normal)
        thisUserRating=2
        //change label to submit
        submitOrSkipBtn.setTitle("Submit", for: UIControl.State.normal)
    }
    
    @IBAction func star3Press(_ sender: Any) {
        star1.setImage(UIImage(systemName: "star.fill"), for: UIControl.State.normal)
        star2.setImage(UIImage(systemName: "star.fill"), for: UIControl.State.normal)
        star3.setImage(UIImage(systemName: "star.fill"), for: UIControl.State.normal)
        star4.setImage(UIImage(systemName: "star"), for: UIControl.State.normal)
        star5.setImage(UIImage(systemName: "star"), for: UIControl.State.normal)
        thisUserRating=3
        //change label to submit
        submitOrSkipBtn.setTitle("Submit", for: UIControl.State.normal)

    }
    
    @IBAction func star4Press(_ sender: Any) {
        star1.setImage(UIImage(systemName: "star.fill"), for: UIControl.State.normal)
        star2.setImage(UIImage(systemName: "star.fill"), for: UIControl.State.normal)
        star3.setImage(UIImage(systemName: "star.fill"), for: UIControl.State.normal)
        star4.setImage(UIImage(systemName: "star.fill"), for: UIControl.State.normal)
        star5.setImage(UIImage(systemName: "star"), for: UIControl.State.normal)
        thisUserRating=4
        //change label to submit
        submitOrSkipBtn.setTitle("Submit", for: UIControl.State.normal)

    }
    
    @IBAction func star5Press(_ sender: Any) {
        star1.setImage(UIImage(systemName: "star.fill"), for: UIControl.State.normal)
        star2.setImage(UIImage(systemName: "star.fill"), for: UIControl.State.normal)
        star3.setImage(UIImage(systemName: "star.fill"), for: UIControl.State.normal)
        star4.setImage(UIImage(systemName: "star.fill"), for: UIControl.State.normal)
        star5.setImage(UIImage(systemName: "star.fill"), for: UIControl.State.normal)
        thisUserRating=5
        //change label to submit
        submitOrSkipBtn.setTitle("Submit", for: UIControl.State.normal)
    }
    
    @IBAction func skipOrSubmitPress(_ sender: Any) {
        //get rating data from firebase
        if thisUserRating != 0{

            Database.database().reference().child("workouts").observeSingleEvent(of: .value, with: { snapshot in

                for case let child as DataSnapshot in snapshot.children {
                    let workoutKey = child.key
                    guard let dict = child.value as? [String:Any] else {
                        print("Error")
                        return
                    }
                    //the workout we are currently playing
                    guard let workoutId = dict["workoutId"] as? String else{return}
                    if  workoutId == self.wkoutID {
                        //get rating and rating num
                        let currRating = dict["workOutStar"] as? Double ?? 0.0
                        let currRatingCount = dict["workOutStarNum"] as? Int ?? 0
                        
                        print("current rating is ",currRating )
                        print("current rating count is ",currRatingCount )

                        //calculate and update rating
                        var newWorkoutRating = (currRating * Double(currRatingCount) + self.thisUserRating!) / (Double(currRatingCount)+1.0)
                        newWorkoutRating = round(100 * newWorkoutRating) / 100
                        
                        //replace values in firebase data
                        Database.database().reference().child("workouts").child(workoutKey).updateChildValues(["workOutStar": newWorkoutRating,"workOutStarNum": currRatingCount+1])
                        
                        // Update home view workout ratting
                        if let rootVC = self.navigationController?.viewControllers.first as? homeViewController {
                            let workoutList = rootVC.allWorkouts
                            if let index = workoutList.firstIndex(where: { $0.workoutId == workoutId }){
                                rootVC.allWorkouts[index].workOutStar = newWorkoutRating
                                rootVC.allWorkouts[index].workOutStarNum += 1
                            }
                        }
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }
            })
        }
        else if thisUserRating == 0{

        }
        //redirect to analytics
    }
}
