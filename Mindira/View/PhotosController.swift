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
        let photoId:      String
        let imageData:    Data
        let flickrSearch: FlickrSearchResult?
        let flickrSize:   FlickrSizeResult?
        
        func hash(into hasher: inout Hasher)
        {
            hasher.combine(flickrSearch?.id)
        }
        
        static func == (lhs: Photo, rhs: Photo) -> Bool
        {
            return lhs.photoId == rhs.photoId
        }
        
        func contains(_ filter: String?) -> Bool
        {
            guard let filterText = filter else { return true }
            
            if filterText.isEmpty { return true }
            
            let lowercasedFilter = filterText.lowercased()
            
            return flickrSearch?.title?.lowercased().contains(lowercasedFilter) ?? false
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
        DispatchQueue.global(qos: .userInteractive).async
        {
            self.photos.removeAll()
        }
        
        let lock = NSLock()
        
        guard let isRemote = CacheManager.isRemote.value(forKey: .isRemote) else { return }
        
        if !isRemote
        {
            FlickrImageStorage.fetchImages()
                .replaceError(with: [])
                .subscribe(on: DispatchQueue.global(qos: .background))
                .receive(on: DispatchQueue.global(qos: .background), options: .none)
                .sink
                {
                    [weak self] results in guard let this = self else { return }
                    
                    results.forEach
                    {
                        guard let _photoId = $0.photoId else { return }
                        
                        let photo = Photo(
                            photoId: _photoId,
                            imageData: $0.data ?? Data(),
                            flickrSearch: $0.searchResult,
                            flickrSize: $0.sizeResult
                        )
                        
                        DispatchQueue.global(qos: .background).async
                        {
                            lock.lock()
                            this.photos.removeAll(where: { $0.photoId == _photoId })
                            lock.unlock()
                            
                            lock.lock()
                            this.photos.append(photo)
                            lock.unlock()

                            this.delegate?.photosGenerated()
                        }
                    }
                }
                .cancel()
        }
        else
        {
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
        let lock = NSLock()
        
        guard let photoId = searchResult.id else { return }

        let photo = Photo(
            photoId: photoId,
            imageData: image,
            flickrSearch: searchResult,
            flickrSize: flickrSizeResult
        )

        let flickerImageResult = FlickrImageResult(
            photoId:      photoId,
            data:         image,
            searchResult: searchResult,
            sizeResult:   flickrSizeResult
        )
        
        FlickrImageStorage.saveImage(for: photoId, result: flickerImageResult)
        
        DispatchQueue.global(qos: .background).async
        {
            [weak self] in guard let this = self else { return }
            
            lock.lock()
            this.photos.removeAll(where: { $0.photoId == photoId })
            lock.unlock()
            
            lock.lock()
            this.photos.append(photo)
            lock.unlock()

        }
    }
}
