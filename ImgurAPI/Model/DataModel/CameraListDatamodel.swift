//
//  CameraListDatamodel.swift
//  ImgurAPI
//
//  Created by Woody on 2022/7/11.
//

import Foundation

extension CameraInfo: CellInfo {
    var link: String {
        get {
            return snapshot
        }
        set {
            snapshot = newValue
        }
    }
}

struct DeviceInfo: Codable {
    var device: [CameraInfo]
}

struct CameraInfo: Codable {
    var name: String
    var snapshot: String
}
