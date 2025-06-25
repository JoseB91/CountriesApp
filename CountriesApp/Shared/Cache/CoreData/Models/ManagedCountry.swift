//
//  ManagedCountry.swift
//  CountriesApp
//
//  Created by José Briones on 23/6/25.
//

import CoreData

@objc(ManagedCountry)
class ManagedCountry: NSManagedObject {
    @NSManaged var commonName: String
    @NSManaged var officialName: String
    @NSManaged var capital: String
    @NSManaged var flagURL: URL
    @NSManaged var isBookmarked: Bool
    @NSManaged var data: Data?
    @NSManaged var cache: ManagedCache
}

extension ManagedCountry {
    static func getImageData(with url: URL, in context: NSManagedObjectContext) throws -> Data? {
        if let cachedData = URLImageCache.shared.getImageData(for: url) {
            return cachedData
        }
        
        if let country = try getCountry(with: url, in: context), let imageData = country.data {
            URLImageCache.shared.setImageData(imageData, for: url)
            return imageData
        }
        
        return nil
    }
    
    static func getCountry(with url: URL, in context: NSManagedObjectContext) throws -> ManagedCountry? {
        let request = NSFetchRequest<ManagedCountry>(entityName: entity().name!)
        request.predicate = NSPredicate(format: "%K = %@", argumentArray: [#keyPath(ManagedCountry.flagURL), url])
        request.fetchLimit = 1
        return try context.fetch(request).first
    }
    
    static func fetchCountries(from localCountries: [LocalCountry], in context: NSManagedObjectContext) -> NSSet {
        let set = NSSet(array: localCountries.map { local in
            let managedCountry = ManagedCountry(context: context)
            managedCountry.commonName = local.commonName
            managedCountry.officialName = local.officialName
            managedCountry.capital = local.capital
            if let flagURL = local.flagURL {
                managedCountry.flagURL = flagURL
                if let cachedData = URLImageCache.shared.getImageData(for: flagURL) {
                    managedCountry.data = cachedData
                }
            }
            managedCountry.isBookmarked = local.isBookmarked

            return managedCountry
        })
        return set
    }
        
    var local: LocalCountry {
        return LocalCountry(commonName: commonName,
                            officialName: officialName,
                            capital: capital,
                            flagURL: flagURL,
                            isBookmarked: isBookmarked)
    }
}

