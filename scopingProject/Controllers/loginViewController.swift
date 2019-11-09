//
//  ViewController.swift
//  scopingProject
//
//  Created by Anup Deshpande on 11/9/19.
//  Copyright © 2019 Anup Deshpande. All rights reserved.
//

import UIKit

class loginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func scanQRCodeTapped(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "loginToQRCodeSegue", sender: nil)
        
    }
    
}

