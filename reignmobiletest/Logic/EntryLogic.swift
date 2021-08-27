//
//  EntryLogic.swift
//  reignmobiletest
//
//  Created by Diego Alfaro Vives on 8/26/21.
//  Copyright © 2021 Diego Alfaro. All rights reserved.
//

import UIKit

class EntryLogic: NSObject {
    private static func getEntriesFromCoreData() -> [Entry] {
        var entries = Entry.get()
        entries.sort { (a, b) -> Bool in
            return a.created_at! > b.created_at!
        }
        
        return entries
    }
    
    static func getEntriesFromServer(completion: @escaping (_ result: [Entry]) -> Void) {
        EntryNetworking.getEntries { jsonResult in
            if jsonResult != nil {
                Entry.clear()
                
                for item in jsonResult!.array! {
                    Entry.save(jsonObject: item)
                }
                
                completion(getEntriesFromCoreData())
            } else {
                completion([])
            }
        }
    }
    
    static func getEntries(completion: @escaping (_ result: [Entry]) -> Void) {
        //1. Try loading from server, then save in CoreData
        //2. If server not reachable, try loading from CoreData
        //3. If CoreData is empty, show message: No Data Found
        //4. If data exists (Server or CoreData), reload TableView in Main Thread
        
        NetworkHelper.ifReachable { isOnline in
            if isOnline {
                getEntriesFromServer { result in
                    completion(result)
                }
            } else {
                let entries = getEntriesFromCoreData()
                completion(entries)
            }
        }
    }
    
    static func deleteEntry(id: String) {
        Entry.delete(id: id)
    }
}
