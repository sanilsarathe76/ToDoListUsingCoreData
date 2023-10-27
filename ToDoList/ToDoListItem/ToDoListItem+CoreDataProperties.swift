//
//  ToDoListItem+CoreDataProperties.swift
//  ToDoList
//
//  Created by MacBook27 on 25/10/23.
//
//

import Foundation
import CoreData


extension ToDoListItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoListItem> {
        return NSFetchRequest<ToDoListItem>(entityName: "ToDoListItem")
    }

    @NSManaged public var name: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var id: UUID?
}

extension ToDoListItem : Identifiable {
    
}
