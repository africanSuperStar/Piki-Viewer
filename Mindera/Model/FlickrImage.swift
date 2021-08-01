//
//  FlickrImage.swift
//  Mindira
//
//  Created by Cameron de Bruyn on 2021/07/31.
//

import Foundation

struct FlickrImage : AnyModel
{
    typealias Role = Data
}

struct FlickrImageResult : AnyModel
{
    typealias Role = Codable
    
    let photoId: String?
    let data:    Data?
    
    let searchResult: FlickrSearchResult?
    let sizeResult:   FlickrSizeResult?
}


