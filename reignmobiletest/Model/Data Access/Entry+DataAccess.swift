//
//  Entry+DataAccess.swift
//  reignmobiletest
//
//  Created by Diego Alfaro Vives on 8/26/21.
//  Copyright © 2021 Diego Alfaro. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreData

extension Entry {
    static func get() -> [Entry] {
        var entries = [Entry]()
        
        let context = Storage.shared.context
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Entry")
        request.predicate = NSPredicate(format: "visible = %@", NSNumber(value: true))
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                entries.append(data as! Entry)
            }
        } catch {
            print("Failed get Entry")
        }
        
        return entries
    }
    
    static func get(id: String) -> Entry? {
        var entry: Entry? = nil
        
        let context = Storage.shared.context
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Entry")
        request.predicate = NSPredicate(format: "id = %@", id)
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [Entry] {
                entry = data
            }
        } catch {
            print("Failed get Entry")
        }
        
        return entry
    }
    
    static func save(jsonObject: JSON) {
        if (jsonObject == JSON.null) {
            return
        }
        
        var id = ""
        if let storyId = jsonObject["story_id"].int {
            id = "\(storyId)"
        } else {
            if let objectid = jsonObject["objectID"].string {
                id = "\(objectid)"
            }
        }
        
        if get(id: id) != nil {
            return
        }
        
        let context = Storage.shared.context
        let entity = NSEntityDescription.entity(forEntityName: "Entry", in: context)
        
        let newData = NSManagedObject(entity: entity!, insertInto: context)
        
        newData.setValue("\(id)", forKey: "id")
        
        if let storyTitle = jsonObject["story_title"].string {
            newData.setValue("\(storyTitle)", forKey: "title")
        } else {
            if let title = jsonObject["title"].string {
                newData.setValue("\(title)", forKey: "title")
            } else {
                newData.setValue("Title not found", forKey: "title")
            }
        }
        
        if let storyUrl = jsonObject["story_url"].string {
            newData.setValue("\(storyUrl)", forKey: "url")
        } else {
            if let url = jsonObject["url"].string {
                newData.setValue("\(url)", forKey: "url")
            } else {
                newData.setValue("", forKey: "url")
            }
        }
        
        let createdAt = Date.fromServerDateString(dateString: "\(jsonObject["created_at"].string!)")
        
        newData.setValue(createdAt, forKey: "created_at")
        newData.setValue("\(jsonObject["author"].string!)", forKey: "author")
        
        newData.setValue(true, forKey: "visible")
        
        do {
            try context.save()
        } catch {
            print("Failed saving Entry")
        }
    }
    
    static func clear() {
        let context = Storage.shared.context
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Entry")
        request.predicate = NSPredicate(format: "visible = %@", NSNumber(value: true))
        
        if let result = try? context.fetch(request) {
            for object in result as! [NSManagedObject] {
                context.delete(object)
            }
        }
    }
    
    static func delete(id: String) {
        let context = Storage.shared.context
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Entry")
        request.predicate = NSPredicate(format: "id = %@", id)
        
        if let result = try? context.fetch(request) {
            for object in result as! [NSManagedObject] {
                object.setValue(false, forKey: "visible")
            }
        }
        
        do {
            try context.save()
        } catch {
            print("Failed updating Entry")
        }
    }
}
