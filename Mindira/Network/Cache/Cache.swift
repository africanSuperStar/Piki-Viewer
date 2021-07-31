//
//  CacheManager.swift
//  Mindira
//
//  Created by Cameron de Bruyn on 2021/07/31.
//

import Foundation


final class Cache <Key: Hashable, Value>
{
    private let wrapped = NSCache <WrappedKey, Entry> ()

    private let dateProvider:  () -> Date
    private let entryLifetime: TimeInterval

    private let keyTracker = KeyTracker()

    init(dateProvider: @escaping () -> Date = Date.init,
         entryLifetime: TimeInterval = 12 * 60 * 60,
         maximumEntryCount: Int = 50
    ) {
        self.dateProvider  = dateProvider
        self.entryLifetime = entryLifetime
        
        wrapped.countLimit = maximumEntryCount
        wrapped.delegate   = keyTracker
    }
    
    func insert(_ value: Value, forKey key: CacheKeys)
    {
        guard let key = key as? Key
            else
        {
            return
        }
        
        let date  = dateProvider().addingTimeInterval(entryLifetime)
        let entry = Entry(key: key, value: value, expirationDate: date)
    
        wrapped.setObject(entry, forKey: WrappedKey(key))
        
        keyTracker.keys.insert(key)
    }
    
    func value(forKey key: CacheKeys) -> Value?
    {
        guard let _key = key as? Key, let entry = wrapped.object(forKey: WrappedKey(_key))
            else
        {
            return nil
        }

        guard dateProvider() < entry.expirationDate
            else
        {
            // Discard values that have expired
            removeValue(forKey: key)
        
            return nil
        }

        return entry.value
    }
    
    func update(_ value: Value, forKey key: CacheKeys)
    {
        removeValue(forKey: key)
        insert(value, forKey: key)
    }
    
    func removeValue(forKey key: CacheKeys)
    {
        guard let key = key as? Key
            else
        {
            return
        }
        
        wrapped.removeObject(forKey: WrappedKey(key))
    }
    
    func all() -> [Value?]
    {
        var values: [Value?] = []
        
        for key in keyTracker.keys
        {
            guard let key = key as? CacheKeys
            else
            {
                continue
            }
            
            values.append(self.value(forKey: key))
        }
        
        return values
    }
    
    var single: Value?
    {
        get
        {
            if self.all().count == 1,
               let key   = wrapped.name as? Key,
               let value = wrapped.object(forKey: WrappedKey(key)) as? Value
            {
                return value
            }
            else
            {
                return nil
            }
        }
    }
}

extension Cache.Entry: Codable where Key: Codable, Value: Codable {}

private extension Cache
{
    final class WrappedKey: NSObject
    {
        let key: Key

        init(_ key: Key) { self.key = key }

        override var hash: Int { return key.hashValue }

        override func isEqual(_ object: Any?) -> Bool
        {
            guard let value = object as? WrappedKey
                else
            {
                return false
            }

            return value.key == key
        }
    }
}

private extension Cache
{
    final class Entry
    {
        let key:            Key
        let value:          Value
        let expirationDate: Date

        init(key: Key, value: Value, expirationDate: Date)
        {
            self.key            = key
            self.value          = value
            self.expirationDate = expirationDate
        }
    }
}

extension Cache
{
    subscript(key: CacheKeys) -> Value?
    {
        get { return value(forKey: key) }
    
        set {
            guard let value = newValue
                else
            {
                // If nil was assigned using our subscript,
                // then we remove any value for that key:
                removeValue(forKey: key)
                return
            }
            
            insert(value, forKey: key)
        }
    }
}

private extension Cache
{
    final class KeyTracker: NSObject, NSCacheDelegate
    {
        var keys = Set<Key>()

        func cache(_ cache: NSCache<AnyObject, AnyObject>,
                   willEvictObject object: Any
        ) {
            guard let entry = object as? Entry
                else
            {
                return
            }

            keys.remove(entry.key)
        }
    }
}

private extension Cache
{
    func entry(forKey key: Key) -> Entry?
    {
        guard let entry = wrapped.object(forKey: WrappedKey(key))
            else
        {
            return nil
        }

        guard dateProvider() < entry.expirationDate
            else
        {
            guard let key = key as? CacheKeys
            else
            {
                return nil
            }
            
            removeValue(forKey: key)
            return nil
        }

        return entry
    }

    func insert(_ entry: Entry)
    {
        wrapped.setObject(entry, forKey: WrappedKey(entry.key))
        keyTracker.keys.insert(entry.key)
    }
}

extension Cache : Codable where Key : Codable, Value : Codable
{
    convenience init(from decoder: Decoder) throws
    {
        self.init()

        let container = try decoder.singleValueContainer()
        let entries   = try container.decode([Entry].self)
    
        entries.forEach(insert)
    }

    func encode(to encoder: Encoder) throws
    {
        var container = encoder.singleValueContainer()
        try container.encode(keyTracker.keys.compactMap(entry))
    }
}

extension Cache where Key : Codable, Value : Codable
{
    func saveToDisk(
        withName name: String,
        using fileManager: FileManager = .default
    )
    throws
    {
        let folderURLs = fileManager.urls(
            for: .cachesDirectory,
            in: .userDomainMask
        )

        let fileURL = folderURLs[0].appendingPathComponent(name + ".cache")
        let data = try JSONEncoder().encode(self)
        try data.write(to: fileURL)
    }
}

