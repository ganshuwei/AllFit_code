//
//  CreateExerciseView.swift
//  AllFit
//
//  Created by user on 11/13/22.
//

import Foundation
import Firebase
import FirebaseAuth

class CreateExerciseView: UIViewController{
    
    
    @IBOutlet weak var exerciseNameLabel: UILabel!
    @IBOutlet weak var exerciseImage: UIImageView!
    @IBOutlet weak var exerciseName: UITextField!
    @IBOutlet weak var exerciseType: UISegmentedControl!
    @IBOutlet weak var repsOrTime: UITextField!
    @IBOutlet weak var dumbellBtn: UIButton!
    @IBOutlet weak var matBtn: UIButton!
    @IBOutlet weak var bikeBtn: UIButton!
    @IBOutlet weak var submitExercise: UIButton!
    
//    struct Exercise: Encodable, Decodable {
//     var exercise_name: String?
//     var exercise_type: String
//     var exercise_repOrTime: Int!
//     var exercise_equipment: [String]
//    }
//
//    var exerciseArray: [Exercise] = []
//
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

    }
    
    @IBAction func submitExerciseClick(_ sender: Any) {
        print("exercise submited")
        //get values from interface
        let equipmentList=["dumbell","mat"]
        let exerciseTypeIndex = exerciseType.selectedSegmentIndex
        var exerciseTypeString=""
        if exerciseTypeIndex == 0{
            exerciseTypeString = "dumbell"
        }
        else if exerciseTypeIndex == 1{
            exerciseTypeString = "mat"
        }
        else if exerciseTypeIndex == 2{
            exerciseTypeString = "bike"
        }
        //add exercise to array of exercises
        let exerciseInfo = Exercise(
                          exercise_name: String(exerciseName.text!),
                          exercise_type: exerciseTypeString,
                          exercise_repOrTime: Int(repsOrTime.text!),
                          exercise_equipment: equipmentList
                            )
        //get list of exercises
        exerciseArray.append(exerciseInfo)
        print("exercise array is ",exerciseArray)
        
        //reload table
//        CreateWorkoutView.exerciseTable.reloadData()
        
//        let defaults = UserDefaults.standard
//        if let data = defaults.data(forKey: "MyExercises") {
//            var exerciseArray = try! PropertyListDecoder().decode([Exercise].self, from: data)
//            //add new exercise to list of exercises
//            exerciseArray.append(exerciseInfo)
//            if let data = try? PropertyListEncoder().encode(exerciseArray) {
//                    UserDefaults.standard.set(data, forKey: "MyExercises")
//            }
//            print("exercise array is ",exerciseArray)
//        }
    }
    
    @IBAction func enterExerciseName(_ sender: Any) {
        exerciseNameLabel.text = exerciseName.text
    }
    
    
    
    @IBAction func uploadExerciseImage(_ sender: Any) {
        presentPhotoActionSheet()
    }
}

extension CreateExerciseView: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
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
        self.exerciseImage.image = selectedImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true,completion: nil)
    }
}
