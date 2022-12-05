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
    var repWorkoutTime = 0

    var currentExerciseTime=0
    
    var timer=Timer()
    var totalTimeTimer=Timer()

    var currentWorkout: WorkOut!
    
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
        
        workoutName.text=wkoutName
        
        exerciseIndex=0
        exerciseName.text=wkoutExercises[exerciseIndex].exercise_name!
        
        let exerciseType=wkoutExercises[exerciseIndex].exercise_type
        //display playPause button based on exercise type
        if exerciseType == "time"{
            print("exercise type is time")
            currentExerciseTime=Int(wkoutExercises[exerciseIndex].exercise_repOrTimeValue)!
            exerciseTime.text=getTime(seconds: currentExerciseTime)
            

//
            //display timer count down
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(playWorkoutController.update), userInfo: nil, repeats: true)
            
            totalTimeTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(playWorkoutController.updateTotalTime), userInfo: nil, repeats: true)
            
            nextBtn.isHidden=true
        }
        else if exerciseType == "rep"{
            //don't display timer
            workoutTime.isHidden = false
            exerciseTime.text=String(Int(wkoutExercises[exerciseIndex].exercise_repOrTimeValue)!) + " " + "repetitions"
            nextBtn.isHidden=false
            
            totalTimeTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(playWorkoutController.updateTotalTime), userInfo: nil, repeats: true)
            
        }
        //display workout timer
        workoutTime.text = getTime(seconds: totalWorkoutTime)
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
                if let workoutId = dict["workoutId"] as? String, workoutId == self.wkoutId {
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
    func showNextExercise(){
        print("in show next exercise")
        //display next exercise info
        exerciseName.text=wkoutExercises[exerciseIndex].exercise_name
        
        if wkoutExercises[exerciseIndex].exercise_type == "time"{
            currentExerciseTime = Int(wkoutExercises[exerciseIndex].exercise_repOrTimeValue)!
            exerciseTime.text=getTime(seconds: currentExerciseTime)
            exerciseTime.isHidden=false
            nextBtn.isHidden=false
            //have to recreate timer
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(playWorkoutController.update), userInfo: nil, repeats: true)
        }
        else if wkoutExercises[exerciseIndex].exercise_type == "rep"{
            //stop timer
            timer.invalidate()
            exerciseTime.text=String(Int(wkoutExercises[exerciseIndex].exercise_repOrTimeValue)!) + " " + "repetitions"
            nextBtn.isHidden=false
        }
        //get and display exercise image from firebase storage
        getExerciseImage(imagePath: wkoutExercises[exerciseIndex].exercise_image_path)
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
    
    @objc func updateTotalTime(){
        totalWorkoutTime+=1
        print("total workout time is ",totalWorkoutTime)
        workoutTime.text = getTime(seconds: totalWorkoutTime)
    }
    
    @objc func update(){
        if (currentExerciseTime > 0){
            currentExerciseTime-=1
            exerciseTime.text = getTime(seconds: currentExerciseTime)
        }
        else if (currentExerciseTime == 0){
            print("timed exercise is over")
            print(exerciseIndex)
            print(wkoutExercises.count)
            //skip to next exercise
            if exerciseIndex == wkoutExercises.count-1 {
                finishWorkout()
            }
            else{
                exerciseIndex+=1
                showNextExercise()
            }
        }
    }
    //only for reps
    @IBAction func nextExercise(_ sender: Any) {
        //if last exercise
        if exerciseIndex == wkoutExercises.count-1{
            finishWorkout()
        }
        else{
            exerciseIndex+=1
            showNextExercise()
        }
    }
    
    @IBAction func playClick(_ sender: Any) {
        print("in play click")
        playBtn.isHidden=true
        pauseBtn.isHidden=false
        //resume timer
        //have to recreate timer
        if wkoutExercises[exerciseIndex].exercise_type == "time"{
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(playWorkoutController.update), userInfo: nil, repeats: true)
        }
        totalTimeTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(playWorkoutController.updateTotalTime), userInfo: nil, repeats: true)
    }
    
    @IBAction func pauseClick(_ sender: Any) {
        print("in pause click")
        playBtn.isHidden=false
        pauseBtn.isHidden=true
        //pause timer
        if wkoutExercises[exerciseIndex].exercise_type == "time"{
            timer.invalidate()
        }
        totalTimeTimer.invalidate()
    }
    
    //display congratulations page
    
    //when time is up
    
    //or when finish the last exercise
    
    //
    func finishWorkout(){
        timer.invalidate()
        totalTimeTimer.invalidate()

        print("inside finish workout")
        // Create Date
        let date = Date()
        // Create Date Formatter
        let dateFormatter = DateFormatter()
        // Set Date Format
        dateFormatter.dateFormat = "YY/MM/dd"
        // Convert Date to String
        let dateString = dateFormatter.string(from: date)
        
        guard let user = Auth.auth().currentUser else {return}
        guard var firebaseEmail = user.email else {return}
        firebaseEmail = firebaseEmail.replacingOccurrences(of: ".", with: "-")
        firebaseEmail = firebaseEmail.replacingOccurrences(of: "@", with: "-")
        guard let workoutName = wkoutName else {return}
        let newId = firebaseEmail + "_" + workoutName
        print("Finished workout ID")
        let justFinishedWorkout=[
            "workoutId": newId,
            "totalTime": totalWorkoutTime,
            "date":dateString
        ] as [String : Any]
        
        //pushed firebase
        //firebase: createdWorkouts, favoriteWorkouts, finishedWorkouts
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        //see if there exists a list of finished workout
        //if yes, append to list
        //if no, create new list and append

        //push created workouts to user table
        //get list of created workouts for this user
        ref.child("users").child(firebaseEmail).observeSingleEvent(of: .value, with: {snapshot in
            //if user already as a list of created workouts, append to list
            if snapshot.hasChild("finishedWorkouts"){
                ref.child("users").child(firebaseEmail).child("finishedWorkouts").observeSingleEvent(of: .value, with: {snapshot in
                    var finishedWorkoutsList = snapshot.value as? [[String:Any]]
                    
                    finishedWorkoutsList?.append(justFinishedWorkout)
                    ref.child("users").child(firebaseEmail).child("finishedWorkouts").setValue(finishedWorkoutsList)
                })
            }
            //create list if there isn't
            else{
                ref.child("users").child(firebaseEmail).child("finishedWorkouts").setValue([justFinishedWorkout])
            }
        })
        
        //compute time taken
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let ratingVC = storyboard.instantiateViewController(withIdentifier: "ratingVC") as! ratingController
        
        ratingVC.wkoutID=wkoutId
        ratingVC.wkoutName=wkoutName
        ratingVC.wkoutImage=wkoutImage
        ratingVC.wkoutRating=wkoutRating
        ratingVC.wkoutRatingNum=wkoutRatingNum

        navigationController?.pushViewController(ratingVC, animated: true)
    }
    
}

