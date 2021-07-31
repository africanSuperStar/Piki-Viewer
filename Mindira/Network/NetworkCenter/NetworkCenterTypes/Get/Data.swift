//
//  Data.swift
//  Mindira
//
//  Created by Cameron de Bruyn on 2021/07/31.
//

import Foundation
import Combine


extension NetworkCenter
{
    @discardableResult
    internal func getData(from url: URL, retries: Int = 1) -> AnyPublisher <Data, URLError>
    {
        guard let data = try? Data(contentsOf: url)
            else
        {
            return Fail(
                outputType: Data.self,
                failure: URLError(URLError.badURL)
            )
            .eraseToAnyPublisher()
        }
        
        return Just(data)
            .setFailureType(to: URLError.self)
            .eraseToAnyPublisher()
    }
}
