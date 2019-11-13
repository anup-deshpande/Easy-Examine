//
//  QRCodeViewController.swift
//  scopingProject
//
//  Created by Anup Deshpande on 11/9/19.
//  Copyright © 2019 Anup Deshpande. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire
import SwiftyJSON

class QRCodeViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate

{
    
    //MARK: API URL Declarations
    var getJudgeProfileAPI = "http://ec2-54-86-229-201.compute-1.amazonaws.com/api/scoping/getJudgeProfile"
    
    @IBOutlet weak var square: UIImageView!
    var video = AVCaptureVideoPreviewLayer()
    var name:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                    
                    getJudgeInformation(for: object.stringValue!)
                    
                }
            }
        }
    }
    
    
    func getJudgeInformation(for token:String){
        let headers: HTTPHeaders = [
            "token": token
        ]
        
        AF.request(getJudgeProfileAPI,
                   method: .get,
                   encoding: JSONEncoding.default,
                   headers: headers)
            .responseJSON { response in
                
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    
                    // Check if status code is 200
                    if json["status"].stringValue == "200"{
                        
                        self.name = "\(json["firstName"]) \(json["lastName"])"
                        
                        // Store token in UserDefaults
                        let preferences = UserDefaults.standard
                        preferences.set(token, forKey: "Token")
                        preferences.set(self.name, forKey: "Name")
                        
                        // Go to home controller
                        self.performSegue(withIdentifier: "QRCodeToHomeSegue", sender: nil)
                        
                        
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
        if segue.identifier ==  "QRCodeToHomeSegue"{
            guard let name = name else {return}
            
            let destination = segue.destination as! HomeViewController
            destination.name = name
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
