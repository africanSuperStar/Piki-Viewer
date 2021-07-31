//
//  Items.swift
//  DataCenterPlatform
//
//  Created by Cameron de Bruyn on 2021/05/29.
//  Copyright © 2021 Astrocyte. All rights reserved.
//

import Foundation
import Combine


extension NetworkCenter
{
    @discardableResult
    internal func getItems <T: _T.Role> (
        _ host:      String,
        path:        String,
        with params: [String: Any]?,
        headers:     [String: String]?,
        retries:     Int = 1
    )
    -> AnyPublisher <[T], Error>
    {
        guard let request = get
            else
        {
            return Fail(
                outputType: [T].self,
                failure: NetworkCenterError.failedToBuildRequest
            )
            .eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: request)
            .tryMap
            {
                [weak self] value in guard let this = self else { throw NetworkCenterError.failedToDecodeItems }
                
                print("HTTP: DATA RECIEVED \(value.data.debugDescription)")
                
                return try this.decodeItems(value.data, with: value.response)
            }
            .receive(on: scheduler)
            .retry(retries)
            .eraseToAnyPublisher()
    }
}
