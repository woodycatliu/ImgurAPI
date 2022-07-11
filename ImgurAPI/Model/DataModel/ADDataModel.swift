//
//  ADDataModel.swift
//  ImgurAPI
//
//  Created by Woody on 2022/7/11.
//

import Foundation

extension ADDataModel: CellInfo {}

struct ADDataModel: Codable {
    var vendor: String
    var image: String
}
