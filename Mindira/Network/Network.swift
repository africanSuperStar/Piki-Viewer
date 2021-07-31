//
//  INetwork.swift
//  Mindira
//
//  Created by Cameron de Bruyn on 2021/07/31.
//

import Foundation
import Combine


@propertyWrapper
class Network <T: AnyModel> : ObservableObject
{
    var key: String
    
    init(key: String)
    {
        self.key = key
    }
    
    @Published
    private(set) var network: NetworkCenter<T>?
    
    var wrappedValue: NetworkCenter<T>?
    {
        get { network }
        
        set
        {
            network = NetworkCenter<T>(key: key)
        }
    }
}
