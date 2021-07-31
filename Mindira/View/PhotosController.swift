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
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.global(qos: .background), options: .none)
            .sink(receiveValue:
            {
                [weak self] result in guard let this = self else { return }
                
                DispatchQueue.main.async
                {
                    this.generatePhotos(result: result)
                }
            })
            .store(in: &bag)
    }
    
    private func searchSizes(with id: String, result: FlickrSearchResult)
    {
        try? networkSizes.getSizes(photoId: id)
            .replaceError(with: FlickrSizes(sizes: nil, stat: "NO SUCCESS"))
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.global(qos: .background), options: .none)
            .sink(receiveValue:
            {
                [weak self] sizes in guard let this = self else { return }
                
                this.sortSizes(flickrSizes: sizes, searchResult: result)
            })
            .store(in: &bag)
    }
    
    private func fetchImage(from url: URL, searchResult: FlickrSearchResult, flickrSizeResult: FlickrSizeResult)
    {
        networkImage.getData(from: url)
            .replaceError(with: Data())
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.global(qos: .background), options: .none)
            .sink(receiveValue:
            {
                [weak self] image in guard let this = self else { return }
                
                this.applyImage(image, searchResult: searchResult, flickrSizeResult: flickrSizeResult)
                
                this.delegate?.photosGenerated()
            })
            .cancel()
    }
}

extension PhotosController
{
    private func generatePhotos(result: FlickrPhotos)
    {
        DispatchQueue.global(qos: .background).async
        {
            self.photos.removeAll()
        }
        
        FlickrPhotosStorage
            .savePhotos(searchResults: result.photos?.photo ?? [])
            .replaceError(with: ())
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.global(qos: .background), options: .none)
            .sink { _ in }
            .cancel()
        
        for searchResult in (result.photos?.photo ?? []).prefix(5)
        {
            guard let _id = searchResult.id else { continue }
            
            searchSizes(with: _id, result: searchResult)
        }
    }
    
    private func sortSizes(flickrSizes: FlickrSizes, searchResult: FlickrSearchResult)
    {
        if let photoId = searchResult.id
        {
            FlickrSizeStorage
                .saveSizes(for: photoId, sizes: flickrSizes.sizes?.size ?? [])
                .replaceError(with: ())
                .subscribe(on: DispatchQueue.global(qos: .background))
                .receive(on: DispatchQueue.global(qos: .background), options: .none)
                .sink { _ in }
                .cancel()
        }
        
        if let size = flickrSizes.sizes?.size?.filter({ $0.label == "Large Square" }).first
        {
            if let source = size.source,
               let url    = URL(string: source)
            {
                fetchImage(from: url, searchResult: searchResult, flickrSizeResult: size)
            }
        }
    }
    
    private func applyImage(_ image: Data, searchResult: FlickrSearchResult, flickrSizeResult: FlickrSizeResult)
    {
        let photo = Photo(
            imageData: image,
            flickrSearch: searchResult,
            flickrSize: flickrSizeResult
        )
        
        if !photos.contains(photo)
        {
            DispatchQueue.global(qos: .background).async
            {
                self.photos.append(photo)
            }
        }
    }
}
