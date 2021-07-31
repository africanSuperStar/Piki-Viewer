//
//  Flickr.swift
//  Mindira
//
//  Created by Cameron de Bruyn on 2021/07/31.
//

import Foundation
import Combine


extension NetworkCenter
{
    @discardableResult
    func searchFlickr <T: _T.Role> (tags: String, page: Int) throws -> AnyPublisher <T, Error>
    {
        print("INFO: Search Flickr with Tags and page.")
        
        if CacheManager.isRemote.single ?? false
        {
            return FlickrPhotosStorage.fetchPhotos()
        }
        
        return callItem(
            "/services/rest/",
            with: [
                "method": "flickr.photos.search",
                "api_key": accessToken ?? "",
                "tags": tags,
                "page": "\(page)",
                "format": "json",
                "nojsoncallback": "1"
            ]
        )
    }
    
    @discardableResult
    func getSizes <T: _T.Role> (photoId: String) throws -> AnyPublisher <T, Error>
    {
        print("INFO: Get Sizes/URLs for a single image.")
        
        if CacheManager.isRemote.single ?? false
        {
            return FlickrSizeStorage.fetchSizes(for: photoId)
        }
        
        return callItem(
            "/services/rest/",
            with: [
                "method": "flickr.photos.getSizes",
                "api_key": accessToken ?? "",
                "photo_id": photoId,
                "format": "json",
                "nojsoncallback": "1"
            ]
        )
    }
    
    @discardableResult
    func getImage (source: URL) throws -> AnyPublisher <Data, URLError>
    {
        print("INFO: Get the image data with the label `Large Square`.")
        
        return callURL(source)
    }
}
