//
//  PhotosController.swift
//  Mindira
//
//  Created by Cameron de Bruyn on 2021/07/31.
//

import UIKit
import Foundation
import Combine


class PhotosController: ObservableObject
{
    @Network<FlickrPhotos>(key: "flickr-photos")
    var networkPhotos
    
    @Network<FlickrSizes>(key: "flickr-sizes")
    var networkSizes
    
    @Network<FlickrImage>(key: "flickr-image")
    var networkImage
    
    @Published
    private(set) var flickrPhotos: FlickrPhotos?
    
    @Published
    private(set) var flickrSizes: FlickrSizes?
    
    @Published
    private(set) var flickrImage: Data = Data()
    
    @Published
    private(set) var photos: [Photo] = []
    
    private var bag = Set<AnyCancellable>()
    
    weak var delegate: MainViewDelegate?
    
    struct Photo: Hashable
    {
        let imageData:    Data
        let flickrSearch: FlickrSearchResult
        let flickrSize:   FlickrSizeResult
        
        func hash(into hasher: inout Hasher)
        {
            hasher.combine(flickrSearch.id)
        }
        
        static func == (lhs: Photo, rhs: Photo) -> Bool
        {
            return lhs.flickrSearch.id == rhs.flickrSearch.id
        }
        
        func contains(_ filter: String?) -> Bool
        {
            guard let filterText = filter else { return true }
            
            if filterText.isEmpty { return true }
            
            let lowercasedFilter = filterText.lowercased()
            
            return flickrSearch.title?.lowercased().contains(lowercasedFilter) ?? false
        }
    }
    
    func searchPhotos(with tag: String, page: Int)
    {
        try? networkPhotos.searchFlickr(tags: tag, page: page)
            .replaceError(with: FlickrPhotos(photos: nil, stat: "NO SUCCESS"))
            .sink(receiveValue:
            {
                [weak self] result in guard let this = self else { return }
                
                this.generatePhotos(result: result)
                
                this.delegate?.photosGenerated()
            })
            .store(in: &bag)
    }
    
    private func searchSizes(with id: String)
    {
        try? networkSizes.getSizes(photoId: id)
            .replaceError(with: FlickrSizes(sizes: nil, stat: "NO SUCCESS"))
            .assign(to: \.flickrSizes, on: self)
            .store(in: &bag)
    }
    
    private func fetchImage(from url: URL)
    {
        networkImage.getData(from: url)
            .replaceError(with: Data())
            .assign(to: \.flickrImage, on: self)
            .store(in: &bag)
    }
}

extension PhotosController
{
    private func generatePhotos(result: FlickrPhotos)
    {
        var _photos = [Photo]()
     
        for searchResult in (result.photos?.photo ?? []).prefix(5)
        {
            guard let _id = searchResult.id else { continue }
            
            searchSizes(with: _id)
     
            if let size = flickrSizes?.sizes?.size?.filter({ $0.label == "Large Square" }).first
            {
                if let source = size.source,
                   let url    = URL(string: source)
                {
                    fetchImage(from: url)
                    
                    let photo = Photo(
                        imageData:    flickrImage,
                        flickrSearch: searchResult,
                        flickrSize:   size
                    )
    
                    _photos.append(photo)
                }
            }
        }
        
        photos = _photos
    }
}
