//
//  Network+URL.swift
//  Mindira
//
//  Created by Cameron de Bruyn on 2021/07/31.
//

import Foundation
import CryptoKit

extension NetworkCenter
{
    var host: String?
    {
        get
        {
            guard let host = NetworkCenterCacheManager.host.value(forKey)
        }
    }
}
