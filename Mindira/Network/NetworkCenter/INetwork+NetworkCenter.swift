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
        if let accessToken = accessToken
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
        _path:    String,
        _params:  [String: String]? = nil,
        retries:  Int = 0,
        _ handler: @escaping (
            String,
            String,
            [String : Any]?,
            [String : String]?,
            Int
        )
        -> AnyPublisher <T, Error>
    )
    -> AnyPublisher <T, Error>
    {
        if CacheManager.isRemote.single ?? true
        {
            path       = _path
            queryItems = _params
            
            return handler(host ?? "", _path, _params, headers, retries)
        }
        else
        {
            // TODO: Get Data Locally
            
            return Fail(
                outputType: T.self,
                failure: NetworkCenterError.failedToRetrieveValue
            )
            .eraseToAnyPublisher()
        }
    }
    
    fileprivate func callee <T> (
        _path:    String,
        _params:  [String: String]? = nil,
        retries:  Int = 0,
        _ handler: @escaping (
            String,
            String,
            [String : Any]?,
            [String : String]?,
            Int
        )
        -> AnyPublisher <[T], Error>
    )
    -> AnyPublisher <[T], Error>
    {
        if CacheManager.isRemote.single ?? true
        {
            path       = _path
            queryItems = _params
            
            return handler(host ?? "", _path, _params, headers, retries)                
        }
        else
        {
            // TODO: Get Data Locally
            
            return Fail(
                outputType: [T].self,
                failure: NetworkCenterError.failedToRetrieveValue
            )
            .eraseToAnyPublisher()
        }
    }
    
}

extension NetworkCenter
{
    @discardableResult
    internal func callItem <T: _T.Role> (
        _ path:      String,
        with params: [String : String]? = nil
    )
    -> AnyPublisher <T, Error>
    {
        callee(_path: path, _params: params, getItem)
    }
    
    @discardableResult
    internal func callItems <T: _T.Role> (
        _ path:      String,
        with params: [String : String]? = nil
    )
    -> AnyPublisher <[T], Error>
    {
        callee(_path: path, _params: params, getItems)
    }
}
