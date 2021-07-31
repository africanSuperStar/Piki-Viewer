//
//  GetItemURL.swift
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
    internal func getItem <T: Codable> (
        _ host:      String,
        _ port:      String,
        path:        String,
        with params: [String: Any]?,
        headers:     [String: String]?,
        retries:     Int = 1
    )
    -> AnyPublisher <Result <T, Error>, Never>
    {
        guard let request = get
            else
        {
            return Just(.failure(NetworkCenterError.failedToBuildRequest))
                .setFailureType(to: Never.self)
                .eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: request)
            .tryMap
            {
                [unowned self] (data, response) -> Result <T, Error> in
                
                try decode(data, with: response)
            }
            .receive(on: scheduler)
            .retry(retries)
            .replaceError(with: .failure(NetworkCenterError.failedToRetrieveValue))
            .eraseToAnyPublisher()
    }
    
}
