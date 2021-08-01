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
//        "pages": 8745,
//        "perpage": 100,
//        "total": 874426,
//        "photo": [
//            {
//                "id": "51348090469",
//                "owner": "152603669@N08",
//                "secret": "3b123d0ceb",
//                "server": "65535",
//                "farm": 66,
//                "title": "P6190652_DxO",
//                "ispublic": 1,
//                "isfriend": 0,
//                "isfamily": 0
//            },
//        }]
//    },
//    "stat": "ok"
//}
//"""


struct FlickrPhotos : AnyModel
{
    typealias Role = Self
    
    let photos: FlickrPhoto?
    let stat:   String?

    enum CodingKeys: String, CodingKey
    {
        case photos, stat
    }
}

struct FlickrPhoto : AnyModel
{
    typealias Role = Self
    
    let total:   Int?
    let page:    Int?
    let pages:   Int?
    let perPage: Int?
    let photo:   [FlickrSearchResult]?
    
    enum CodingKeys: String, CodingKey
    {
        case total, page, pages, photo
        case perPage = "perpage"
    }
}

struct FlickrSearchResult : AnyModel
{
    typealias Role = Self
    
    let id:       String?
    let owner:    String?
    let title:    String?
    let secret:   String?
    let server:   String?
    let farm:     Int?
    let isPublic: Int?
    let isFriend: Int?
    let isFamily: Int?
    
    enum CodingKeys: String, CodingKey
    {
        case id, title, owner, secret, server, farm
        case isPublic = "ispublic"
        case isFriend = "isfriend"
        case isFamily = "isfamily"
    }
}
