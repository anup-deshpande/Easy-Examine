//
//  evaluateViewController.swift
//  scopingProject
//
//  Created by Anup Deshpande on 11/9/19.
//  Copyright © 2019 Anup Deshpande. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class evaluateViewController: UIViewController {

    @IBOutlet weak var questionCollectionView: UICollectionView!
    @IBOutlet weak var teamNameLabel: UILabel!

    let preferences = UserDefaults.standard
    
    var teamName:String?
    var teamID: String?
    var token: String?
    var sum = 0
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
        
        
        questionCollectionView.delegate = self
        questionCollectionView.dataSource = self
        
        // Get token from preferences
        token = preferences.string(forKey: "Token")!
        teamNameLabel.text = self.teamName!
        
    }
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        print("Sum is \(sum)")
        self.updateTeamScore(for: teamID!, with: String(sum))
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "backToJudgeProfileSegue", sender: nil)
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

extension evaluateViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return questions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = questionCollectionView.dequeueReusableCell(withReuseIdentifier: "questionCell", for: indexPath) as! questionCollectionViewCell
        
        cell.questionLabel.text = "Question \(indexPath.row + 1). \n\(questions[indexPath.row])"
        
        cell.zeroGradeButton.tag = indexPath.row
        cell.oneGradeButton.tag = indexPath.row
        cell.twoGradeButton.tag = indexPath.row
        cell.threeGradeButton.tag = indexPath.row
        cell.fourGradeButton.tag = indexPath.row
        

        cell.zeroGradeButton.addTarget(self, action: #selector(self.ButtonTapped), for: .touchUpInside)
        cell.oneGradeButton.addTarget(self, action: #selector(self.ButtonTapped), for: .touchUpInside)
        cell.twoGradeButton.addTarget(self, action: #selector(self.ButtonTapped), for: .touchUpInside)
        cell.threeGradeButton.addTarget(self, action: #selector(self.ButtonTapped), for: .touchUpInside)
        cell.fourGradeButton.addTarget(self, action: #selector(self.ButtonTapped), for: .touchUpInside)
        
        
        return cell
    }
    
    @objc func ButtonTapped(sender: UIButton!){
        print("\(sender.tag) th row \(sender.titleLabel?.text) Button tapped")
        sum = sum + Int(sender.titleLabel!.text!)!
      
        print(sum)
    }
    
   
}

extension evaluateViewController: UICollectionViewDelegate{
 
    
}


