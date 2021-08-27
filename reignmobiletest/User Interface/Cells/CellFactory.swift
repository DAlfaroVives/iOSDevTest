//
//  CellFactory.swift
//  reignmobiletest
//
//  Created by Diego Alfaro Vives on 8/26/21.
//  Copyright © 2021 Diego Alfaro. All rights reserved.
//

import UIKit

class CellFactory: NSObject {
    
    static func getEntryCell(tableView: UITableView, indexPath: IndexPath, entry: Entry) -> UITableViewCell {
        if let cell: EntryCell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath)  as? EntryCell {
            let timeSince = Date.timeElapsed(from: entry.created_at!)
             
            cell.lblEntryTitle.text = entry.title!
            cell.lblEntrySubtitle.text = "\(entry.author ?? "") - \(timeSince)"
            
            cell.selectionStyle = .none
            
            return cell
        }
        
        return UITableViewCell()
    }

}
