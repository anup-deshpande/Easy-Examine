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
        //name = preferences.string(forKey: "name")!
       
        if name != nil{
            nameLabel.text = name!
        }
        
    }
    
}
