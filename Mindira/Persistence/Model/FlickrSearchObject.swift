//
//  FlickrSearch.swift
//  Mindira
//
//  Created by Cameron de Bruyn on 2021/07/31.
//

import Foundation
import CoreData


@objc(FlickrSearchResult)
public final class FlickrSearchResultStorage : NSManagedObject
{
    @NSManaged public var id:       String
    @NSManaged public var owner:    String
    @NSManaged public var title:    String
    @NSManaged public var secret:   String
    @NSManaged public var server:   String
    @NSManaged public var farm:     Int
    @NSManaged public var isPublic: Int
    @NSManaged public var isFriend: Int
    @NSManaged public var isFamily: Int

    public static var all: NSFetchRequest <FlickrSearchResultStorage>
    {
        let fetchRequest = NSFetchRequest<FlickrSearchResultStorage>(entityName: "FlickrSearchResult")
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \FlickrSearchResultStorage.id, ascending: true)
        ]
        
        return fetchRequest
    }
}
