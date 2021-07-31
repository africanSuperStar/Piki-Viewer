//
//  FlickrSearchResult.swift
//  Mindira
//
//  Created by Cameron de Bruyn on 2021/07/31.
//

import Foundation


struct FlickrSearchResult : AnyModel
{
    typealias Role = Self
    
    let id:    String
    let title: String?
    
    enum CodingKeys: String, CodingKey
    {
        case id, title
    }
}
