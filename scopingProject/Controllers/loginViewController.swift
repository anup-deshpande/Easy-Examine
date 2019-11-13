//
//  ViewController.swift
//  scopingProject
//
//  Created by Anup Deshpande on 11/9/19.
//  Copyright © 2019 Anup Deshpande. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class loginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //MARK: API URL Declarations
    var loginAPI = "http://ec2-54-86-229-201.compute-1.amazonaws.com/api/user/login"
    
    let preferences = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//           // Check for the token
//           if preferences.string(forKey: "Token") != nil {
//               self.performSegue(withIdentifier: "loginToHomeSegue", sender: self)
//           }
//    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
              if isEverythingFilled() == true{
                  login(Email: emailTextField.text!, Password: passwordTextField.text!)
              }
       }

    @IBAction func scanQRCodeTapped(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "loginToQRCodeSegue", sender: nil)
        
    }
    
    
    func login(Email email:String, Password password:String){
            
            // MARK: LOGIN API REQUEST

            let parameters: [String:String] = [
                "email":email,
                "password":password
            ]
            
            
            AF.request(loginAPI,
                       method: .post,
                       parameters: parameters, encoding: JSONEncoding.default)
                .responseJSON { response in
                    switch response.result{
                    case .success(let value):
                      
                        
                        // Get token value from response
                        let json = JSON(value)
                        print(json)
                        if json["status"].stringValue == "200"{
                        let token = json["token"].stringValue
                        let name = json["name"].stringValue
                      
                        // Store token in UserDefaults
                        let preferences = UserDefaults.standard
                        preferences.set(token, forKey: "Token")
                            preferences.set(name, forKey: "Name")
                            
                        // Start profile segue
                        self.performSegue(withIdentifier: "loginToHomeSegue", sender: nil)
                        }
                        else if json["status"].stringValue == "400"{
                           print("Login or password")
                        }
                        
                        break
                        
                    case .failure(let error):
                        print(error)
                        break
                    }
                    
            }
            
        }
        
        
        func isEverythingFilled() -> Bool{
               
               var flag = true
               
               if emailTextField.text == "" {
                   print("email is nil")
                   flag = false
               }
                if passwordTextField.text == ""{
                   print("password is nil")
                   flag = false
               }
               
               return flag;
        }
    }

    extension loginViewController : UITextFieldDelegate{
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
        }
    }



