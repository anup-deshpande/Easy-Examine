//
//  HomeViewController.swift
//  scopingProject
//
//  Created by Anup Deshpande on 11/9/19.
//  Copyright © 2019 Anup Deshpande. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class HomeViewController: UIViewController {

    var name:String?
    var token:String?
    let preferences = UserDefaults.standard
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        // Get token from preferences
        token = preferences.string(forKey: "Token")!
        name = preferences.string(forKey: "Name")!
       
        if name != nil{
            nameLabel.text = name!
        }
        
    }
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
           logOut()
       }
       
       func logOut(){
           // Delete Token from User Defaults
           let prefereces = UserDefaults.standard
           
           DispatchQueue.main.async {
               prefereces.set(nil, forKey: "Token")
               prefereces.set(nil, forKey: "Name")
               prefereces.synchronize()
           }
           
           
           // Send back to login controller
           self.performSegue(withIdentifier: "goBackToLoginSegue", sender: nil)
       }
    
    @IBAction func showResultButtonTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "HomeToResultSegue", sender: nil)
    }
}
