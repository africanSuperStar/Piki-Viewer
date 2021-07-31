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
            guard let url = url else { return nil }
            
            var request = URLRequest(url: url)
            
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Content-Tyoe")
        }
    }
}
