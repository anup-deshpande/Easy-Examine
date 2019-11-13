//
//  resultsViewController.swift
//  scopingProject
//
//  Created by Anup Deshpande on 11/13/19.
//  Copyright © 2019 Anup Deshpande. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class resultsViewController: UIViewController {

    @IBOutlet weak var resultTableView: UITableView!
    
    let refreshControl = UIRefreshControl()
    let preferences = UserDefaults.standard
    var token: String?
    var resultList = [result]()
    
    
    
    //MARK: API URL Declarations
    var getTeamScoresAPI = "http://ec2-54-86-229-201.compute-1.amazonaws.com:80/api/scoping/getTeamScore"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        resultTableView.delegate = self
        resultTableView.dataSource = self
        
        // Get token from preferences
        token = preferences.string(forKey: "Token")!
        
       // Get result from the database
        getTeamScores()
        
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            resultTableView.refreshControl = refreshControl
        } else {
            resultTableView.addSubview(refreshControl)
        }
        
        
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshTeamScores(_:)), for: .valueChanged)
    }
    
    
    @objc private func refreshTeamScores(_ sender: Any) {
        // Fetch team scores
        getTeamScores()
    }
    
    func getTeamScores(){
        let headers: HTTPHeaders = [
            "token": self.token!
        ]
        
        AF.request(getTeamScoresAPI,
                   method: .get,
                   encoding: JSONEncoding.default,
                   headers: headers
                   )
            .responseJSON { response in
                
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    
                    // Check if status code is 200
                    if json["status"].stringValue == "200"{
                        
                        self.resultList.removeAll()
                        
                        for i in 0..<json["team"].count{
                            self.resultList.append(result(json["team"][i]["name"].stringValue, json["team"][i]["finalScore"].stringValue))
                        }
                        self.refreshControl.endRefreshing()
                        self.resultTableView.reloadData()
                        
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

extension resultsViewController: UITableViewDelegate{
    
}


extension resultsViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.resultTableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath) as! resultTableViewCell
        cell.groupNameLabel.text = resultList[indexPath.row].groupName!
        cell.groupScoreLabel.text = resultList[indexPath.row].score!
        return cell
    }
    
    
}
