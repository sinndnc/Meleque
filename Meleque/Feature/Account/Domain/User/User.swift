//
//  User.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/8/25.
//

import Foundation
import FirebaseFirestore

struct User : Codable,Hashable {
    var id: String?
    let email: String
    var phone: String
    var lastName: String
    var firstName: String
    
}

