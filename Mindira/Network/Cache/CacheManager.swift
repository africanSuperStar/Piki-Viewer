//
//  CacheManager.swift
//  Mindira
//
//  Created by Cameron de Bruyn on 2021/07/31.
//

import Foundation


enum CacheKeys
{
    case isRemote
    case hasLaunchedBefore
    
    case accessToken(_ key: String)
    
    case host(_ key: String)
    case port(_ key: String)
    
    case scheme(_ key: String)
    case path(_ key: String)
    case queryItems(_ key: String)
    case urlQueryItems(_ key: String)
    case components(_ key: String)
    case headers(_ key: String)
}

struct CacheManager
{
    static var isRemote          = Cache <String, Bool>()
    static var hasLaunchedBefore = Cache <String, Bool>()
    
    static var accessToken       = Cache <String, String>()
    static var host              = Cache <String, String>()
    static var port              = Cache <String, String>()
    
    static var scheme            = Cache <String, String>()
    static var path              = Cache <String, String>()
    static var queryItems        = Cache <String, [String : String]>()
    static var urlQueryItems     = Cache <String, [URLQueryItem]>()
    static var components        = Cache <String, URLComponents>()
    static var headers           = Cache <String, [String : String]>()
}
