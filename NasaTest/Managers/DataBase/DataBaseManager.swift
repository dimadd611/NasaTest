//
//  DataBaseManager.swift
//  NasaTest
//
//  Created by Дмитрий Рахманюк on 24.05.2025.
//

import Foundation
import UIKit
import CoreData

public final class DataBaseManager: NSObject {
    public static let shared = DataBaseManager()
    private override init() { }
    
    private var appDelegate: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }
    
    private var context: NSManagedObjectContext {
        appDelegate.persistentContainer.viewContext
    }
    
    public func createLaunch(launch: SpaceResponse) {
        guard let drawEntityDescription = NSEntityDescription.entity(forEntityName: "LaunchEntity", in: context) else {
            return
        }
        
        let item = LaunchEntity(entity: drawEntityDescription, insertInto: context)
        item.id = launch.id
        item.name = launch.name
        item.details = launch.details
        item.date = Int64(launch.dateUnix ?? 0)
        item.rocket = launch.rocket
        
        let encoder = JSONEncoder()
        
        do {
            item.links = try encoder.encode(launch.links)
            
            appDelegate.saveContext()
        } catch {
            print("❌ Ошибка кодирования: \(error)")
        }
    }
    
    public func fetchLaunches() -> [LaunchEntity] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LaunchEntity")
        do {
            return (try? context.fetch(fetchRequest) as? [LaunchEntity]) ?? []
        }
    }

    public func deleteLaunch(id: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LaunchEntity")
        do {
            guard let items = try? context.fetch(fetchRequest) as? [LaunchEntity],
                  let item = items.first(where:  {$0.id == id}) else { return }
            context.delete(item)
        }
        
        appDelegate.saveContext()
    }
}
