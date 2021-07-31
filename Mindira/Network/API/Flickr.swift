//
//  Flickr.swift
//  Mindira
//
//  Created by Cameron de Bruyn on 2021/07/31.
//

import Combine


extension NetworkCenter
{
    @discardableResult
    func searchFlickr <T: _T.Role> (tags: String, page: Int) throws -> AnyPublisher <Result <[T], Error>, Never>
    {
        print("INFO: Search Flickr with Tags and page.")
        
        return callItems(
            "api.flickr.com/services/rest/",
            with: [
                "method": "flickr.photos.search",
                "api_key": "f9cc014fa76b098f9e82f1c288379ea1",
                "tags": "kitten",
                "page": "1",
                "format": "json",
                "nojsoncallback": "1"
            ]
        )
    }
}
