//
//  MockNetworkCenter.swift
//  MinderaTests
//
//  Created by Cameron de Bruyn on 2021/08/01.
//

import Foundation
import Combine

@testable import Mindera

class MockNetworkCenter <T: AnyModel> : NetworkCenter<T>
{
    typealias _T = T
    
    let mockSession: Session
    
    // MARK: - Initializers
    
    override init(key: String)
    {
        let configuration  = URLSessionConfiguration.default
        let backingSession = URLSession(configuration: configuration)
        
        configuration.httpAdditionalHeaders = ["testSessionHeader": "testSessionHeaderValue"]
    
        self.mockSession = Session(cassetteName: "mock-session", backingSession: backingSession)
        
        super.init(key: key)
            
        // TODO: SSL Pinning
    }
}
