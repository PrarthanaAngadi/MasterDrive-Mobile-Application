//
//  LoginViewController.swift
//  MasterDrive
//
//  Created by Prarthana Angadi on 4/16/17.
//  Copyright © 2017 Prarthana Angadi. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    
    var user:User? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signInButtonOnClick(_ sender: UIButton) {
        if((email.text?.characters.count)! == 0 || (password.text?.characters.count)! == 0) {
            let errorMessage = "Please enter valid information to proceed"
            displayAlertMessage(input: errorMessage)
        }else {
            let url:NSURL = NSURL(string:"http://localhost:8080/user/authenticate")!
            let session = URLSession.shared
            let request = NSMutableURLRequest(url : url as URL)
            request.httpMethod = "POST"
            request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
            let param = "email="+self.email.text!+"&password="+self.password.text!
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
                    DispatchQueue.main.async {
                        let jsonUser = jsonDict.object(forKey: "user") as! NSDictionary
                        self.user = User(email: jsonUser.object(forKey: "email") as! String,
                                              userId: jsonUser.object(forKey: "user_id") as! Int,
                                              firstName: jsonUser.object(forKey: "first_name") as! String,
                                              lastName:jsonUser.object(forKey: "last_name") as! String)
                        let userDefaults = UserDefaults.standard
                        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: self.user!)
                        userDefaults.set(encodedData, forKey: "user")
                        userDefaults.synchronize()
                        self.performSegue(withIdentifier: "LoginToHomePage", sender: nil)
                    }
                }else{
                    let error = jsonDict.object(forKey: "error") as! NSDictionary
                    let errorStatus = error.object(forKey: "status") as! NSDictionary
                    let errorCode = errorStatus.object(forKey: "code") as! Int
                    if(errorCode == 3400) {
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "LoginToVerification", sender: nil)
                        }
                    } else {
                        DispatchQueue.main.async {
                        let errorMessage = "Invalid Email & Password combination entered"
                        self.displayAlertMessage(input: errorMessage)
                        }
                    }
                }
            }
            task.resume()
        }
    }
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if(segue.identifier == "LoginToHomePage") {
                let navController:UINavigationController = segue.destination as! UINavigationController
                let viewController:HomePageViewController = navController.topViewController as! HomePageViewController
             //   let viewController:HomePageViewController = segue.destination as! HomePageViewController
                viewController.user = self.user
            }else if(segue.identifier == "LoginToVerification") {
                    let viewController:VerificationViewController = segue.destination as! VerificationViewController
                    viewController.email = email.text
            }
    }
    

    func displayAlertMessage(input:String) {
        let alertController = UIAlertController(title: "Error", message:
            input, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
