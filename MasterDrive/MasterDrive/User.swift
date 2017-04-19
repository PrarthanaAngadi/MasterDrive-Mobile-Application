//
//  User.swift
//  MasterDrive
//
//  Created by Prarthana Angadi on 4/17/17.
//  Copyright © 2017 Prarthana Angadi. All rights reserved.
//

import UIKit

class User: NSObject,NSCoding {

    var email:String
    var userId:Int
    var firstName:String
    var lastName:String
    
    init( email:String, userId:Int, firstName:String, lastName:String) {
        self.email = email
        self.userId = userId
        self.firstName = firstName
        self.lastName = lastName
    }
    required convenience init(coder aDecoder: NSCoder) {
        let userId = aDecoder.decodeInteger(forKey: "userId")
        let email = aDecoder.decodeObject(forKey: "email") as! String
        let firstName = aDecoder.decodeObject(forKey: "firstName") as! String
        let lastName = aDecoder.decodeObject(forKey: "lastName") as! String
        self.init(email: email, userId: userId, firstName: firstName, lastName: lastName)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(userId, forKey: "userId")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(firstName, forKey: "firstName")
        aCoder.encode(lastName, forKey: "lastName")

    }
}
