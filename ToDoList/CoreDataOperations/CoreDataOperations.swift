//
//  CoreDataOperations.swift
//  ToDoList
//
//  Created by MacBook27 on 26/10/23.
//

import Foundation
import CoreData
import UIKit

protocol CoreDataOperationsDelegate: AnyObject {
    func passData(data: [ToDoListItem])
    func reloadData(id: UUID)
}

class CoreDataOperations {
    
    let context = CoreDataBaseManager.shared.persistentContainer.viewContext
    weak var delegate: CoreDataOperationsDelegate?
    
    static let shared = CoreDataOperations()
    
    private init() {
        
    }
    
    var models = [ToDoListItem]()
    
    func getAllItems() {
        do {
            models = try context.fetch(ToDoListItem.fetchRequest())
            delegate?.passData(data: models)
        } catch let error {
            print(error)
        }
    }
    
    func createItem(name: String) {
        let newItem = ToDoListItem(context: context)
        let currentDate = Date()
        newItem.name = name
        newItem.createdAt = currentDate
        
        do {
            try context.save()
            getAllItems()
        } catch let error {
            print(error)
        }
    }
    
    func deleteItem(item: ToDoListItem) {
        context.delete(item)
        delegate?.reloadData(id: item.id ?? UUID())
        do {
            try context.save()
        } catch let error {
            print(error)
        }
    }
    
    func updateItem(item: ToDoListItem, newName: String) {
        item.name = newName
        delegate?.reloadData(id: UUID())
        do {
            try context.save()
        } catch let error {
            print(error)
        }
    }
}
