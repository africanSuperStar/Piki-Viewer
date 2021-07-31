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
            .map
            {
                print("HTTP: DATA RECIEVED \($0.data.debugDescription)")
                
                return $0.data
            }
            .decode(type: [T].self, decoder: JSONDecoder())
            .receive(on: scheduler)
            .retry(retries)
            .eraseToAnyPublisher()
    }
}
