import UIKit

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
