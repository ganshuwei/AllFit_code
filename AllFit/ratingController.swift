//
//  ratingController.swift
//  AllFit
//
//  Created by user on 11/27/22.
//

import Foundation
import UIKit

class ratingController : UIViewController{

    var wkoutImage: UIImage!
    var wkoutName: String!
    var wkoutRating: Double!
    var wkoutRatingNum: Int!

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
        if thisUserRating != 0{

            //calculate and update rating
            let newWorkoutRating = (wkoutRating + thisUserRating) / (Double(wkoutRatingNum)+1.0)
            
            if let i = workOuts.firstIndex(where: { $0.workOutName == wkoutName }) {
                workOuts[i].workOutStar = newWorkoutRating
            }
            //redirect to feed
        }
        else if thisUserRating == 0{
            //redirect to feed

        }
    }
}
