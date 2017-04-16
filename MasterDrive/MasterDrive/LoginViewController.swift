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
                    self.performSegue(withIdentifier: "LoginToHomePage", sender: nil)
                    }
                }
                else {
                    DispatchQueue.main.async {
                        let errorMessage = "Invalid Email & Password combination entered"
                        self.displayAlertMessage(input: errorMessage)
                    }
                }
            }
            task.resume()
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func displayAlertMessage(input:String) {
        let alertController = UIAlertController(title: "Error", message:
            input, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
