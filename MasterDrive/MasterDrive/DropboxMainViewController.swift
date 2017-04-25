//
//  DropboxMainViewController.swift
//  MasterDrive
//
//  Created by Prarthana Angadi on 4/19/17.
//  Copyright © 2017 Prarthana Angadi. All rights reserved.
//

import UIKit

class DropboxMainViewController: UIViewController , UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    var accessToken:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        print(accessToken!)
        tableView.delegate = self
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
