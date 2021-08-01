//
//  NetworkCenter.swift
//  Mindira
//
//  Created by Cameron de Bruyn on 2021/07/31.
//

import Foundation
import Combine


class NetworkCenter <T: AnyModel> : NSObject, INetworkCenter, URLSessionDelegate
{
    typealias _T = T
    
    var _key: String
    
    // MARK: - Stored Properties
    
    internal let secureStore: SecureStore?
    internal let scheduler:   DispatchQueue
    
    var session: URLSession = URLSession.shared
    
    // MARK: - Initializers
    
    init(key: String)
    {
        let configuration = URLSessionConfiguration.default
        
        configuration.waitsForConnectivity       = true
        configuration.timeoutIntervalForRequest  = 15
        configuration.timeoutIntervalForResource = 15
        
        self.scheduler = DispatchQueue(label: "network-scheduler",
                                       qos: .background,
                                       attributes: .concurrent,
                                       autoreleaseFrequency: .inherit,
                                       target: .global()
        )
        
        self.secureStore = SecureStore(secureStoreQueryable: GenericPasswordQueryable(service: "MinderaService"))
        
        self._key = key

        super.init()
        
        self.scheme      = "https"
        self.host        = "api.flickr.com"
        
        // TODO: Store Token Securely
        self.accessToken = "f9cc014fa76b098f9e82f1c288379ea1"
                
        self.session = URLSession(configuration: configuration,
                                  delegate: self,
                                  delegateQueue: nil
        )
        
        // TODO: SSL Pinning
    }
}
