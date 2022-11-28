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
        let workoutInfo = WorkOut(workOutStar:5.0,workOutStarNum: 0, workOutImage:workoutImage.image,
                                  workOutName: workoutName.text!,
                                  workOutDifficulty: workoutDifficultyString,
                                  workOutDescription:"blabla",
                                  userName:"mel",
                                  userPhoto:UIImage(systemName: "person.crop.circle"),
                                  workoutId:workOuts.count + 1,
                                  workout_exercises: exerciseArray
                                )
            workOuts.append(workoutInfo)
            personal.append(workoutInfo)
        
        print("exercise array is ",exerciseArray)
        print("workout array is ",workOuts)

    }
    //create table view
    func setupTableView() {
        print("in set up table view")
        exerciseTable.dataSource = self
        exerciseTable.delegate = self
        exerciseTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?{
        let editAction = UITableViewRowAction(style:.normal,title:"Edit"){_,indexPath in
            //open edit view
        }
        let deleteAction=UITableViewRowAction(style:.destructive,title:"Delete"){_,indexPath in
                exerciseArray.remove(at: indexPath.row)
                self.exerciseTable.deleteRows(at: [indexPath], with: .fade)
        }
        return[deleteAction,editAction]
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

