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
    }
    
    
    @IBAction func dropBoxIconOnClick(_ sender: UIButton) {
        let url:NSURL = NSURL(string:"http://localhost:8080/dropbox/authorize")!
        let session = URLSession.shared
        let request = NSMutableURLRequest(url : url as URL)
        request.httpMethod = "GET"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
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
        }
    }
}
