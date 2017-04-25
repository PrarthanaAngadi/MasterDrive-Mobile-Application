//
//  BoxViewController.swift
//  MasterDrive
//
//  Created by Prarthana Angadi on 4/23/17.
//  Copyright © 2017 Prarthana Angadi. All rights reserved.
//

import UIKit

class BoxViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet var webView: UIWebView!
    var authorizeUrl:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let url = URL(string: authorizeUrl!)!
        webView.loadRequest(URLRequest(url: url))
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
