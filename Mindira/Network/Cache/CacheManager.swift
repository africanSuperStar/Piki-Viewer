//
//  CacheManager.swift
//  Mindira
//
//  Created by Cameron de Bruyn on 2021/07/31.
//

import Foundation


enum CacheKeys
{
    case tenant(_ key: String)
    
    case host(_ key: String)
    case port(_ key: String)
}

struct CacheManager
{
    static var tenant = Cache <String, String>()
    static var host   = Cache <String, String>()
    static var port   = Cache <String, String>()
}
