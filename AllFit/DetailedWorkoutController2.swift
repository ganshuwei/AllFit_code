//
//  DetailedWorkoutController2.swift
//  AllFit
//
//  Created by user on 11/30/22.
//

import Foundation
import UIKit

class DetailedWorkoutController2 : UIViewController,UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate{
    
    var wkoutImage: UIImage!
    var wkoutName: String!
//    var wkoutCreator: String!
    var wkoutRating: Double!
    var wkoutRatingNum: Int!
    var creatorName: String!
//    var wkoutDuration: String!
    var wkoutDifficulty: String!
//    var wkoutEquipment: String!
    var wkoutDescription: String!
    var wkoutExercises: [Exercise] = []
    
    @IBOutlet weak var detailedWorkoutImage: UIImageView!
    @IBOutlet weak var detailedCreatorName: UILabel!
    @IBOutlet weak var detailedRating: UILabel!
    @IBOutlet weak var detailedDifficulty: UILabel!
    @IBOutlet weak var detailedDescription: UILabel!
    @IBOutlet weak var exerciseTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailedWorkoutImage.image = wkoutImage
        detailedCreatorName.text = "by: "+creatorName
        detailedRating.text = String(wkoutRating)
        detailedDifficulty.text = wkoutDifficulty
        detailedDescription.text = wkoutDescription
        
        //display exercises in table
        //display them
        setupTableView()
    }
    //create table view
    func setupTableView() {
        print("in set up table view")
        exerciseTable.dataSource = self
        exerciseTable.delegate = self
        exerciseTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exerciseArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel!.text = wkoutExercises[indexPath.row].exercise_name
        return cell
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
