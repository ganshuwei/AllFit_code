//
//  TabBarController.swift
//  Lab4
//
//  Created by user on 10/26/22.
//

import Foundation
import UIKit

class MyTabBarController: UITabBarController, UITabBarControllerDelegate {

//    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//         let tabBarIndex = tabBarController.selectedIndex
//         if tabBarIndex == 0 {
//             //do your stuff
//         }
//    }
    // this is called *when* the tab item is selected (tapped)
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        // safely unwrap optionals
        guard let theItems = self.tabBar.items,
              let idx = theItems.firstIndex(of: item),
              let controllers = self.viewControllers
        else { return }
        
        print("controller is ",controllers[idx])
        if let vc = controllers[idx] as? homeViewController {
            vc.viewDidLoad()
            print("home")
        }
        if let vc = controllers[idx] as? profileViewController {
            vc.viewDidLoad()
            print("profile")
        }
        if let vc = controllers[idx] as? CreateExerciseView {
            vc.viewDidLoad()
            print("exercise view")
        }
        if let vc = controllers[idx] as? CreateWorkoutView{
            vc.viewDidLoad()
            vc.exerciseTable.reloadData()
            print("workout page")
        }
    }
//    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//
//            if let firstVC = viewController as? ViewController {
//                firstVC.viewDidLoad()
//            }
//            else if let secondVC = viewController as? FavoritesController {
//                secondVC.viewDidLoad()
//            }
//            if viewController is ViewController {
//                print("First tab")
//            } else if viewController is FavoritesController {
//                print("Second tab")
//            }
//    }
    
    override func viewDidLoad() {
        print("in here 1")
         super.viewDidLoad()
         self.tabBarController?.delegate = self
    }
}

