//
//  DeviceInfoDTO.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/7/25.
//
import Foundation
import UIKit

struct DeviceInfoDTO: Codable {
    let deviceId: String
    let deviceType: String
    let osVersion: String
    let appVersion: String
    let pushToken: String?
    
    enum CodingKeys: String, CodingKey {
        case deviceId = "device_id"
        case deviceType = "device_type"
        case osVersion = "os_version"
        case appVersion = "app_version"
        case pushToken = "push_token"
    }
    
    static var current: DeviceInfoDTO {
        return DeviceInfoDTO(
            deviceId: UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString,
            deviceType: UIDevice.current.model,
            osVersion: UIDevice.current.systemVersion,
            appVersion: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0",
            pushToken: nil // Will be set when push notification token is available
        )
    }
}
