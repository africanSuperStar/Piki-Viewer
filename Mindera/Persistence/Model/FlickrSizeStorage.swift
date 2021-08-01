//
//  FlickrSizeStorage.swift
//  Mindira
//
//  Created by Cameron de Bruyn on 2021/08/01.
//

import Combine
import CoreData


// MARK: - Save Photos Size Results
struct FlickrSizeStorage
{
    static func saveSizes(for photoId: String, sizes: [FlickrSizeResult]) -> AnyPublisher <Void, Error>
    {
        CoreDataManager.managedContext.publisher
        {
            for result in sizes
            {
                let flickrStorage = FlickrSizeResultStorage(context: CoreDataManager.managedContext)
                
                flickrStorage.photoId = photoId
                flickrStorage.id      = result.id     ?? ""
                flickrStorage.label   = result.label  ?? ""
                flickrStorage.width   = result.width  ?? 0
                flickrStorage.height  = result.height ?? 0
                flickrStorage.source  = result.source ?? ""
                flickrStorage.url     = result.url    ?? ""
                flickrStorage.media   = result.media  ?? ""
            }
            
            try CoreDataManager.managedContext.save()
        }
    }
}

// MARK: - Fetch Photos Size Results
extension FlickrSizeStorage
{
    static func fetchSizes<T: Codable>(for photoId: String) -> AnyPublisher<T, Error>
    {
        CoreDataManager.managedContext.fetchPublisher(FlickrSizeResultStorage.all)
            .map
            {
                result in
                
                // TODO: Fix Efficiency for this.
                
                let results = result
                    .filter({ $0.photoId == photoId })
                    .compactMap
                    {
                        return FlickrSizeResult(
                            label:  $0.label,
                            width:  $0.width,
                            height: $0.height,
                            source: $0.source,
                            url:    $0.url,
                            media:  $0.media
                        )
                    }
                
                let size = FlickrSize(
                    canBlog:     nil,
                    canPrint:    nil,
                    canDownload: nil,
                    size: results)
                
                return FlickrSizes(sizes: size, stat: "ok") as! T
            }
            .eraseToAnyPublisher()
    }
}
