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
    @IBOutlet weak var dumbellBtn: UIButton!
    @IBOutlet weak var matBtn: UIButton!
    @IBOutlet weak var bikeBtn: UIButton!
    @IBOutlet weak var submitExercise: UIButton!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var repOrTimeValue: UITextField!
    
    var equipmentList:[String] = []
    
    var exerciseTypeString="rep"  //default value

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        matBtn.tintColor=UIColor.systemGray5
        dumbellBtn.tintColor=UIColor.systemGray5
        bikeBtn.tintColor=UIColor.systemGray5
        
    }
    @IBAction func exerciseTypeChangeAction(_ sender: Any) {
        let exerciseTypeIndex = exerciseType.selectedSegmentIndex
        if exerciseTypeIndex == 0{
            exerciseTypeString = "rep"
            amountLabel.text="No. of reps"
        }
        else if exerciseTypeIndex == 1{
            exerciseTypeString = "time"
            amountLabel.text="Duration (s)"
        }
    }
    
    @IBAction func submitExerciseClick(_ sender: Any) {
        // Check exercise equiment select or empty
        if(matBtn.tintColor == UIColor.systemGray5 && bikeBtn.tintColor == UIColor.systemGray5 && dumbellBtn.tintColor == UIColor.systemGray5){
            let alert = UIAlertController(title: "Missing Equipment", message: "You must select at least one equipment.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { action in
                        })
            alert.addAction(defaultAction)
            self.present(alert, animated: true)
            return
        }
        // Check the textField
        if let exerciseNameString = exerciseName.text, let repOrTimeValueString = repOrTimeValue.text{
            if(exerciseNameString.isEmpty || repOrTimeValueString.isEmpty){
                let alert = UIAlertController(title: "Missing input words", message: "You must set the exercise name and time.", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { action in
                            })
                alert.addAction(defaultAction)
                self.present(alert, animated: true)
                return
            }
        }
        
        //get values from interface
        //get exercise image url
        guard let exerciseImage=exerciseImage.image, let data = exerciseImage.pngData() else {return}
        let randomNumber = String(Int.random(in: 1...1000000))
        let exerciseFileName = exerciseName.text! + randomNumber + "_exercise_photo.png"
        StorageManager.share.uploadProfilePicture(with: data, fileName: exerciseFileName, completion:{result in
            switch result {
                case .success(let downloadUrl):
                    print(downloadUrl)
                case .failure(let error):
                    print("Firebase storage error: \(error)")
            }
        })
        //add exercise to array of exercises
        let exerciseInfo = Exercise(
                          exercise_name: String(exerciseName.text!),
                          exercise_type: exerciseTypeString,
                          exercise_repOrTime: exerciseTypeString,
                          exercise_repOrTimeValue:repOrTimeValue.text!,
                          exercise_equipment: equipmentList,
                          exercise_time: 160,
                          exercise_image_path: exerciseFileName,
                          exercise_image: exerciseImage
                          )
        
        let firebaseExerciseInfo: [String:Any] = [
            "exercise_name": String(exerciseName.text!),
            "exercise_id": String(exerciseName.text!)+randomNumber,
            "exercise_type": exerciseTypeString,
            "exercise_repOrTime": exerciseTypeString,
            "exercise_repOrTimeValue":repOrTimeValue.text!,
            "exercise_equipment": equipmentList,
            "exercise_time": 160,
            "exercise_image": exerciseFileName
        ]
        //get list of exercises
        exerciseArray.append(exerciseInfo)
        print("exercise array is ",exerciseArray)
        
        exerciseArrayFirebase.append(firebaseExerciseInfo)

        //go to previous view controller
    }
    
    
    @IBAction func enterExerciseName(_ sender: Any) {
        exerciseNameLabel.text = exerciseName.text
    }
    
    @IBAction func uploadExerciseImage(_ sender: Any) {
        presentPhotoActionSheet()
    }
    
    @IBAction func clickDumbell(_ sender: Any) {
        print("inside clickDumbell")
        if dumbellBtn.tintColor == UIColor.systemBlue{
            let indexDumbell = equipmentList.firstIndex(of: "dumbell")
            equipmentList.remove(at: indexDumbell!)
            dumbellBtn.tintColor=UIColor.systemGray5
            dumbellBtn.layer.cornerRadius=5
        }
        else if dumbellBtn.tintColor == UIColor.systemGray5{
            equipmentList.append("dumbell")
            dumbellBtn.tintColor=UIColor.systemBlue
            dumbellBtn.layer.cornerRadius=5
        }
    }

    @IBAction func matBtn(_ sender: Any) {
        print("inside matBtn")
        if matBtn.tintColor == UIColor.systemBlue{
            let indexMat = equipmentList.firstIndex(of: "mat")
            equipmentList.remove(at: indexMat!)
            matBtn.tintColor=UIColor.systemGray5
            matBtn.layer.cornerRadius=5
        }
        else if matBtn.tintColor == UIColor.systemGray5{
            equipmentList.append("mat")
            matBtn.tintColor=UIColor.systemBlue
            matBtn.layer.cornerRadius=5
        }
    }
    @IBAction func bikeBtn(_ sender: Any) {
        print("inside bikeBtn")
        if bikeBtn.tintColor == UIColor.systemBlue{
            let indexBike = equipmentList.firstIndex(of: "bike")
            equipmentList.remove(at: indexBike!)
            bikeBtn.tintColor=UIColor.systemGray5
            bikeBtn.layer.cornerRadius=5
        }
        else if bikeBtn.tintColor == UIColor.systemGray5{
            equipmentList.append("bike")
            bikeBtn.tintColor=UIColor.systemBlue
            bikeBtn.layer.cornerRadius=5
        }
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
