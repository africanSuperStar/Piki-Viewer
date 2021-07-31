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
    internal func decode <T : Codable> (_ data: Data, with response: URLResponse) throws -> Result <T, Error>
    {
        return validateResponse(response)
            .flatMap
            {
                _ in
                
                guard let result = try? JSONDecoder().decode(T.self, from: data)
                    else
                {
                    return Result.failure(NetworkCenterError.failedToDecodeItems)
                }
                
                return Result { result }
            }
    }
    
    internal func decodeItems <T : Codable> (_ data: Data, with response: URLResponse) throws -> Result <[T], Error>
    {
        return validateResponse(response)
            .flatMap
            {
                _ in
                
                guard let result = try? JSONDecoder().decode([T].self, from: data)
                    else
                {
                    return Result.failure(NetworkCenterError.failedToDecodeItems)
                }
                
                return Result { result }
            }
    }
}

extension NetworkCenter
{
    internal func validateResponse(_ response: URLResponse) -> Result <Void, Error>
    {
        guard let response = response as? HTTPURLResponse
            else
        {
            print("FAILED HTTP Response: Failed to receive HTTP Response.")
            
            return Result.failure(NetworkCenterError.failedToGetStatusCode)
        }
        
        if 400..<499 ~= response.statusCode
        {
            print("FAILED HTTP Response: Expired Access Token")
            
            return Result.failure(NetworkCenterError.failedStatusCode(code: response.statusCode))
        }
        
        guard 200..<299 ~= response.statusCode
        else
        {
            print("FAILED HTTP Response: Failed Status Code")
            
            return Result.failure(NetworkCenterError.failedStatusCode(code: response.statusCode))
        }
        
        return Result { }
    }
    
}
