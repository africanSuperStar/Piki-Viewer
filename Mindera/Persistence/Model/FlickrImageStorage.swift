//
//  FlickrImageStorage.swift
//  Mindira
//
//  Created by Cameron de Bruyn on 2021/08/01.
//

import Combine
import CoreData


// MARK: - Save Image Data
class FlickrImageStorage
{
    static func saveImage(for photoId: String, result: FlickrImageResult)
    {
        CoreDataManager.managedContext.perform
        {
            let flickrStorage = FlickrImageResultStorage(context: CoreDataManager.managedContext)
            
            flickrStorage.id           = UUID().uuidString
            flickrStorage.photoId      = photoId
            flickrStorage.data         = result.data ?? Data()
            
            flickrStorage.searchResult = FlickrSearchResultStorage(context: CoreDataManager.managedContext)
            flickrStorage.sizeResult   = FlickrSizeResultStorage(context: CoreDataManager.managedContext)
            
            try? CoreDataManager.managedContext.save()
        }
    }
}

// MARK: - Fetch Photos Size Results
extension FlickrImageStorage
{
    static func fetchImages() -> AnyPublisher <[FlickrImageResult], Error>
    {
        CoreDataManager.managedContext.fetchPublisher(FlickrImageResultStorage.all)
            .map
            {
                result in
                
                // TODO: Fix Efficiency for this.
                
                let results = result
                    .compactMap
                    {
                        value -> FlickrImageResult? in
                        
                        let searchResultStorage = FlickrSearchResultStorage(context: CoreDataManager.managedContext)
                        let sizeResultStorage   = FlickrSizeResultStorage(context: CoreDataManager.managedContext)
                        
                        let _searchResult = try? searchResultStorage.single(for: value.photoId).execute()
                        let _sizeResult   = try? sizeResultStorage.single(for: value.photoId).execute()
                        
                        guard let firstSearchResult = _searchResult?.first else { return nil }
                        guard let firstSizeResult   = _sizeResult?.first else { return nil }
                        
                        let searchResult = FlickrSearchResult(
                            id:       firstSearchResult.id,
                            owner:    firstSearchResult.owner,
                            title:    firstSearchResult.title,
                            secret:   firstSearchResult.secret,
                            server:   firstSearchResult.server,
                            farm:     firstSearchResult.farm,
                            isPublic: firstSearchResult.isPublic,
                            isFriend: firstSearchResult.isFriend,
                            isFamily: firstSearchResult.isFamily
                        )
                        
                        let sizeResult = FlickrSizeResult(
                            label:  firstSizeResult.label,
                            width:  firstSizeResult.width,
                            height: firstSizeResult.height,
                            source: firstSizeResult.source,
                            url:    firstSizeResult.url,
                            media:  firstSizeResult.media
                        )
                        
                        return FlickrImageResult(
                            photoId:      value.photoId,
                            data:         value.data,
                            searchResult: searchResult,
                            sizeResult:   sizeResult
                        )
                    }
                
                return results
            }
            .eraseToAnyPublisher()
    }
}
