//
//  CreateWorkoutView.swift
//  AllFit
//
//  Created by user on 11/13/22.
//

import Foundation
import Firebase
import FirebaseAuth

class CreateWorkoutView: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var workoutNameLabel: UILabel!
    @IBOutlet weak var workoutImage: UIImageView!
    @IBOutlet weak var workoutName: UITextField!
    @IBOutlet weak var exerciseTable: UITableView!
    @IBOutlet weak var workoutDifficulty: UISegmentedControl!
    @IBOutlet weak var workoutDescription: UITextField!
    
    var workoutDifficultyString=""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print("in workout load view")
        exerciseTable.isEditing = true
        exerciseTable.allowsSelectionDuringEditing = true
        // Do any additional setup after loading the view.
        exerciseTable.reloadData()
        print("exercise array is ",exerciseArray)
        //display them
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        exerciseTable.reloadData()
        setupTableView()
    }
    
    @IBAction func enterWorkoutName(_ sender: Any) {
        workoutNameLabel.text = workoutName.text
    }
    
    
    @IBAction func workoutDifficultyToggle(_ sender: Any) {
        let workoutDifficultyIndex = workoutDifficulty.selectedSegmentIndex
        
        if workoutDifficultyIndex == 0{
            workoutDifficultyString = "Easy"
        }
        else if workoutDifficultyIndex == 1{
            workoutDifficultyString = "Medium"
        }
        else if workoutDifficultyIndex == 2{
            workoutDifficultyString = "Hard"
        }
    }
    
    @IBAction func postWorkoutBtn(_ sender: Any) {
        // If no exercises for the new workout, show the alert
        // If the workout name or workout description is empty, show the alert 
        if(exerciseArray.count == 0){
            let alert = UIAlertController(title: "Missing Exercises", message: "You must add ar least one exercise.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { action in
                        })
            alert.addAction(defaultAction)
            self.present(alert, animated: true)
            return
        }
        
        if let workoutNameText = workoutName.text, let descText = workoutDescription.text{
            if(workoutNameText.isEmpty || descText.isEmpty){
                let alert = UIAlertController(title: "Missing input words", message: "You must set the workout name and description.", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { action in
                            })
                alert.addAction(defaultAction)
                self.present(alert, animated: true)
                return
            }
        } 

        
        guard let workOutimage=workoutImage.image, let data = workOutimage.pngData() else {return}
        
        let randomNumberWorkout = String(Int.random(in: 1...1000000))
        let fileName = workoutName.text! + randomNumberWorkout + "_workout_photo.png"
        let dateFormatter : DateFormatter = DateFormatter()
        StorageManager.share.uploadProfilePicture(with: data, fileName: fileName, completion:{result in
            switch result {
                case .success(let downloadUrl):
                    print(downloadUrl)
                case .failure(let error):
                    print("Firebase storage error: \(error)")
            }
        })
        
        let firebaseWorkoutInfo: [String:Any] = [
              "workOutStar":5.0,
              "workOutStarNum": 0,
              "workOutImage":fileName,
              "workOutName": workoutName.text!,
              "workOutDifficulty": workoutDifficultyString,
              "workOutDescription":workoutDescription.text!,
              "userEmail": Auth.auth().currentUser!.email!,
              "workoutId": workoutName.text! + randomNumberWorkout,
              "workout_exercises": exerciseArrayFirebase,
              "workoutDate": dateFormatter.string(from: Date()),
              "workoutTotalSeconds": 100,
              "finishedWorkout": false
        ]
        //push to firebase
        //if first time pushing, need to create new list
        //if list is there, append to list
        var ref: DatabaseReference!
        ref = Database.database().reference()
        guard let user = Auth.auth().currentUser else {return}
        guard var firebaseEmail = user.email else {return}
        firebaseEmail = firebaseEmail.replacingOccurrences(of: ".", with: "-")
        firebaseEmail = firebaseEmail.replacingOccurrences(of: "@", with: "-")
        
        let workoutId = firebaseEmail + "_" + workoutName.text!

        //replace dot by dash

        print("firebase email is ",firebaseEmail)
        print("workout id is ",workoutId)

        //push created workouts to user table
        
        //get list of created workouts for this user
        ref.child("users").child(firebaseEmail).observeSingleEvent(of: .value, with: {snapshot in
            //if user already as a list of created workouts, append to list
            if snapshot.hasChild("createdWorkouts"){
                ref.child("users").child(firebaseEmail).child("createdWorkouts").observeSingleEvent(of: .value, with: {snapshot in
                    let createdWorkoutsList = snapshot.value as? [String]
                    guard var createdWorkoutsList = createdWorkoutsList else {return}
                    if createdWorkoutsList.contains(workoutId){
                        let alert = UIAlertController(title: "Duplicate Workout Name", message: "Use Another Workout Name", preferredStyle: .alert)
                        let defaultAction2 = UIAlertAction(title: "OK", style: .default, handler: { action in
                                    })
                        alert.addAction(defaultAction2)
                        self.present(alert, animated: true)
                        return
                    }else{
                        createdWorkoutsList.append(workoutId)
                        ref.child("users").child(firebaseEmail).child("createdWorkouts").setValue(createdWorkoutsList)
                    }

                })
            }
            //create list if there isn't
            else{
                let inputIdList=[workoutId]
                ref.child("users").child(firebaseEmail).child("createdWorkouts").setValue(inputIdList)
            }
        })
        ref.child("workouts").child(workoutId).setValue(firebaseWorkoutInfo)
        exerciseArray = []
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "createWorkOutVC") as! CreateWorkoutView
        var vcs = self.navigationController!.viewControllers // get all vcs
        vcs = vcs.dropLast()
        vcs.append(VC)
        self.navigationController!.setViewControllers(vcs,animated:false)
    }
    //create table view
    func setupTableView() {
        print("in set up table view")
        exerciseTable.dataSource = self
        exerciseTable.delegate = self
        exerciseTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    //click on exercise in table view -> opens preview
    
//
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?{
        let editAction = UITableViewRowAction(style:.normal,title:"Edit"){_,indexPath in
            //open edit view

        }
        let deleteAction=UITableViewRowAction(style:.destructive,title:"Delete"){_,indexPath in
                exerciseArray.remove(at: indexPath.row)
                self.exerciseTable.deleteRows(at: [indexPath], with: .fade)
        }
        return[deleteAction]
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exerciseArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel!.text = exerciseArray[indexPath.row].exercise_name
        return cell
    }
    
    //preview exercise
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("clicked on row")
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let detailedExerciseVC = storyboard.instantiateViewController(withIdentifier: "detailedExerciseVC") as! detailedExerciseController

        detailedExerciseVC.exerciseName = exerciseArray[indexPath.row].exercise_name
        detailedExerciseVC.exerciseType=exerciseArray[indexPath.row].exercise_type
        detailedExerciseVC.equipmentList=exerciseArray[indexPath.row].exercise_equipment
        detailedExerciseVC.repOrTimeNum=exerciseArray[indexPath.row].exercise_repOrTimeValue
        detailedExerciseVC.exerciseImage=exerciseArray[indexPath.row].exercise_image
        //push nav controller
        navigationController?.pushViewController(detailedExerciseVC, animated: true)
    }
    //switch order of exercises
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let movedObject = exerciseArray[sourceIndexPath.row]
        exerciseArray.remove(at: sourceIndexPath.row)
        exerciseArray.insert(movedObject, at: destinationIndexPath.row)
    }
    
    @IBAction func uploadWorkoutPhoto(_ sender: Any) {
        presentPhotoActionSheet()
    }
}


extension CreateWorkoutView: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func presentPhotoActionSheet(){
        let actionSheet = UIAlertController(title: "Profile Picture", message: "How do you like to select a picture?", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: {[weak self] _ in
            self?.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: {[weak self] _ in
            self?.presentPhotoPicker()
        }))
        
        present(actionSheet, animated: true)
    }
    
    func presentCamera(){
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func presentPhotoPicker(){
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else{return}
        self.workoutImage.image = selectedImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true,completion: nil)
    }
}

