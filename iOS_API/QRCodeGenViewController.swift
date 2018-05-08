//
//  QRCodeGenViewController.swift
//  iOS_API
//
//  Created by MacBook Pro on 5/8/18.
//  Copyright © 2018 Computer. All rights reserved.
//

import UIKit

class QRCodeGenViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textFieldInput1: UITextField!
    @IBOutlet weak var textFieldInput2: UITextField!
    @IBOutlet weak var imageQRCode: UIImageView!
    
    @IBAction func buttonGen(_ sender: UIButton) {
        if (textFieldInput1.text != nil) && (textFieldInput2.text != nil) {
            let myInput = textFieldInput1.text! + "/" + textFieldInput2.text!
            let data = myInput.data(using: .ascii, allowLossyConversion: false)
            let filter = CIFilter(name: "CIQRCodeGenerator")
            filter?.setValue(data, forKey: "inputMessage")
            let img = UIImage(ciImage: (filter?.outputImage)!)
            imageQRCode.image = img
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldInput1.delegate = self
        textFieldInput2.delegate = self
        
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
        textFieldInput1.resignFirstResponder()
        textFieldInput2.resignFirstResponder()
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
