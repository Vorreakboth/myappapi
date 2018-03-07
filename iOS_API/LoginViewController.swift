//
//  LoginViewController.swift
//  iOS_API
//
//  Created by Computer on 3/5/18.
//  Copyright © 2018 Computer. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController, UITextFieldDelegate {

    //let URL_USER_LOGIN = "https://myappapi.000webhostapp.com/v1/login.php"
    //let URL_USER_LOGIN = "http://localhost/LoginAPI/v1/login.php"
    let URL_USER_LOGIN = "http://192.168.1.173/LoginAPI/v1/login.php"
    
    let defaultValues = UserDefaults.standard
    
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var textFieldUserName: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    
    @IBAction func buttonLogin(_ sender: UIButton) {
        
        //getting the username and password
        let parameters: Parameters=[
            "username":textFieldUserName.text!,
            "password":textFieldPassword.text!
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
                        self.defaultValues.set(userId, forKey: "userid")
                        self.defaultValues.set(userName, forKey: "username")
                        self.defaultValues.set(userEmail, forKey: "useremail")
                        self.defaultValues.set(userPhone, forKey: "userphone")
                        
                        //switching the screen
                        let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
                        self.navigationController?.pushViewController(profileViewController, animated: true)
                        
                        self.dismiss(animated: false, completion: nil)
                    }else{
                        //error message in case of invalid credential
                        self.labelMessage.text = "Invalid username or password"
                    }
                }
                else {
                    self.labelMessage.text = "Error Connection"
                }
        }
    }
    @IBAction func buttonRegister(_ sender: UIButton) {
        //switching the screen
        let accountViewController = self.storyboard?.instantiateViewController(withIdentifier: "CreateViewController") as! ViewController
        self.navigationController?.pushViewController(accountViewController, animated: true)
        
        self.dismiss(animated: false, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if defaultValues.string(forKey: "username") != nil{
            let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            self.navigationController?.pushViewController(profileViewController, animated: true)
            
        }
        
        textFieldUserName.delegate = self
        textFieldPassword.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector (keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector (keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector (keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFieldUserName.resignFirstResponder()
        textFieldPassword.resignFirstResponder()
        return true
    }
    
    @objc func keyboardWillChange(notification: Notification){
        guard let keyboardRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{
            return
        }
        if notification.name == Notification.Name.UIKeyboardWillShow || notification.name == Notification.Name.UIKeyboardWillChangeFrame{
            view.frame.origin.y = -keyboardRect.height + 150
        }
        else {
            view.frame.origin.y = 0
        }
    }

}
