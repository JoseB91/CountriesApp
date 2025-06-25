//
//  ManagedCache.swift
//  CountriesApp
//
//  Created by José Briones on 23/6/25.
//

import CoreData

@objc(ManagedCache)
class ManagedCache: NSManagedObject {
    @NSManaged var timestamp: Date
    @NSManaged var countries: NSSet
}

extension ManagedCache {
    static func find(in context: NSManagedObjectContext) throws -> ManagedCache? {
        let request = NSFetchRequest<ManagedCache>(entityName: entity().name!)
        return try context.fetch(request).first
    }
    
    static func deleteCache(in context: NSManagedObjectContext) throws {
        try find(in: context).map(context.delete).map(context.save)
    }
    
    static func newUniqueInstance(in context: NSManagedObjectContext) throws -> ManagedCache {
        try deleteCache(in: context)
        return ManagedCache(context: context)
    }
    
    static func cacheExists(in context: NSManagedObjectContext) throws -> Bool {
        try find(in: context) != nil
    }
            
    var localCountries: [LocalCountry] {
        let sortedCountries = countries
            .compactMap { $0 as? ManagedCountry }
            .sorted { $0.commonName < $1.commonName }
        return sortedCountries.map { $0.local }
    }
}
