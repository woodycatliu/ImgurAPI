//
//  ADDataModel.swift
//  ImgurAPI
//
//  Created by Woody on 2022/7/11.
//

import Foundation

extension ADDataModel: CellInfo {
    var link: String {
        get {
            return image
        }
        set {
            image = newValue
        }
    }
}

struct ADDataModel: Codable {
    var vendor: String
    var image: String
}
