//
//  favouriteViewController.swift
//  AllFit
//
//  Created by Jiecheng on 11/14/22.
//

import UIKit

class favouriteViewController: UIViewController{
    
    @IBOutlet weak var collection: UICollectionView!
    
    @IBOutlet weak var cleanAllBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collection.dataSource = self
        collection.delegate = self
        collection.collectionViewLayout = UICollectionViewFlowLayout()
    }
    
    
    @IBAction func cleanAllAction(_ sender: UIButton) {
        let cleanAllAlert = UIAlertController(title: "Clean All", message: "Do you want to clean all your favourite workouts?", preferredStyle: UIAlertController.Style.alert)

        cleanAllAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            for i in workOuts.indices{
                if(workOuts[i].favor){
                    workOuts[i].favor = false
                }
            }
            favourite = []
            self.collection.reloadData()
            
            //ToDo: clean the personal workouts in the Home Screen
            //workOuts.filter(){$0.userName != Auth.auth().currentUser?.email}
        }))

        cleanAllAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
              print("Handle Cancel Logic here")
        }))

        present(cleanAllAlert, animated: true, completion: nil)
    }
}

extension favouriteViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favourite.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "workOutCollectionViewCell", for: indexPath) as! workOutCollectionViewCell
        
        cell.setUp(with: favourite[indexPath.row])
        
        cell.addToFavouriteBtn.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        cell.addToFavouriteBtn.tintColor = cell.starImage.tintColor
        
        return cell
    }
}

extension favouriteViewController: UICollectionViewDelegateFlowLayout {
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

extension favouriteViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(favourite[indexPath.row].workOutName)
    }
}

