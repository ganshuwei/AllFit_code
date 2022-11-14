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

    
    @IBOutlet weak var workoutImage: UIImageView!
    @IBOutlet weak var workoutName: UITextField!
    @IBOutlet weak var exerciseTable: UITableView!
    @IBOutlet weak var workoutDifficulty: UITextField!
    
//    struct Workout: Decodable {
//     let workout_name: String?
//     let workout_difficulty: String
//     let workout_exercises: [Exercise]
//    }
//    struct Exercise: Decodable {
//     let exercise_name: String?
//     let exercise_type: String
//     let exercise_repOrTime: Int!
//     let exercise_equipment: [String]
//    }
//
    override func viewDidLoad() {
        super.viewDidLoad()
        print("in workout load view")
        // Do any additional setup after loading the view.
        exerciseTable.reloadData()
        //get list of exercises
//        let defaults = UserDefaults.standard
//        if let data = defaults.data(forKey: "MyExercises") {
//            var exerciseArray = try! PropertyListDecoder().decode([Exercise].self, from: data)
//        }
        print("exercise array is ",exerciseArray)
        //display them
        setupTableView()
    }
    
    @IBAction func postWorkoutBtn(_ sender: Any) {
        let workoutInfo = Workout(
            workout_name: workoutName.text!, workout_difficulty: workoutDifficulty.text!, workout_exercises: exerciseArray
                            )
        workoutArray.append(workoutInfo)
        
        print("exercise array is ",exerciseArray)
        print("workout array is ",workoutArray)
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
        cell.textLabel!.text = exerciseArray[indexPath.row].exercise_name
        return cell
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

