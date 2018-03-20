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
    @IBOutlet weak var labelUserName: UILabel!
    
    //button
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
        if let name = defaultValues.string(forKey: "username"){
            //setting the name to label
            labelUserName.text = name
            self.labelUserName.isHidden = false
        }else{
            //switching to login screen
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "QRCodeViewController") as! QRCodeViewController
            self.navigationController?.pushViewController(loginViewController, animated: true)
            self.dismiss(animated: false, completion: nil)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
