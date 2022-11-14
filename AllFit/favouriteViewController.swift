//
//  favouriteViewController.swift
//  AllFit
//
//  Created by Jiecheng on 11/14/22.
//

import UIKit

class favouriteViewController: UIViewController{
    
    @IBOutlet weak var collection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collection.dataSource = self
        collection.delegate = self
        collection.collectionViewLayout = UICollectionViewFlowLayout()
        
        print(favourite.count)
        
    }
    
}

extension favouriteViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(favourite.count)
        return favourite.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "workOutCollectionViewCell", for: indexPath) as! workOutCollectionViewCell
        
        cell.setUp(with: favourite[indexPath.row])
        
        print(favourite[indexPath.row].workOutName)
        
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

