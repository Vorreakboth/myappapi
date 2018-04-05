//
//  ViewController.swift
//  QRCode
//
//  Created by Computer on 3/14/18.
//  Copyright © 2018 Computer. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation

class QRCodeViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate{
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
        
    }
    
    func found(code: String) {
        
        let alert = UIAlertController(title: "QR Code", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "Sign In", style: UIAlertActionStyle.default, handler: { action in
            
            let activityIndicator = UIActivityIndicatorView()
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            self.view.addSubview(activityIndicator)
            
            activityIndicator.startAnimating()
            
            let URL_USER_LOGIN = "https://myappapi.000webhostapp.com/v1/login.php"
            let defaultValues = UserDefaults.standard
            
            //Need to fix
            let login = code + "/"
            let loginArr = login.components(separatedBy: "/")
            let username = loginArr[0]
            let password = loginArr[1]
            print(login)

            //getting the username and password
            let parameters: Parameters=[
                "username":username,
                "password":password
            ]
            
            //making a post request
            Alamofire.request(URL_USER_LOGIN, method: .post, parameters: parameters).responseJSON
                {
                    response in
                    //printing response
                    print(response)
                    
                    //getting the json value from the server
                    if let result = response.result.value {
                        let jsonData = result as! NSDictionary
                        
                        //if there is no error
                        if(!(jsonData.value(forKey: "error") as! Bool)){
                            
                            //getting the user from response
                            let user = jsonData.value(forKey: "user") as! NSDictionary
                            
                            //getting user values
                            let userId = user.value(forKey: "id") as! Int
                            let userName = user.value(forKey: "username") as! String
                            let userEmail = user.value(forKey: "email") as! String
                            let userPhone = user.value(forKey: "phone") as! String
                            
                            //saving user values to defaults
                            defaultValues.set(userId, forKey: "userid")
                            defaultValues.set(userName, forKey: "username")
                            defaultValues.set(userEmail, forKey: "useremail")
                            defaultValues.set(userPhone, forKey: "userphone")
                            
                            self.captureSession.stopRunning()
                            self.dismiss(animated: true)
                            activityIndicator.stopAnimating()
                            
                            //switching the screen
                            let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
                            self.navigationController?.pushViewController(profileViewController, animated: true)
                            
                            self.dismiss(animated: false, completion: nil)
                        
                        }else{
                            //error message in case of invalid credential
                            self.captureSession.startRunning()
                            self.dismiss(animated: false)
                            activityIndicator.stopAnimating()
                        }
                    }
                    else {
                        self.captureSession.startRunning()
                        self.dismiss(animated: false)
                        activityIndicator.stopAnimating()
                    }
            }
            
        }))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}


