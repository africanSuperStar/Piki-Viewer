//
//  FlickrSearchStorage.swift
//  Mindira
//
//  Created by Cameron de Bruyn on 2021/07/31.
//

import Combine
import CoreData


// MARK: - Save Photos Search Result
struct FlickrPhotosStorage
{
    static func savePhotos(searchResults: [FlickrSearchResult]) -> AnyPublisher <Void, Error>
    {
        CoreDataManager.managedContext.publisher
        {
            for result in searchResults
            {
                let flickrStorage = FlickrSearchResultStorage(context: CoreDataManager.managedContext)
                
                flickrStorage.id       = result.id       ?? ""
                flickrStorage.owner    = result.owner    ?? ""
                flickrStorage.title    = result.title    ?? ""
                flickrStorage.secret   = result.secret   ?? ""
                flickrStorage.server   = result.server   ?? ""
                flickrStorage.farm     = result.farm     ?? 0
                flickrStorage.isPublic = result.isPublic ?? 0
                flickrStorage.isFriend = result.isFriend ?? 0
                flickrStorage.isFamily = result.isFamily ?? 0
            }
            
            try CoreDataManager.managedContext.save()
        }
    }
}

// MARK: - Fetch Photos Search Results
extension FlickrPhotosStorage
{
    static func fetchPhotos<T: Codable>() -> AnyPublisher<T, Error>
    {
        CoreDataManager.managedContext.fetchPublisher(FlickrSearchResultStorage.all)
            .map
            {
                result in
                
                // TODO: Fix Efficiency for this.
                
                let results = result.compactMap
                {
                    return FlickrSearchResult(
                        id:       $0.id,
                        owner:    $0.owner,
                        title:    $0.title,
                        secret:   $0.secret,
                        server:   $0.server,
                        farm:     $0.farm,
                        isPublic: $0.isPublic,
                        isFriend: $0.isFriend,
                        isFamily: $0.isFamily
                    )
                }
                
                let photo = FlickrPhoto(
                    total:   nil,
                    page:    1,
                    pages:   nil,
                    perPage: nil,
                    photo:   results
                )
                
                return FlickrPhotos(photos: photo, stat: "ok") as! T
            }
            .eraseToAnyPublisher()
    }
}
