//
//  DatabaseRestaurantServiceImp.swift
//  Eatery
//
//  Created by João Palma on 21/11/2020.
//

import UIKit
import CoreData

class RestaurantDatabaseServiceImp: RestaurantDatabaseService {
    private let _restaurantEntity = "RestaurantData"
    
    private var _managedContext: NSManagedObjectContext!
    private var _fetchRequest : NSFetchRequest<NSFetchRequestResult> {
        NSFetchRequest<NSFetchRequestResult>(entityName: _restaurantEntity)
    }
    
    init() {
        _setManagerContext()
    }
    
    private func _setManagerContext() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        _managedContext = appDelegate?.persistentContainer.viewContext
    }
    
    func getFavorites() -> [RestaurantDBObject] {
        do {
            let result = try _managedContext.fetch(_fetchRequest)
            
            guard let restaurantData = result as? [RestaurantData] else { return [] }
            
            let restaurants = restaurantData.map {
                RestaurantDBObject(data: $0)
            }
            
            return restaurants
        } catch let error {
            print( "Could not retrieve favortes. Error \(error)")
            return []
        }
    }
    
    func saveFavorite(_ restaurant: RestaurantDBObject) {
        let restaurantEntity = NSEntityDescription.entity(forEntityName: _restaurantEntity, in: _managedContext)!
        let restaurantData = RestaurantData(entity: restaurantEntity, insertInto: _managedContext)
        
        _save(restaurantData, restaurant)
    }
    
    private func _save(_ restaurantData: RestaurantData, _ restaurant: RestaurantDBObject) {
        restaurantData.setValue(restaurant.id, forKey: String(describing: "id"))
        restaurantData.setValue(restaurant.name, forKey: String(describing: "name"))
        restaurantData.setValue(restaurant.cousine, forKey: String(describing: "cousine"))
        restaurantData.setValue(restaurant.priceRange, forKey: String(describing: "priceRange"))
        restaurantData.setValue(restaurant.rating, forKey: String(describing: "rating"))
        restaurantData.setValue(restaurant.lat, forKey: String(describing: "lat"))
        restaurantData.setValue(restaurant.long, forKey: String(describing: "long"))
        restaurantData.setValue(restaurant.timings, forKey: String(describing: "timings"))
        restaurantData.setValue(restaurant.image, forKey: String(describing: "image"))
        
        do {
            try _managedContext.save()
        } catch let error {
            print("Could not save data: \(restaurantData) to database with values: \(restaurant). Error: \(error)")
        }
    }
    
    func removeFavorite(_ resturantId: String) {
        let fetchRequest = _fetchRequest
        fetchRequest.predicate = NSPredicate(format: "id == \(resturantId)", resturantId)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try _managedContext.execute(deleteRequest)
        } catch let error {
            print("Could not execute \(deleteRequest). Error: \(error)")
        }
    }
}
