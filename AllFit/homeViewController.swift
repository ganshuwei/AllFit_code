import UIKit
import FirebaseAuth

class homeViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource {

    

    @IBOutlet weak var searchBtn: UIBarButtonItem!
    
    @IBOutlet weak var collection: UICollectionView!
    
    var workOuts : [WorkOut] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collection.dataSource = self
        collection.delegate = self
        
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
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return workOuts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "workOutCollectionViewCell", for: indexPath) as! workOutCollectionViewCell
        
        return cell
    }
    
    
    

}
