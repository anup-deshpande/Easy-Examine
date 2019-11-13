//
//  ExamineViewController.swift
//  scopingProject
//
//  Created by Anup Deshpande on 11/13/19.
//  Copyright © 2019 Anup Deshpande. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import KRProgressHUD

class ExamineViewController: UIViewController {

    
    @IBOutlet weak var teamNameLabel: UILabel!
    
    let preferences = UserDefaults.standard
    
    @IBOutlet weak var questionNumberLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var gradeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var nextButton: UIButton!
    
    var teamName:String?
    var teamID: String?
    var token: String?
    var sum = 0
    var counter = 0
    var questions:[String] = [
        "Poster content is of professional quality and indicates a mastery of the project subject matter.",
        "The presentation is organized, engaging, and includes a thorough description of the design and the implementation of the design.",
        "All team members are suitably attired, are polite, demonstrate full knowledge of material, and can answer all relevant questions.",
        "The work product(model, prototype, documentation set or computer simulation) is of professional quality in all respects.",
        "The team implemented novel approaches and/or solutions in the development of the project.",
        "The project has the potential to enhance the reputation of the Innovative Computing Project and/or CCI/DSI.",
        "The team successfully explained the scope and the result of their project in no more than 5 minutes."
    ]
    
    
    //MARK: API URL Declarations
    var sendScoreForTeamAPI = "http://ec2-54-86-229-201.compute-1.amazonaws.com:80/api/scoping/sendScoreForTeam"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNextQuestion()
        
        // Get token from preferences
        token = preferences.string(forKey: "Token")!
        teamNameLabel.text = "Team: \(self.teamName!)"
        
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "ExamineToHomeSegue", sender: nil)
    }

    @IBAction func nextButtonTapped(_ sender: UIButton) {
        saveGrade(self.gradeSegmentedControl.selectedSegmentIndex)
        loadNextQuestion()
    }
    
    func saveGrade(_ grade: Int){
        sum = sum + grade
    }
    
    func loadNextQuestion(){
        
        if self.nextButton.titleLabel?.text == "Submit"{
            self.updateTeamScore(for: teamID!, with: String(sum))
            return
        }
        
        questionLabel.text = "\(questions[counter])"
        questionNumberLabel.text = "Question \(counter + 1)"
        
        gradeSegmentedControl.selectedSegmentIndex = 0
        
        counter += 1
        if counter >= questions.count{
            self.nextButton.setTitle("Submit", for: .normal)
        }
    }
    
    func updateTeamScore(for teamId:String, with score:String){
          let headers: HTTPHeaders = [
              "token": self.token!
          ]
          
          let parameters: Parameters = [
              "teamId" : teamId,
              "score" : score
          ]
          
          AF.request(sendScoreForTeamAPI,
                     method: .post,
                     parameters: parameters, encoding: JSONEncoding.default,
                     headers: headers
                     )
              .responseJSON { response in
                  
                  switch response.result{
                  case .success(let value):
                      let json = JSON(value)
                      
                      // Check if status code is 200
                      if json["status"].stringValue == "200"{
                         print(json)
                         KRProgressHUD.showSuccess(withMessage: "Response recorded successfully")
                         self.performSegue(withIdentifier: "ExamineToHomeSegue", sender: nil)
                      }
                      else if json["status"].stringValue == "401"{
                          
                          print(json["message"].stringValue)
                      }
                      else if json["status"].stringValue == "400"{
                          
                          print(json["message"].stringValue)
                      }
                          
                      else{
                          print("Error Occured")
                      }
                      break
                      
                  case .failure(let error):
                      print(error)
                      break
                  }
                  
          }
      }
    
    
    

}
