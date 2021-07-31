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
    
    case scheme(_ key: String)
    case path(_ key: String)
    case queryItems(_ key: String)
    case urlQueryItems(_ key: String)
    case components(_ key: String)
    case headers(_ key: String)
    
    var rawIdentifier: String
    {
        switch self
        {
        case .isRemote:
            return "is-remote"
            
        case .hasLaunchedBefore:
            return "has-launch-before"
            
        case .accessToken(let raw):
            return "\(raw)-access-token"
            
        case .host(let raw):
            return "\(raw)-host"
            
        case .scheme(let raw):
            return "\(raw)-scheme"
            
        case .path(let raw):
            return "\(raw)-path"
            
        case .queryItems(let raw):
            return "\(raw)-query-items"
        
        case .urlQueryItems(let raw):
            return "\(raw)-url-query-items"
            
        case .components(let raw):
            return "\(raw)-components"
            
        case .headers(let raw):
            return "\(raw)-headers"
        }
    }
}

struct CacheManager
{
    static var isRemote          = Cache <String, Bool>()
    static var hasLaunchedBefore = Cache <String, Bool>()
    
    static var accessToken       = Cache <String, String>()
    static var host              = Cache <String, String>()
    
    static var scheme            = Cache <String, String>()
    static var path              = Cache <String, String>()
    static var queryItems        = Cache <String, [String : String]>()
    static var urlQueryItems     = Cache <String, [URLQueryItem]>()
    static var components        = Cache <String, URLComponents>()
    static var headers           = Cache <String, [String : String]>()
}
