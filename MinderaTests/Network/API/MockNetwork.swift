//
//  MockNetwork.swift
//  MinderaTests
//
//  Created by Cameron de Bruyn on 2021/08/01.
//

import Foundation
import Combine

@testable import Mindera


@propertyWrapper
class MockNetwork <T: AnyModel> : ObservableObject
{
    var key: String
    
    init(key: String)
    {
        self.key     = key
        self.network = MockNetworkCenter<T>(key: key)
    }
    
    @Published
    private(set) var network: MockNetworkCenter<T>
    
    var wrappedValue: MockNetworkCenter<T>
    {
        get { network }
    }
}
