//
//  NetworkCenter+Response.swift
//  Mindira
//
//  Created by Cameron de Bruyn on 2021/07/31.
//

import Foundation
import Combine


extension NetworkCenter
{
    internal func decode <T : _T.Role> (_ data: Data, with response: URLResponse) throws -> T
    {
        try? validateResponse(response)
        
        let decoder = JSONDecoder()
        
        guard let result = try? decoder.decode(T.self, from: data)
        else
        {
            throw NetworkCenterError.failedToDecodeItems
        }
        
        return result
    }
    
    internal func decodeItems <T : _T.Role> (_ data: Data, with response: URLResponse) throws -> [T]
    {
        try? validateResponse(response)
        
        guard let result = try? JSONDecoder().decode([T].self, from: data)
        else
        {
            throw NetworkCenterError.failedToDecodeItems
        }
        
        return result
    }
}

extension NetworkCenter
{
    internal func validateResponse(_ response: URLResponse) throws
    {
        guard let response = response as? HTTPURLResponse
            else
        {
            print("FAILED HTTP Response: Failed to receive HTTP Response.")
            
            throw NetworkCenterError.failedToGetStatusCode
        }
        
        if 400..<499 ~= response.statusCode
        {
            print("FAILED HTTP Response: Expired Access Token")
            
            throw NetworkCenterError.failedStatusCode(code: response.statusCode)
        }
        
        guard 200..<299 ~= response.statusCode
        else
        {
            print("FAILED HTTP Response: Failed Status Code")
            
            throw NetworkCenterError.failedStatusCode(code: response.statusCode)
        }
    }
    
}
