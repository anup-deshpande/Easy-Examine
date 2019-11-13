//
//  teamQRCodeViewController.swift
//  scopingProject
//
//  Created by Anup Deshpande on 11/9/19.
//  Copyright © 2019 Anup Deshpande. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AVFoundation

class teamQRCodeViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate {

   
    //MARK: API URL Declarations
    var getTeamInformationAPI = "http://ec2-54-86-229-201.compute-1.amazonaws.com/api/scoping/getTeamById"
    
    @IBOutlet weak var square: UIImageView!
    
    let preferences = UserDefaults.standard
    var video = AVCaptureVideoPreviewLayer()
    var teamName:String?
    var teamID:String?
    var token:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get token from preferences
        token = preferences.string(forKey: "Token")!
            
        
        let session = AVCaptureSession()
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            print("Failed to get the camera device")
            return
            
        }
        do{
            let input = try AVCaptureDeviceInput(device: captureDevice)
            session.addInput(input)
        }
        catch{
            print("ERROR")
        }
        
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = view.frame
        view.layer.addSublayer(video)
        
        self.view.bringSubviewToFront(square)
        
        session.startRunning()
        

    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
         if metadataObjects != nil && metadataObjects.count != 0
         {
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject
            {
                if object.type == AVMetadataObject.ObjectType.qr
                {
                    
                    getTeamInformation(for: object.stringValue!)
                    teamID = object.stringValue!
                }
            }
        }
    }
    
    
    func getTeamInformation(for teamId:String){
        let headers: HTTPHeaders = [
            "token": self.token!
        ]
        
        let parameters: Parameters = [
            "teamId" : teamId
        ]
        
        AF.request(getTeamInformationAPI,
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
                        
                        self.teamName = json["name"].stringValue
                        
                        
                        // Go to home controller
                        //self.performSegue(withIdentifier: "teamQRCodeToJudgeSegue", sender: nil)
                        self.performSegue(withIdentifier: "teamQRCodeToExaminerSegue", sender: nil)
                        
                        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier ==  "teamQRCodeToJudgeSegue"{
            guard let teamName = teamName else {return}
            
            let destination = segue.destination as! evaluateViewController
            destination.teamName = teamName
            destination.teamID = teamID
            
        }
        
        if segue.identifier == "teamQRCodeToExaminerSegue"{
            guard let teamName = teamName else {return}
            
            let destination = segue.destination as! ExamineViewController
            destination.teamName = teamName
            destination.teamID = teamID
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }



}
