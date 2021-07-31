//
//  Network+URL.swift
//  Mindira
//
//  Created by Cameron de Bruyn on 2021/07/31.
//

import Foundation


extension NetworkCenter
{
    var host: String?
    {
        get
        {
            guard let host = CacheManager.host.value(forKey: .host(_key))
            else
            {
                print("CRITICAL: Failed to fetch host from Cache Manager.")
                
                return nil
            }
            
            return host
        }
        
        set
        {
            guard let _host = newValue
            else
            {
                print("CRITICAL: Failed to set host in Cache Manager.")
                
                return
            }
            
            CacheManager.host.insert(_host, forKey: .host(_key))
        }
    }
}

extension NetworkCenter
{
    var scheme: String?
    {
        get
        {
            guard let scheme = CacheManager.scheme.value(forKey: .scheme(_key))
            else
            {
                print("CRITICAL: Failed to fetch port from Cache Manager.")
                
                return nil
            }
            
            return scheme
        }
        
        set
        {
            guard let _scheme = newValue
            else
            {
                print("CRITICAL: Failed to set scheme in Cache Manager.")
                
                return
            }
            
            CacheManager.scheme.insert(_scheme, forKey: .scheme(_key))
        }
    }
}

extension NetworkCenter
{
    var path: String?
    {
        get
        {
            guard let path = CacheManager.path.value(forKey: .path(_key))
            else
            {
                print("CRITICAL: Failed to fetch path from Cache Manager.")
                       
                return nil
            }
            
            return path
        }
        
        set
        {
            guard let _path = newValue
            else
            {
                print("CRITICAL: Failed to set scheme in Cache Manager.")
                
                return
            }
            
            CacheManager.path.insert(_path, forKey: .path(_key))
        }
    }
}

extension NetworkCenter
{
    var urlQueryItems: [URLQueryItem]?
    {
        get
        {
            guard let urlQueryItems = CacheManager.urlQueryItems.value(forKey: .urlQueryItems(_key))
            else
            {
                print("CRITICAL: Failed to fetch URL query items from Data Cache Manager")
                
                return []
            }
            
            return urlQueryItems
        }
    }
    
    var queryItems: [String : String]?
    {
        get
        {
            guard let queryItems = CacheManager.queryItems.value(forKey: .queryItems(_key))
            else
            {
                print("CRITICAL: Failed to fetch query items from Data Cache Manager")
                
                return nil
            }
            
            return queryItems
        }
        
        set
        {
            CacheManager.queryItems.insert(newValue ?? [:], forKey: .queryItems(_key))
            
            let _urlQueryItems = newValue?.compactMap
            {
                (key, value) -> URLQueryItem? in
                
                guard let urlEncodedString = value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                    else
                {
                    return nil
                }
                
                return URLQueryItem(name: key, value: urlEncodedString)
            }

            CacheManager.urlQueryItems.insert(_urlQueryItems ?? [], forKey: .urlQueryItems(_key))
        }
    }
}
