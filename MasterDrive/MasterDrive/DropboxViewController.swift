//
//  DropboxViewController.swift
//  MasterDrive
//
//  Created by Prarthana Angadi on 4/17/17.
//  Copyright © 2017 Prarthana Angadi. All rights reserved.
//

import UIKit

class DropboxViewController: UIViewController, UIWebViewDelegate{

    @IBOutlet var webView: UIWebView!
    var authorizeUrl:String?
    var accessToken:String?
    var user:User? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let url = URL(string: authorizeUrl!)!
        webView.loadRequest(URLRequest(url: url))
        self.navigationController?.setNavigationBarHidden(false, animated: false)

    }
    
     func webViewDidFinishLoad(_ webView: UIWebView)  {
        if(webView.request?.url?.path.hasPrefix("/dropbox/authenticate"))!{
            Thread.sleep(forTimeInterval: 5)
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
                        self.performSegue(withIdentifier: "DropboxAuthToDropboxMain", sender: nil)
                    }
                }else{
                    DispatchQueue.main.async {
                        let errorMessage = "Maintainence Issue.Please try again after some time!"
                        self.displayAlertMessage(input: errorMessage)
                    }
                }
            }
            task.resume()
        }
    }
    
    /*func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if(request.url?.path.hasPrefix("/dropbox/authenticate"))!{
            Thread.sleep(forTimeInterval: 5)
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
                        self.performSegue(withIdentifier: "DropboxAuthToDropboxMain", sender: nil)
                    }
                }else{
                    DispatchQueue.main.async {
                    let errorMessage = "Maintainence Issue.Please try again after some time!"
                    self.displayAlertMessage(input: errorMessage)
                    }
                }
            }
            task.resume()
        }
        return true;
    }*/
    
    func displayAlertMessage(input:String) {
        let alertController = UIAlertController(title: "Error", message:
            input, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }



    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "DropboxAuthToDropboxMain"){
            let viewController:DropboxMainViewController = segue.destination as! DropboxMainViewController
            viewController.accessToken = self.accessToken
        }
    }

}

