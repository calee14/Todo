//
//  CoreDataHelper.swift
//  Todo
//
//  Created by Cappillen on 7/6/18.
//  Copyright © 2018 MakeSchool. All rights reserved.
//

import Foundation
import UIKit
import CoreData

struct CoreDataHelper {
    static let context: NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError()
        }
        
        let persistentContainer = appDelegate.persistentContainer
        let context = persistentContainer.viewContext
        
        return context
        
    }()
    
    static func newTodo() -> Todo {
        let todo = NSEntityDescription.insertNewObject(forEntityName: "Todo", into: context) as! Todo
        
        return todo
    }
    
    static func saveTodo() {
        do {
            try context.save()
        } catch let error {
            print("Could not save \(error.localizedDescription)")
        }
    }
    
    static func deleteTodo(_ todo: Todo) {
        context.delete(todo)
        
        saveTodo()
    }
    
    static func retrieveTodos(completed: Bool) -> [Todo] {
        
        let fetchRequest = NSFetchRequest<Todo>(entityName: "Todo")
        let sort = NSSortDescriptor(key: #keyPath(Todo.modificationTime), ascending: false)
        fetchRequest.sortDescriptors = [sort]
        
        do {
            let results = try context.fetch(fetchRequest)
            var resultsFiltered = [Todo]()
            for i in results {
                if i.completed == completed {
                    resultsFiltered.append(i)
                }
            }
            return resultsFiltered
        } catch let error {
            print("Could not fetch \(error.localizedDescription)")
            return [Todo]()
        }
    }
}
