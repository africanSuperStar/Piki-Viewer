//
//  FlickrSize.swift
//  Mindira
//
//  Created by Cameron de Bruyn on 2021/07/31.
//

import Foundation


struct FlickrSizes : AnyModel
{
    typealias Role = Self
    
    let sizes:  FlickrSize?
    let stat:   String?

    enum CodingKeys: String, CodingKey
    {
        case sizes, stat
    }
}

struct FlickrSize : AnyModel
{
    typealias Role = Self
    
    let canBlog:     Int?
    let canPrint:    Int?
    let canDownload: Int?
    let size:        [FlickrSizeResult]?
    
    enum CodingKeys: String, CodingKey
    {
        case canBlog     = "canblog"
        case canPrint    = "canprint"
        case canDownload = "candownload"
        case size
    }
}

struct FlickrSizeResult : AnyModel
{
    typealias Role = Self
    
    let label:  String?
    let width:  Int?
    let height: Int?
    let source: String?
    let url:    String?
    let media:  String?
    
    enum CodingKeys: String, CodingKey
    {
        case label, width, height, source, url, media
    }
}
