//
//  DatabaseRestaurantServiceImp.swift
//  Eatery
//
//  Created by João Palma on 21/11/2020.
//

import UIKit
import CoreData

final class RestaurantDatabaseServiceImp: RestaurantDatabaseService {
    private let _restaurantEntity = "RestaurantData"
    private var _managedContext: NSManagedObjectContext!
    
    init() {
        _setManagerContext()
    }
    
    private func _setManagerContext() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        _managedContext = appDelegate?.persistentContainer.viewContext
    }
    
    func getFavorites() -> [Favorite] {
        let fetchRequest = NSFetchRequest<RestaurantData>(entityName: _restaurantEntity)
        
        do {
            let restaurants = try _managedContext.fetch(fetchRequest)
            
            return restaurants.map { restaurant -> Favorite in Favorite(restaurant) }
        } catch let error {
            print( "Could not retrieve favortes. Error \(error)")
            _managedContext.rollback()
            return []
        }
    }
    
    func saveFavorite(_ restaurant: RestaurantDataDBO) {
        let restaurantEntity = NSEntityDescription.entity(forEntityName: _restaurantEntity, in: _managedContext)!
        let restaurantData = RestaurantData(entity: restaurantEntity, insertInto: _managedContext)
        
        _save(restaurantData, restaurant)
    }
    
    private func _save(_ restaurantData: RestaurantData, _ restaurant: RestaurantDataDBO) {
        restaurantData.fillData(with: restaurant)
        
        do {
            try _managedContext.save()
        } catch let error {
            _managedContext.rollback()
            print("Could not save data: \(restaurantData) to database with values: \(restaurant). Error: \(error)")
        }
    }
    
    func removeFavorite(_ resturantId: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: _restaurantEntity)
        fetchRequest.predicate = NSPredicate(format: "id == %@", resturantId)
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try _managedContext.execute(deleteRequest)
        } catch let error {
            _managedContext.rollback()
            print("Could not execute \(deleteRequest). Error: \(error)")
        }
    }
}
