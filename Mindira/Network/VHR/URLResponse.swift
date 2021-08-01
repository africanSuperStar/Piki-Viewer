//
//  URLResponse.swift
//  Mindira
//
//  Created by Cameron de Bruyn on 2021/08/01.
//

import Foundation

class URLResponse : Foundation.URLResponse
{
    private var _URL: Foundation.URL?

    override var url: Foundation.URL?
    {
        get
        {
            return _URL ?? super.url
        }

        set
        {
            _URL = newValue
        }
    }
}

extension Foundation.URLResponse
{
    var dictionary: [String: Any]
    {
        if let url = url?.absoluteString
        {
            return ["url": url as Any]
        }

        return [:]
    }
}

extension URLResponse
{
    convenience init(dictionary: [String: Any])
    {
        self.init()

        if let string = dictionary["url"] as? String, let url = Foundation.URL(string: string)
        {
            self.url = url
        }
    }
}
