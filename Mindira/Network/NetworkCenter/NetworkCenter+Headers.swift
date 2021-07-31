//
//  NetworkCenter+Headers.swift
//  Mindira
//
//  Created by Cameron de Bruyn on 2021/07/31.
//

import Foundation


extension NetworkCenter
{
    var get: URLRequest?
    {
        get
        {
            var components = URLComponents()
        
            components.scheme     = scheme
            components.host       = host
            components.path       = path ?? ""
            components.percentEncodedQueryItems = urlQueryItems
            
            guard let url = components.url?.absoluteURL else { return nil }
            
            print("ABS. URL: \(components.url?.absoluteString ?? "")")
            
            var request = URLRequest(url: url)
            
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue(headers["Authorization"], forHTTPHeaderField: "Authorization")
            
            return request
        }
    }
}
