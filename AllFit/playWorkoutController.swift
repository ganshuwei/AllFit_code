//
//  playWorkoutController.swift
//  AllFit
//
//  Created by user on 11/22/22.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth

class playWorkoutController : UIViewController{
    
    var wkoutId: String!
    var wkoutImage: UIImage!
    var wkoutName: String!
//    var wkoutCreator: String!
//    var wkoutDuration: String!
//    var wkoutDifficulty: String!
//    var wkoutEquipment: String!
//    var wkoutDescription: String!
    var wkoutExercises: [Exercise] = []
    var wkoutRating: Double!
    var wkoutRatingNum: Int!

    var exerciseIndex=0
    
    var totalWorkoutTime = 0

    var currentExerciseTime=0
    
    var timer=Timer()
    
    
    @IBOutlet weak var currExerciseImage: UIImageView!
    @IBOutlet weak var workoutName: UILabel!
    @IBOutlet weak var workoutTime: UILabel!
    @IBOutlet weak var exerciseName: UILabel!
    @IBOutlet weak var exerciseTime: UILabel!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var pauseBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    override func viewDidLoad() {
        print("in play workout view controller")
        super.viewDidLoad()
        print(wkoutExercises)
        exerciseIndex=0
        workoutName.text=wkoutName
        
        exerciseName.text=wkoutExercises[exerciseIndex].exercise_name!
        
        //display playPause button based on exercise time
        let exerciseType=wkoutExercises[exerciseIndex].exercise_type
        
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

            nextBtn.isHidden=true
        }
        else if exerciseType == "rep"{
            //don't display timer
            workoutTime.isHidden = true
            exerciseTime.isHidden=true
        }
        playBtn.isHidden=true
        
        //get exercise image from firebase storage
        getExerciseImage(imagePath: wkoutExercises[exerciseIndex].exercise_image_path)
        
    }
    func getExerciseImage(imagePath: String!){

        Database.database().reference().child("workouts").observeSingleEvent(of: .value, with: { snapshot in

            for case let child as DataSnapshot in snapshot.children {
                guard let dict = child.value as? [String:Any] else {
                    print("Error")
                    return
                }
                //the workout we are currently playing
                if dict["workoutId"] as! String == self.wkoutId {
                    //get current exercise name
                    let currentExerciseName = self.wkoutExercises[self.exerciseIndex].exercise_name!
                    
                    let exerciseList = dict["workout_exercises"] as? NSArray
                    let objCArray = NSMutableArray(array: exerciseList!)
                    let exerciseArray: [[String:Any]] = objCArray.compactMap({ $0 as? [String:Any] })
                    
                    //loop through exercises
                    for exercise in exerciseArray{
                        if exercise["exercise_name"] as! String == currentExerciseName {
                            //get exercise image
                            let exercisePicName=exercise["exercise_image"] as! String
                            let currentExercisePicPath = "images/"+exercisePicName
                           
                            var exerciseImage : UIImage?
                            StorageManager.share.fetchPicUrl(for: currentExercisePicPath, completion: {result in
                                switch result{
                                case .success(let url):
                                    DispatchQueue.global().async {
                                        // Fetch Image Data
                                        if let data = try? Data(contentsOf: url) {
                                            DispatchQueue.main.async {
                                                exerciseImage = UIImage(data: data)
                                                guard let exerciseImage = exerciseImage else {
                                                    return
                                                }
                                                self.currExerciseImage.image=exerciseImage
                                            }
                                        }
                                    }
                                case .failure(let error):
                                    print("Fail to get the exercise image: \(error)")
                                }
                            })
                        }
                    }
                }
            }
        })
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
        // if workout is completed
        if totalWorkoutTime == 0 {
            //stop timer
            timer.invalidate()
            finishWorkout()
        }
    }
    //only for reps
    @IBAction func nextExercise(_ sender: Any) {
        exerciseIndex+=1
        //if last exercise
        if exerciseIndex == wkoutExercises.count {
            finishWorkout()
        }
        else{
            exerciseName.text=wkoutExercises[exerciseIndex].exercise_name
        }
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
    
    //display congratulations page
    
    //when time is up
    
    //or when finish the last exercise
    @IBAction func endWorkout(_ sender: Any) {
        finishWorkout()
    }
    
    //
    func finishWorkout(){
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let ratingVC = storyboard.instantiateViewController(withIdentifier: "ratingVC") as! ratingController
        
        ratingVC.wkoutName=wkoutName
        ratingVC.wkoutImage=wkoutImage
        ratingVC.wkoutRating=wkoutRating
        ratingVC.wkoutRatingNum=wkoutRatingNum

        navigationController?.pushViewController(ratingVC, animated: true)
        
        //pushed firebase
        //firebase: createdWorkouts, favoriteWorkouts, finishedWorkouts
        var ref: DatabaseReference!
        ref = Database.database().reference()
        var firebaseEmail = Auth.auth().currentUser!.email!
        firebaseEmail = firebaseEmail.replacingOccurrences(of: ".", with: "-")
        firebaseEmail = firebaseEmail.replacingOccurrences(of: "@", with: "-")
        
        let workoutId = firebaseEmail + "_" + wkoutName

        if firebaseEmail != nil{
            //replace dot by dash

            print("firebase email is ",firebaseEmail)
            print("workout id is ",workoutId)

            //push created workouts to user table
            ref.child("users").child(firebaseEmail).child("finishedWorkouts").observeSingleEvent(of: .value, with:{snapshot in
                var finishedWorkoutsList = snapshot.value as? [String]
                finishedWorkoutsList?.append(workoutId)
                //push to firebase
                ref.child("users").child(firebaseEmail).child("finishedWorkouts").setValue(finishedWorkoutsList)
            })
        }
    }
    
}

