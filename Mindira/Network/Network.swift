//
//  INetwork.swift
//  Mindira
//
//  Created by Cameron de Bruyn on 2021/07/31.
//

import Foundation


@propertyWrapper
struct Network <T: AnyModel>
{
    var key: String
    
    var wrappedValue: NetworkCenter<T>?
    {
        get { NetworkCenter<T>(key: key) }
    }
}
