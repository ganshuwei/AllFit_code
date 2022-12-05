//
//  DetailedWorkoutController2.swift
//  AllFit
//
//  Created by user on 11/30/22.
//

import Foundation
import UIKit

class DetailedWorkoutController2 : UIViewController,UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate{
    
    var wkoutId: String!
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
    
    @IBOutlet weak var checkFinished: UILabel!
    var currWorkout: WorkOut!
    
    @IBOutlet weak var detailedWorkoutName: UILabel!
    @IBOutlet weak var detailedWorkoutImage: UIImageView!
    @IBOutlet weak var detailedCreatorName: UILabel!
    @IBOutlet weak var detailedRating: UILabel!
    @IBOutlet weak var detailedDifficulty: UILabel!
    @IBOutlet weak var detailedDescription: UILabel!
    @IBOutlet weak var exerciseTable: UITableView!
    
    @IBOutlet weak var timeBasedLabel: UILabel!
    @IBOutlet weak var repBasedLabel: UILabel!
    
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var dumbellImage: UIImageView!
    @IBOutlet weak var matImage: UIImageView!
    @IBOutlet weak var bikeImage: UIImageView!
    
    @IBOutlet weak var equipmentBackground: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailedWorkoutName.text=wkoutName
        detailedWorkoutImage.image = wkoutImage
        detailedCreatorName.text = "by: "+creatorName
        detailedRating.text = String(wkoutRating)
        detailedDifficulty.text = wkoutDifficulty
        detailedDescription.text = wkoutDescription
        
        durationLabel.isHidden=true
        dumbellImage.isHidden=true
        matImage.isHidden=true
        bikeImage.isHidden=true
        equipmentBackground.isHidden=true

        var timedExercises = false
        var repExercises = false
        for exercise in wkoutExercises {
            if exercise.exercise_repOrTime == "time"{
                timedExercises = true
            }
            if exercise.exercise_repOrTime == "rep"{
                repExercises = true
            }
        }
        print("repExercises is ",repExercises)
        print("timedExercises is ",timedExercises)

        //if both are true
        if (repExercises == true && timedExercises == true) {
            timeBasedLabel.isHidden=false
            repBasedLabel.isHidden=false
        }
        //if rep workouts
        else if (repExercises == true && timedExercises == false) {
            repBasedLabel.isHidden=false
            timeBasedLabel.isHidden=true

        }
        else if (repExercises == false && timedExercises == true){
            repBasedLabel.isHidden=true
            timeBasedLabel.isHidden=false
            //compute total time
            var totalExerciseTime = 0
            for exercise in wkoutExercises {
                let exerciseTime = Int(exercise.exercise_repOrTimeValue) ?? 0
                totalExerciseTime += exerciseTime
            }
            durationLabel.isHidden=false
            durationLabel.text = String(totalExerciseTime)
        }
        
        //equipment images
        var equipmentList:[String] = []
        for exercise in wkoutExercises {
            for equipment in exercise.exercise_equipment{
                if !equipmentList.contains(equipment){
                    equipmentList.append(equipment)
                }
            }
        }
        print("equipment list is ",equipmentList)
        
        if equipmentList.contains("dumbell"){
            dumbellImage.isHidden=false
            equipmentBackground.isHidden=false
        }
        if equipmentList.contains("mat"){
            matImage.isHidden=false
            equipmentBackground.isHidden=false
        }
        if equipmentList.contains("bike"){
            bikeImage.isHidden=false
            equipmentBackground.isHidden=false
        }
        
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
        return wkoutExercises.count
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
        
        playWorkoutVC.wkoutId=wkoutId
        playWorkoutVC.wkoutName=wkoutName
        playWorkoutVC.wkoutImage=wkoutImage
        playWorkoutVC.wkoutExercises=wkoutExercises
        playWorkoutVC.wkoutRating=wkoutRating
        playWorkoutVC.wkoutRatingNum=wkoutRatingNum
        playWorkoutVC.currentWorkout = currWorkout
        
        navigationController?.pushViewController(playWorkoutVC, animated: true)
    }

}
