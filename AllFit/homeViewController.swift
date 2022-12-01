import UIKit
import FirebaseAuth
import Firebase

class homeViewController: UIViewController {


    @IBOutlet weak var searchBtn: UIBarButtonItem!
    
    @IBOutlet weak var collection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collection.dataSource = self
        collection.delegate = self
        collection.collectionViewLayout = UICollectionViewFlowLayout()
        
        //get data from firebase
        var ref: DatabaseReference!
        ref = Database.database().reference()
        var workoutsList: [[String]] = [[]]
//        ref.child("workouts").observeSingleEvent(of: .value, with:{snapshot in
//            workoutsList = (snapshot.value as? [[String]])!
//            print("workouts list is ",workoutsList)
//        })
    }
    override func viewWillAppear(_ animated: Bool) {
        self.collection.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        validateLogIn()
    }

    private func validateLogIn(){
        if FirebaseAuth.Auth.auth().currentUser == nil{
            let navigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LogAndSign")
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated: true, completion: nil)
        }
    }
    
    @IBAction func searchAction(_ sender: UIBarButtonItem) {
        
    }
}

extension homeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return workOuts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "workOutCollectionViewCell", for: indexPath) as! workOutCollectionViewCell
        
        cell.setUp(with: workOuts[indexPath.row])
        
        cell.index = indexPath.row
        
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
        print(workOuts[indexPath.row].workOutName)
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let detailedVC = storyboard.instantiateViewController(withIdentifier: "detailedWorkoutVC") as! DetailedWorkoutController2

        //let detailedVC = DetailedWorkoutController()
        detailedVC.wkoutImage = workOuts[indexPath.row].workOutImage
        detailedVC.wkoutName=workOuts[indexPath.row].workOutName
        detailedVC.wkoutRating=workOuts[indexPath.row].workOutStar
        detailedVC.wkoutRatingNum=workOuts[indexPath.row].workOutStarNum
        detailedVC.wkoutExercises=workOuts[indexPath.row].workout_exercises

        //push nav controller
        navigationController?.pushViewController(detailedVC, animated: true)
    }
}
