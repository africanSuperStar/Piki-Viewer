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
    func searchFlickr <T: _T.Role> (tags: String, page: Int) throws -> AnyPublisher <[T], Error>
    {
        print("INFO: Search Flickr with Tags and page.")
        
        return callItems(
            "api.flickr.com/services/rest/",
            with: [
                "method": "flickr.photos.search",
                "api_key": CacheManager.accessToken.single ?? "",
                "tags": tags,
                "page": "\(page)",
                "format": "json",
                "nojsoncallback": "1"
            ]
        )
    }
}