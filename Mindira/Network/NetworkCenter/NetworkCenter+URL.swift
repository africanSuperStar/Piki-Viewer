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
    var port: String?
    {
        get
        {
            guard let port = CacheManager.port.value(forKey: .port(_key))
            else
            {
                print("CRITICAL: Failed to fetch port from Cache Manager.")
                
                return nil
            }
            
            return port
        }
        
        set
        {
            guard let _port = newValue
            else
            {
                print("CRITICAL: Failed to set port in Cache Manager.")
                
                return
            }
            
            CacheManager.port.insert(_port, forKey: .port(_key))
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
            guard let urlQueryItems = CacheManager.urlQueryItems.value(forKey: .queryItems(_key))
            else
            {
                print("CRITICAL: Failed to fetch query items from Data Cache Manager")
                
                return nil
            }
            
            return urlQueryItems
        }
        
        set
        {
            guard let _urlQueryItems = newValue
            else
            {
                print("CRITICAL: Failed to set URLQueryItems in Cache Manager.")
                
                return
            }
            
            CacheManager.urlQueryItems.insert(_urlQueryItems, forKey: .path(_key))
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
            
            urlQueryItems = _urlQueryItems
        }
    }
}

extension NetworkCenter
{
    var components: URLComponents?
    {
        get
        {
            var components = URLComponents()
            
            if let port = Int(port ?? "")
            {
                components.port = port
            }
        
            components.scheme     = scheme
            components.host       = host
            components.path       = path ?? ""
            components.percentEncodedQueryItems = urlQueryItems ?? []
            
            CacheManager.components.update(components, forKey: .components(_key))
            
            return components
        }
        
        set
        {
            guard let _components = newValue
            else
            {
                print("CRITICAL: Failed to set components in Cache Manager.")
                
                return
            }
            
            CacheManager.components.insert(_components, forKey: .path(_key))
        }
    }
}

extension NetworkCenter
{
    var url: URL?
    {
        get
        {
            guard let components = CacheManager.components.value(forKey: .components(_key))
            else
            {
                print("CRITICAL: Failed to fetch URL Components from Data Cache Manager")
                
                return nil
            }
            
            return components.url?.absoluteURL
        }
    }
}
