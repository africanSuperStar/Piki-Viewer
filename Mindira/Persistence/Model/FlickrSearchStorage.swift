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
    static func savePhotos(flickrPhotos: FlickrPhotos, completion: @escaping (Error?) -> Void)
    {
        CoreDataManager.managedContext.perform
        {
            for searchResult in (flickrPhotos.photos?.photo ?? [])
            {
                let result = FlickrSearchResultStorage(context: CoreDataManager.managedContext)
                
                result.id       = searchResult.id       ?? ""
                result.owner    = searchResult.owner    ?? ""
                result.title    = searchResult.title    ?? ""
                result.secret   = searchResult.secret   ?? ""
                result.server   = searchResult.server   ?? ""
                result.farm     = searchResult.farm     ?? 0
                result.isPublic = searchResult.isPublic ?? 0
                result.isFriend = searchResult.isFriend ?? 0
                result.isFamily = searchResult.isFamily ?? 0
            }
            
            do {
                try CoreDataManager.managedContext.save()
                completion(nil)
            }
            catch
            {
                completion(error)
            }
        }
    }
    
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
    static func fetchPhotos(completion: @escaping (Result<[FlickrSearchResult], Error>) -> Void)
    {
        CoreDataManager.managedContext.perform
        {
            do {
                let photos = try CoreDataManager.managedContext.fetch(FlickrSearchResultStorage.all)
                
                let _photos = photos.compactMap
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
                
                completion(.success(_photos))
            }
            catch
            {
                completion(.failure(error))
            }
        }
    }

    static func fetchPhotos() -> AnyPublisher<[FlickrSearchResult], Error>
    {
        CoreDataManager.managedContext.fetchPublisher(FlickrSearchResultStorage.all)
            .map
            {
                result in
                
                result.compactMap
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
            }
            .eraseToAnyPublisher()
    }
}
