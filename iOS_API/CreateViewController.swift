//
//  ViewController.swift
//  iOS_API
//
//  Created by Computer on 3/5/18.
//  Copyright © 2018 Computer. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITextFieldDelegate {
    //let URL_USER_REGISTER = "https://myappapi.000webhostapp.com/v1/register.php"
    let URL_USER_REGISTER = "http://localhost/LoginAPI/v1/register.php"
    
    @IBOutlet weak var textFieldUsername: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldPhone: UITextField!
    @IBOutlet weak var labelMessage: UILabel!
    
    @IBAction func buttonRegister(_ sender: UIButton) {
        let parameters: Parameters=[
            "username":textFieldUsername.text!,
            "password":textFieldPassword.text!,
            "name":textFieldName.text!,
            "email":textFieldEmail.text!,
            "phone":textFieldPhone.text!
        ]
        Alamofire.request(URL_USER_REGISTER, method: .post, parameters: parameters).responseJSON
            {
                response in
                //printing response
                print(response)
                
                //getting the json value from the server
                if let result = response.result.value {
                    
                    //converting it as NSDictionary
                    let jsonData = result as! NSDictionary
                    
                    //displaying the message in label
                    self.labelMessage.text = jsonData.value(forKey: "message") as! String?
                }
        }
    }
    
    @IBAction func buttonLogin(_ sender: UIButton) {
        //switching to login screen
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(loginViewController, animated: true)
        self.dismiss(animated: false, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldName.delegate = self
        textFieldEmail.delegate = self
        textFieldUsername.delegate = self
        textFieldPhone.delegate = self
        textFieldPassword.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector (keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector (keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector (keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFieldName.resignFirstResponder()
        textFieldEmail.resignFirstResponder()
        textFieldPhone.resignFirstResponder()
        textFieldUsername.resignFirstResponder()
        textFieldPassword.resignFirstResponder()
        return true
    }
    
    @objc func keyboardWillChange(notification: Notification){
        guard let keyboardRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{
            return
        }
        if notification.name == Notification.Name.UIKeyboardWillShow || notification.name == Notification.Name.UIKeyboardWillChangeFrame{
            view.frame.origin.y = -keyboardRect.height+100
        }
        else {
            view.frame.origin.y = 0
        }
    }
    
}

