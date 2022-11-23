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
    
    var totalWorkoutTime = 0

    var currentExerciseTime=0
    
    var timer=Timer()
    
    @IBOutlet weak var workoutName: UILabel!
    @IBOutlet weak var workoutTime: UILabel!
    @IBOutlet weak var exerciseName: UILabel!
    @IBOutlet weak var exerciseTime: UILabel!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var pauseBtn: UIButton!
    
    override func viewDidLoad() {
        print("in play workout view controller")
        super.viewDidLoad()
        print(wkoutExercises)
        exerciseIndex=0
        workoutName.text=wkoutName
        exerciseName.text=wkoutExercises[exerciseIndex].exercise_name!
        
        //display playPause button based on exercise time
        var exerciseType=wkoutExercises[exerciseIndex].exercise_type
        
        if exerciseType == "time"{
            print("exercise type is time")
            currentExerciseTime=Int(wkoutExercises[exerciseIndex].exercise_repOrTimeValue)!
        
            exerciseTime.text=getTime(seconds: currentExerciseTime)
            
            //find and display total workout time
            for exercise in wkoutExercises{
                totalWorkoutTime += Int(exercise.exercise_repOrTimeValue)!
            }
            print("total workout time is ",totalWorkoutTime)
            
            workoutTime.text = getTime(seconds: totalWorkoutTime)
            
            //display timer count down
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(playWorkoutController.update), userInfo: nil, repeats: true)

        }
        else if exerciseType == "rep"{
            //don't display timer
            workoutTime.isHidden = true
            exerciseTime.isHidden=true
        }
        
        playBtn.isHidden=true
    }
    func getTime(seconds: Int) -> String{
        let hours = (seconds % 86400) / 3600
        let minutes = (seconds % 3600) / 60
        let seconds = (seconds % 3600) % 60
        let hoursString = String(format: "%02d", hours)
        let minutesString = String(format: "%02d", minutes)
        let secondsString = String(format: "%02d", seconds)
        return hoursString+":"+minutesString+":"+secondsString
    }
    @objc func update(){
        if(totalWorkoutTime > 0) {
            totalWorkoutTime-=1
            workoutTime.text = getTime(seconds: totalWorkoutTime)
        }
        if (currentExerciseTime > 0){
            currentExerciseTime-=1
            exerciseTime.text = getTime(seconds: currentExerciseTime)
        }
        else if (currentExerciseTime > 0){
            //skip to next exercise
            exerciseIndex+=1
            exerciseName.text=wkoutExercises[exerciseIndex].exercise_name
            if wkoutExercises[exerciseIndex].exercise_type == "time"{
                currentExerciseTime = Int(wkoutExercises[exerciseIndex].exercise_repOrTimeValue)!
            }
            else if wkoutExercises[exerciseIndex].exercise_type == "rep"{
                exerciseTime.isHidden=true
            }
        }
    }
    
    @IBAction func nextExercise(_ sender: Any) {
        exerciseIndex+=1
        exerciseName.text=wkoutExercises[exerciseIndex].exercise_name
    }

    
    @IBAction func playClick(_ sender: Any) {
        print("in play click")
        playBtn.isHidden=true
        pauseBtn.isHidden=false
        //resume timer
        //have to recreate timer
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(playWorkoutController.update), userInfo: nil, repeats: true)
    }
    
    @IBAction func pauseClick(_ sender: Any) {
        print("in pause click")
        playBtn.isHidden=false
        pauseBtn.isHidden=true
        //pause timer
        timer.invalidate()

    }
}
