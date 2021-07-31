//
//  FlickrSizeObject.swift
//  Mindira
//
//  Created by Cameron de Bruyn on 2021/08/01.
//

import Foundation
import CoreData


@objc(FlickrSizeResult)
public final class FlickrSizeResultStorage : NSManagedObject
{
    @NSManaged public var id:      String
    @NSManaged public var photoId: String
    @NSManaged public var label:   String
    @NSManaged public var width:   Int
    @NSManaged public var height:  Int
    @NSManaged public var source:  String
    @NSManaged public var url:     String
    @NSManaged public var media:   String
    
    public static var all: NSFetchRequest <FlickrSizeResultStorage>
    {
        let fetchRequest = NSFetchRequest<FlickrSizeResultStorage>(entityName: "FlickrSizeResult")
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \FlickrSizeResultStorage.id, ascending: true)
        ]
        
        return fetchRequest
    }
}
