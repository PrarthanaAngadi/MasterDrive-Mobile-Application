//
//  VerificationViewController.swift
//  MasterDrive
//
//  Created by Prarthana Angadi on 4/13/17.
//  Copyright © 2017 Prarthana Angadi. All rights reserved.
//

import UIKit

class VerificationViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var emailVerificationCode: UITextField!
    
    @IBOutlet var mobileVerification: UITextField!
    
    var email:String? = nil
    
    
    override func viewDidLoad() {
        
        emailVerificationCode.delegate = self
        mobileVerification.delegate = self
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func requestCodeButtonOnClick(_ sender: UIButton) {
    }

    func textFieldShouldReturn(_ textField: UITextField) {
        
        if(textField.tag == 1){
            if(textField.text?.characters.count == 6) {
                requestUserVerification(verificationCode: emailVerificationCode.text!)
            }else {
                let errorMessage = "Please enter a valid Verification Code"
                displayAlertMessage(input: errorMessage)
            }
        }else {
            
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

    func requestUserVerification(verificationCode:String) {
        let url:NSURL = NSURL(string:"http://localhost:8080/user/verify")!
        let session = URLSession.shared
        let request = NSMutableURLRequest(url : url as URL)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        let param = "email="+self.email!+"&verificationCode="+verificationCode
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
                    self.performSegue(withIdentifier: "VerificationToLogin", sender: nil)
                }
            }
            else {
                let error = jsonDict.object(forKey: "error") as! NSDictionary
                let errorStatus = error.object(forKey: "status") as! NSDictionary
                let errorCode = errorStatus.object(forKey: "code") as! Int
                if(errorCode == 3100) {
                    DispatchQueue.main.async {
                        let errorMessage = "Please enter a valid Verification Code"
                        self.displayAlertMessage(input: errorMessage)
                    }
                }
                else {
                     DispatchQueue.main.async {
                        let errorMessage = "Please try again later."
                        self.displayAlertMessage(input: errorMessage)
                    }
                }
            }
        }
        task.resume()
    }
    func displayAlertMessage(input:String) {
        let alertController = UIAlertController(title: "Error", message:
            input, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
