//
//  HomePageViewController.swift
//  MasterDrive
//
//  Created by Prarthana Angadi on 4/17/17.
//  Copyright © 2017 Prarthana Angadi. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController {

    var user:User? = nil
    var authorizeUrl:String?

    var accessToken:String?
    
    @IBOutlet var imageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet var logoutWidthConstraints: NSLayoutConstraint!
    @IBOutlet var settingsWidthConstraint: NSLayoutConstraint!
    @IBOutlet var menuWidthConstraint: NSLayoutConstraint!
    @IBOutlet var menuView: UIView!
    var menuVisible:Bool = false
    
    @IBOutlet var userNameWidthConstraint: NSLayoutConstraint!
    @IBOutlet var userName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let text = self.user?.firstName {
            userName.text = "Hi,".appending(text)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
   
    @IBAction func menuButtonOnClick(_ sender: UIBarButtonItem) {
        if(menuVisible) {
            menuWidthConstraint.constant = 0
            settingsWidthConstraint.constant = 0
            logoutWidthConstraints.constant = 0
            imageViewWidthConstraint.constant = 0
            userNameWidthConstraint.constant = 0
        }else {
            menuWidthConstraint.constant = 188
            settingsWidthConstraint.constant = 172
            logoutWidthConstraints.constant = 172
            imageViewWidthConstraint.constant = 172
            userNameWidthConstraint.constant = 172
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })

        menuVisible = !menuVisible
    }
    
   
    @IBAction func logoutButtonOnClick(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "user")
        defaults.synchronize()
        performSegue(withIdentifier: "HomePageToLogin", sender: nil)
    }
    
    
    @IBAction func boxIconOnClick(_ sender: UIButton) {
        let url:NSURL = NSURL(string:"http://localhost:8080/box/authorize")!
        let session = URLSession.shared
        let request = NSMutableURLRequest(url : url as URL)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        let param = "email="+(self.user?.email)!
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
                    self.authorizeUrl = jsonDict.object(forKey: "url") as! String
                    self.performSegue(withIdentifier: "HomePageToBoxAuth", sender: nil)
                }
            }
        }
        task.resume()
    }
    
    @IBAction func dropBoxIconOnClick(_ sender: UIButton) {
        let url:NSURL = NSURL(string:"http://localhost:8080/user/getDropboxAccounts")!
        let session = URLSession.shared
        let request = NSMutableURLRequest(url : url as URL)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        let param = "email="+(self.user?.email)!
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
                    self.accessToken = jsonDict.object(forKey: "access_token") as! String
                    self.performSegue(withIdentifier: "HomePageToDropboxMain", sender: nil)
                }
            }else{
                let error = jsonDict.object(forKey: "error") as! NSDictionary
                let errorStatus = error.object(forKey: "status") as! NSDictionary
                let errorCode = errorStatus.object(forKey: "code") as! Int
                if(errorCode == 3500) {
                    DispatchQueue.main.async {
                        self.callDropboxAuthorize()
                    }
                } else {
                    DispatchQueue.main.async {
                        let errorMessage = "Maintainence Issue.Please try again after some time!"
                        self.displayAlertMessage(input: errorMessage)
                    }
                }
            }
        }
        task.resume()
    }

    func callDropboxAuthorize(){
        let url:NSURL = NSURL(string:"http://localhost:8080/dropbox/authorize")!
        let session = URLSession.shared
        let request = NSMutableURLRequest(url : url as URL)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        let param = "email="+(self.user?.email)!
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
                    self.authorizeUrl = jsonDict.object(forKey: "url") as! String
                    self.performSegue(withIdentifier: "HomePageToDropboxAuth", sender: nil)
                }
            }
        }
        task.resume()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "HomePageToDropboxAuth") {
            let viewController:DropboxViewController = segue.destination as! DropboxViewController
            viewController.authorizeUrl = self.authorizeUrl
            viewController.user = self.user
        }else if(segue.identifier == "HomePageToBoxAuth") {
            let viewController:BoxViewController = segue.destination as! BoxViewController
            viewController.authorizeUrl = self.authorizeUrl
        }else if(segue.identifier == "HomePageToDropboxMain"){
            let viewController:DropboxMainViewController = segue.destination as! DropboxMainViewController
            viewController.accessToken = self.accessToken

        }
    }
    
    func displayAlertMessage(input:String) {
        let alertController = UIAlertController(title: "Error", message:
            input, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
