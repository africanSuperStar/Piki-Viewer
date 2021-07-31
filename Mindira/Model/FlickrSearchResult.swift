//
//  FlickrSearchResult.swift
//  Mindira
//
//  Created by Cameron de Bruyn on 2021/07/31.
//

import Foundation

//"""
//{
//    "photos": {
//        "page": 1,
//        "pages": 8131,
//        "perpage": 100,
//        "total": 813042,
//        "photo": [{
//            "id":"51348135429",
//            "owner":"51388540@N05",
//            "secret":"e940be83fb",
//            "server":"65535",
//            "farm":66,
//            "title":"10473 - Duccio",
//            "ispublic":1,
//            "isfriend":0,
//            "isfamily":0
//        }]
//    }
//}
//"""


struct FlickrPhotos : AnyModel
{
    typealias Role = Self
    
    let photos:  FlickrPhoto?

    enum CodingKeys: String, CodingKey
    {
        case photos
    }
}

struct FlickrPhoto : AnyModel
{
    typealias Role = Self
    
    let total:   Int?
    let page:    Int?
    let pages:   Int?
    let perPage: Int?
    let photo:   [FlickrSearchResult]
    
    enum CodingKeys: String, CodingKey
    {
        case total, page, pages, photo
        case perPage = "perpage"
    }
}

struct FlickrSearchResult : AnyModel
{
    typealias Role = Self
    
    let id:    String?
    let title: String?
    
    enum CodingKeys: String, CodingKey
    {
        case id, title
    }
}
