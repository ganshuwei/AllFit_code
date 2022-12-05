import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase
import RealmSwift

class homeViewController: UIViewController {

    var allWorkouts : [WorkOut] = []
    
    var exerciseImage: UIImage!
    
    @IBOutlet weak var collection: UICollectionView!
    
    var completionHandler: ((Int) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collection.dataSource = self
        collection.delegate = self
        collection.collectionViewLayout = UICollectionViewFlowLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        validateLogIn()
        fetchAllWorkOuts()
        collection.reloadData()
    }

    private func validateLogIn(){
        if FirebaseAuth.Auth.auth().currentUser == nil{
            let navigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LogAndSign")
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated: true, completion: nil)
        }
    }
    
    func fetchAllWorkOuts(){
        Database.database().reference().child("workouts").observeSingleEvent(of: .value, with: { snapshot in

            for case let child as DataSnapshot in snapshot.children {
                guard let dict = child.value as? [String:Any] else {
                    print("Error")
                    return
                }
                let workOutName = dict["workOutName"]as? String ?? ""
                
                // Check whether exists in the allWorkouts list
                if(self.allWorkouts.count != 0){
                    var exist = false
                    for workout in self.allWorkouts{
                        if(workout.workOutName == workOutName){
                            exist = true
                            // This child has existed in the allworkouts list
                            break
                        }
                    }
                    if(exist){
                        // Skip this child
                        continue
                    }
                }
                
                let userEmail = dict["userEmail"] as? String ?? ""
                let workOutStar = dict["workOutStar"] as? Double ?? 0.0
                let workOutStarNum = dict["workOutStarNum"] as? Int ?? 0
                let workOutDifficulty = dict["workOutDifficulty"]as? String ?? ""
                let workOutDescription = dict["workOutDescription"]as? String ?? ""
                let workoutId = dict["workoutId"]as? String ?? ""
                let workoutDate = dict[ "workoutDate"]as? String ?? ""
                let workoutTotalSeconds = dict["workoutTotalSeconds"]as? Int ?? 0
                let finishedWorkout = dict["finishedWorkout"]as? Bool ?? false

                let workout_exercises2 = dict["workout_exercises"] as? NSArray
                
                let objCArray = NSMutableArray(array: workout_exercises2 ?? [])
                let workout_exercises: [[String:Any]] = objCArray.compactMap({ $0 as? [String:Any] })

                // Create the exercise list
                var exerciseList : [Exercise] = []
                for dic in workout_exercises{
                    // Add the exercise image
                    let exerciseImageFile = dic["exercise_image"] as? String ?? ""
                    
                    let exercise = Exercise(exercise_name: dic["exercise_name"] as? String ?? "", exercise_type: dic["exercise_type"]as? String ?? "", exercise_repOrTime: dic["exercise_repOrTime"]as? String ?? "", exercise_repOrTimeValue: dic["exercise_repOrTimeValue"]as? String ?? "", exercise_equipment: dic["exercise_equipment"] as? [String] ?? [], exercise_time: dic["exercise_time"] as? Int ?? 0, exercise_image_path: exerciseImageFile,exercise_image: UIImage(systemName: "person"))
                    exerciseList.append(exercise)
                }
                // Get the workout image
                let workoutImageFile = dict["workOutImage"] as? String ?? ""
                let path = "images/" + workoutImageFile

                var workoutImage : UIImage?
                StorageManager.share.fetchPicUrl(for: path, completion: {result in
                    switch result{
                    case .success(let url):
                        DispatchQueue.global().async {
                            // Fetch Image Data
                            if let data = try? Data(contentsOf: url) {
                                DispatchQueue.main.async {
                                    // Create Image and Update Image View
                                   workoutImage = UIImage(data: data)
                                    guard let workoutImage = workoutImage else {
                                        return
                                    }
                                    let workout = WorkOut(workOutStar: workOutStar, workOutStarNum: workOutStarNum, workOutImage: workoutImage, workOutName: workOutName, workOutDifficulty: workOutDifficulty, workOutDescription: workOutDescription, userName: userEmail, userPhoto: UIImage(systemName: "person.crop.circle.fill"), workoutId: workoutId, workout_exercises: exerciseList, workoutDate: workoutDate, workoutTotalSeconds: workoutTotalSeconds, finishedWorkout: finishedWorkout)
                                    self.allWorkouts.append(workout)
                                    self.collection.reloadData()
                                }
                            }
                        }
                    case .failure(let error):
                        print("Fail to get the workout image: \(error)")
                    }
                })
            }
            // Do any additional setup after loading the view.
            self.collection.dataSource = self
            self.collection.delegate = self
            self.collection.collectionViewLayout = UICollectionViewFlowLayout()
            self.collection.reloadData()
            
      }) { error in
        print(error.localizedDescription)
      }

    }
}

extension homeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allWorkouts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "workOutCollectionViewCell", for: indexPath) as! workOutCollectionViewCell
        print("all workouts is ",allWorkouts)
        cell.setUp(with: allWorkouts[indexPath.row])
        let tbc = self.tabBarController  as! MyTabBarController
        let curUser = tbc.curUser
        if(self.allWorkouts[indexPath.row].userName == curUser?.userEmail){
            cell.authorPhoto.image = curUser?.profilePhoto
        }
        cell.completionHandler = { newImage in
            self.allWorkouts[indexPath.row].userPhoto = newImage
        }
        return cell
    }
}

extension homeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 194, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 1, bottom: 10, right: 24)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension homeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let detailedVC = storyboard.instantiateViewController(withIdentifier: "detailedWorkoutVC") as! DetailedWorkoutController2
        
        //Check whether finish this workout before
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        guard let email = user.email else{return}
        let safeEmail = DatabaseManager.safeEmail(userEmail: email)
        let workoutName = allWorkouts[indexPath.row].workOutName
        let workoutAuthor = allWorkouts[indexPath.row].userName
        let workoutEmail = DatabaseManager.safeEmail(userEmail: workoutAuthor)
        let workoutId = workoutEmail + "_" + workoutName
        
        Database.database().reference().child("users/\(safeEmail)").child("finishedWorkouts").observeSingleEvent(of: .value, with: { snapshot in
            for case let child as DataSnapshot in snapshot.children {
                let finishedWorkout = child.value as? [String:Any] ?? [:]

                let finishedWorkoutId = finishedWorkout["workoutId"] as? String ?? ""
                if(finishedWorkoutId == workoutId){
                    detailedVC.checkFinished.text = "You have finished this workout before."
                    detailedVC.checkFinished.textColor = .red
                }
            }
      }) { error in
        print(error.localizedDescription)
      }

        //let detailedVC = DetailedWorkoutController()
        detailedVC.wkoutId = allWorkouts[indexPath.row].workoutId
        detailedVC.wkoutImage = allWorkouts[indexPath.row].workOutImage
        detailedVC.wkoutName=allWorkouts[indexPath.row].workOutName
        detailedVC.wkoutRating=allWorkouts[indexPath.row].workOutStar
        detailedVC.wkoutRatingNum=allWorkouts[indexPath.row].workOutStarNum
        detailedVC.wkoutExercises=allWorkouts[indexPath.row].workout_exercises
        detailedVC.creatorName=allWorkouts[indexPath.row].userName
        detailedVC.wkoutDifficulty=allWorkouts[indexPath.row].workOutDifficulty
        detailedVC.wkoutDescription=allWorkouts[indexPath.row].workOutDescription
        detailedVC.currWorkout = allWorkouts[indexPath.row]

        //push nav controller
        navigationController?.pushViewController(detailedVC, animated: true)
    }
}
