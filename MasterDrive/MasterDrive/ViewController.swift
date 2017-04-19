//
//  ViewController.swift
//  MasterDrive
//
//  Created by Prarthana Angadi on 4/10/17.
//  Copyright © 2017 Prarthana Angadi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        let decoded  = defaults.object(forKey: "user") as? Data
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        if (decoded != nil) {
            let user = NSKeyedUnarchiver.unarchiveObject(with: decoded!) as! User
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "HomePageViewController") as! HomePageViewController
            nextViewController.user = user;
            self.present(nextViewController, animated:true, completion:nil)
        }else {
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "PageViewController") as! PageViewController
            self.present(nextViewController, animated:true, completion:nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

