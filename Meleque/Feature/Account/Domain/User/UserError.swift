//
//  UserError.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/8/25.
//

import Foundation

enum UserError : Error {
    case networkError
    case internalError
    case firebaseError(String)
    
    var localizedDescription: String {
        switch self {
        case .internalError:
            return "Invalid sign-in response data"
        case .networkError:
            return "Network error while fetching user data"
        case .firebaseError(let error):
            return "Firebase error: \(error)"
        }
    }
}
