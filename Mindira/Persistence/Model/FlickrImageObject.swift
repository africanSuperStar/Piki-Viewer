//
//  FlickrImageObject.swift
//  Mindira
//
//  Created by Cameron de Bruyn on 2021/08/01.
//

import Foundation
import CoreData


@objc(FlickrImage)
public final class FlickrImageResultStorage : NSManagedObject
{
    @NSManaged public var id:      String
    @NSManaged public var photoId: String
    @NSManaged public var data:    Data
    
    @NSManaged public var searchResult: FlickrSearchResultStorage
    @NSManaged public var sizeResult:   FlickrSizeResultStorage
    
    public static var all: NSFetchRequest <FlickrImageResultStorage>
    {
        let fetchRequest = NSFetchRequest<FlickrImageResultStorage>(entityName: "FlickrImage")
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \FlickrImageResultStorage.id, ascending: true)
        ]
        
        return fetchRequest
    }
}
