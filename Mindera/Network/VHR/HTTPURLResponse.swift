//
//  HTTPURLResponse.swift
//  Mindira
//
//  Created by Cameron de Bruyn on 2021/08/01.
//

import Foundation

class HTTPURLResponse: Foundation.HTTPURLResponse
{
    // MARK: - Properties

    private var _url: URL?

    override var url: URL?
    {
        get
        {
            return _url ?? super.url
        }

        set
        {
            _url = newValue
        }
    }

    private var _statusCode: Int?
    
    override var statusCode: Int
    {
        get
        {
            return _statusCode ?? super.statusCode
        }

        set
        {
            _statusCode = newValue
        }
    }

    private var _allHeaderFields: [AnyHashable: Any]?
    
    override var allHeaderFields: [AnyHashable: Any]
    {
        get
        {
            return _allHeaderFields ?? super.allHeaderFields
        }

        set
        {
            _allHeaderFields = newValue
        }
    }
}


extension HTTPURLResponse
{
    convenience init(dictionary: [String: Any])
    {
        let url = URL(string: dictionary["url"] as! String)!

        self.init(url: url, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)

        if let headers = dictionary["headers"] as? [String: String]
        {
            allHeaderFields = headers
        }

        if let status = dictionary["status"] as? Int
        {
            statusCode = status
        }
    }
}
