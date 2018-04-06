//
//  ProfileViewController.swift
//  iOS_API
//
//  Created by Computer on 3/6/18.
//  Copyright © 2018 Computer. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    //label again don't copy instead connect
   
    @IBOutlet weak var labelPhone: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var labelUserName: UILabel!
    
    //button Logout
    @IBAction func buttonLogout(_ sender: UIButton) {
        
        //removing values from default
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
        
        //switching to login screen
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "QRCodeViewController") as! QRCodeViewController
        self.navigationController?.pushViewController(loginViewController, animated: true)
        self.dismiss(animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaultValues = UserDefaults.standard
        if defaultValues.string(forKey: "username") == nil{
            //switching to login screen
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "main_view") as! ViewController
            self.navigationController?.pushViewController(loginViewController, animated: true)
            self.dismiss(animated: false, completion: nil)
        }
        else{
            let username = defaultValues.string(forKey: "username")
            let email = defaultValues.string(forKey: "useremail")
            let phone = defaultValues.string(forKey: "userphone")

            //setting the name to label
            labelUserName.text = username
            labelEmail.text = email
            labelPhone.text = phone
            self.labelUserName.isHidden = false
            self.labelEmail.isHidden = false
            self.labelPhone.isHidden = false
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
