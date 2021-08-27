//
//  EntryCell.swift
//  reignmobiletest
//
//  Created by Diego Alfaro Vives on 8/26/21.
//  Copyright © 2021 Diego Alfaro. All rights reserved.
//

import UIKit

class EntryCell: UITableViewCell {
    
    //UI Controls
    @IBOutlet weak var lblEntryTitle: UILabel!
    @IBOutlet weak var lblEntrySubtitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
