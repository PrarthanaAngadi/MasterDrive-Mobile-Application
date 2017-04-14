//
//  RegistrationViewController.swift
//  MasterDrive
//
//  Created by Prarthana Angadi on 4/11/17.
//  Copyright © 2017 Prarthana Angadi. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet var lastName: UITextField!
    @IBOutlet var firstName: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var confirmPassword: UITextField!
    @IBOutlet var password: UITextField!
    
    var registrationSuccess = false
    var userExists = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lastName.delegate = self
        firstName.delegate = self
        email.delegate = self
        password.delegate = self
        confirmPassword.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
  
        switch textField.tag {
        case 1:
            let allowedChars = NSCharacterSet.letters
            let input = textField.text?.rangeOfCharacter(from: allowedChars)
            guard input != nil else {
                let errorMessage = "Invalid characters entered for First Name"
                displayAlertMessage(input: errorMessage)
                textField.text = ""
                return
            }
            
        case 2: let allowedChars = NSCharacterSet.letters
        let input = textField.text?.rangeOfCharacter(from: allowedChars)
        guard input != nil else {
            let errorMessage = "Invalid characters entered for Last Name"
            displayAlertMessage(input: errorMessage)
            textField.text = ""
            return
            }
            
        case 3:
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let emailTest = NSPredicate(format:"Self Matches %@", emailRegEx)
            guard emailTest.evaluate(with: textField.text) else {
                let errorMessage = "Invalid Email Address entered"
                displayAlertMessage(input: errorMessage)
                textField.text = ""
                return
            }
            
        case 4:
            guard let passwordLength = textField.text?.characters.count, passwordLength >= 6 else {
                let errorMessage = "Password be atleast 6 characters long"
                displayAlertMessage(input: errorMessage)
                textField.text = ""
                return
            }
            let passwordRegex = "(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{6,15}"
            let passwordTest = NSPredicate(format:"Self Matches %@", passwordRegex)
            guard passwordTest.evaluate(with: textField.text) else {
                let errorMessage = "Password should contain atleast one uppercase letter, one lowercase letter & one digit"
                textField.text = ""
                displayAlertMessage(input: errorMessage)
                return
            }

        case 5:
            guard textField.text == password.text else {
                let errorMessage = "Both password text fields donot match"
                textField.text = ""
                displayAlertMessage(input: errorMessage)
                return
            }
        default :
            break
        }
    }
    
   
    @IBAction func registerButtonOnClick(_ sender: UIButton) {
        
        if((firstName.text?.characters.count)! == 0 || (lastName.text?.characters.count)! == 0 ||
            (email.text?.characters.count)! == 0 || (confirmPassword.text?.characters.count)! == 0 ||
            (password.text?.characters.count)! == 0) {
            let errorMessage = "Please enter valid information to proceed"
            displayAlertMessage(input: errorMessage)
        } else {
            requestNewUserRegistration()
            if(registrationSuccess) {
                performSegue(withIdentifier: "RegisterToVerification", sender: nil)
            }
            else if (userExists) {
                let errorMessage = "User already Exists! Do you want to request for a new password?"
                displayPromptMessage(input: errorMessage)
            }
            
        }
    }

    func requestNewUserRegistration() {
        let url:NSURL = NSURL(string:"http://localhost:8080/user/create")!
        let session = URLSession.shared
        let request = NSMutableURLRequest(url : url as URL)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        let param = "first_name="+firstName.text!+"&last_name="+lastName.text!+"&email="+email.text!+"&password="+password.text!
        request.httpBody = param.data(using: String.Encoding.utf8)
        let task = session.dataTask(with: request as URLRequest) {
            (data, response, error) in
            
            guard let receivedData:Data = data, let _:URLResponse = response, error == nil else {
                print(error)
                return
            }
            let jsonDict : NSDictionary = try! JSONSerialization.jsonObject(with: receivedData as Data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
            let status = jsonDict.object(forKey: "status") as! NSDictionary
            let code = status.object(forKey: "code") as! Int
            if(code == 2000) {
                self.registrationSuccess = true
            }
            else {
                let error = jsonDict.object(forKey: "error") as! NSDictionary
                let errorStatus = error.object(forKey: "status") as! NSDictionary
                let errorCode = errorStatus.object(forKey: "code") as! Int
                if(errorCode == 3000) {
                    self.userExists = true
                }
            }
        }
        task.resume()
    }
    
    func displayPromptMessage(input:String) {
        let alertController = UIAlertController(title: "Alert", message:
            input, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default,handler: {action in self.gotoResetPassword()}))
        alertController.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func gotoResetPassword() {
        performSegue(withIdentifier: "RegisterToResetPassword", sender: nil)
    }
    
    func displayAlertMessage(input:String) {
        let alertController = UIAlertController(title: "Error", message:
            input, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
    }
}
