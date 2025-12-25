//
//  UserCreationError.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/8/25.
//


enum UserCreationError: Error {
    case invalidDTO
    case networkError
    case parseError
    
    var localizedDescription: String {
        switch self {
        case .invalidDTO:
            return "Invalid sign-in response data"
        case .networkError:
            return "Network error while fetching user data"
        case .parseError:
            return "Error parsing user data"
        }
    }
}
