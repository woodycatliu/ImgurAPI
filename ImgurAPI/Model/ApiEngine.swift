//
//  ApiEngine.swift
//  AlredPart2
//
//  Created by Woody on 2022/7/11.
//

import Foundation
import Combine


protocol CellInfo: ImageContainer {}

struct CameraListContainer {
    var type: CellType
    var info: CellInfo
}

enum CellType {
    case ad
    case camera
}

enum FetchError: Error {
    case badURL
}


protocol FetchEngine {
    func cameraListFetch()-> AnyPublisher<[CameraInfo], Error>
    func adFetch()-> AnyPublisher<ADDataModel, Error>
}

class EngineModel: FetchEngine {
    
    static let CameraListDomain: String = "https://com.alfred.camera/list"
    
    static let ADDomain: String = "https://com.alfred.camera/list"

    func cameraListFetch() -> AnyPublisher<[CameraInfo], Error> {
        
        guard let url = URL(string: Self.CameraListDomain) else {
            return Fail(error: FetchError.badURL).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: DeviceInfo.self, decoder: JSONDecoder())
            .map { $0.device }
            .eraseToAnyPublisher()
    }
    
    func adFetch() -> AnyPublisher<ADDataModel, Error> {
        guard let url = URL(string: Self.ADDomain) else {
            return Fail(error: FetchError.badURL).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: ADDataModel.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
}
