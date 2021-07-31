//
//  INetwork+NetworkCenter.swift
//  Mindira
//
//  Created by Cameron de Bruyn on 2021/07/31.
//

import Foundation
import Combine


extension NetworkCenter
{
    var headers: [String : String]
    {
        if let accessToken = CacheManager.accessToken.single
        {
            return [
                "Authorization": "Bearer \(accessToken)"
            ]
        }
        else
        {
            print("CRITICAL: Failed to get acccess token from Cache Manager")
            
            return [:]
        }
    }
}

extension NetworkCenter
{
    fileprivate func callee <T> (
        path:    String,
        params:  [String: Any]? = nil,
        retries: Int = 0,
        _ handler: @escaping (
            String,
            String,
            String,
            [String : Any]?,
            [String : String]?,
            Int
        )
        -> AnyPublisher <Result <[T], Error>, Never>
    )
    -> AnyPublisher <Result <[T], Error>, Never>
    {
        if CacheManager.isRemote.single ?? true
        {
            return handler(host ?? "", port ?? "", path, params, headers, retries)
        }
        else
        {
            // TODO: Get Data Locally
            
            return Just(.failure(NetworkCenterError.failedToConnectToServer)).eraseToAnyPublisher()
        }
    }
    
}

extension NetworkCenter
{
    @discardableResult
    internal func callItems <T: _T.Role> (
        _ path:      String,
        with params: [String : String]? = nil
    )
    -> AnyPublisher <Result <[T], Error>, Never>
    {
        callee(path: path, params: params, getItems)
    }
}