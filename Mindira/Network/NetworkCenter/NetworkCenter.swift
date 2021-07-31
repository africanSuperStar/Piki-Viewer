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
    
    internal let scheduler: DispatchQueue
    
    var session: URLSession = URLSession.shared
    
    // MARK: - Initializers
    
    init(key: String)
    {
        let configuration = URLSessionConfiguration.default
        
        configuration.waitsForConnectivity       = true
        configuration.timeoutIntervalForRequest  = 30
        configuration.timeoutIntervalForResource = 30
        
        self.scheduler = DispatchQueue(label: "network-scheduler",
                                       qos: .background,
                                       attributes: .concurrent,
                                       autoreleaseFrequency: .inherit,
                                       target: .global()
        )
        
        self._key = key
        
        super.init()
        
        self.session = URLSession(configuration: configuration,
                                  delegate: self,
                                  delegateQueue: nil
        )
    }
    
    // MARK: - Authentication Challenge
    
    public func urlSession(
        _ session:            URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler:    @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)
    {
        completionHandler(.performDefaultHandling, nil)
    }
}
