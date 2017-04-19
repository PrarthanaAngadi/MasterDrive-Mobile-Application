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
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let url = URL(string: authorizeUrl!)!
        webView.loadRequest(URLRequest(url: url))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView)  {
        if(webView.request?.url?.path == "/1/oauth2/authorize_submit"){
            let doc = webView.stringByEvaluatingJavaScript(from: "document.getElementsByTagName(\"input\")[0].getAttribute(\"data-token\")")
            performSegue(withIdentifier: "DropboxAuthToDropboxMain", sender: nil)
        }
    }
    
    /*func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
            if (request.url?.path == "/1/oauth2/authorize_submit") {
                sleep(10)
                let doc = webView.stringByEvaluatingJavaScript(from: "document.documentElement.outerHTML")
                print(doc)
            }
        
        return true;
    }*/
}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


