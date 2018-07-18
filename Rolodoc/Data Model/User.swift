//
//  User.swift
//  Rolodoc
//
//  Created by Katherine Choi on 7/17/18.
//  Copyright © 2018 Katherine Choi. All rights reserved.
//

import Foundation

class User {
    
    var token = "" {
        didSet {
            UserDefaults.standard.set(token, forKey: "token")
        }
    }
    
    
    private init() {}
    static let current = User()
    
}
