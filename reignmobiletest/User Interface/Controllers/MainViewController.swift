//
//  MainViewController.swift
//  reignmobiletest
//
//  Created by Diego Alfaro Vives on 8/26/21.
//  Copyright © 2021 Diego Alfaro. All rights reserved.
//

import UIKit
import SafariServices

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //UI Controls
    @IBOutlet weak var vLoading: UIView!
    @IBOutlet weak var tblEntries: UITableView!
    
    //Attributes
    let cellSize: CGFloat = 75.0
    var entries: [Entry] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tblEntries.register(UINib(nibName: "EntryCell", bundle: nil), forCellReuseIdentifier: "entryCell")
        loadData()
    }
    
    //Data Methods
    func loadData() {
        EntryLogic.getEntries { result in
            if result.count > 0 {
                self.vLoading.isHidden = true
                self.entries = result

                self.tblEntries.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                self.tblEntries.reloadData()
            } else {
                DialogHelper.showOKDialog(viewController: self, message: "No Data Found")
            }
        }
    }
    
    //TableViewDataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let entry = entries[indexPath.row]
        return CellFactory.getEntryCell(tableView: tableView, indexPath: indexPath, entry: entry)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entry = entries[indexPath.row]
            EntryLogic.deleteEntry(id: entry.id!)
            
            entries.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .top)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellSize
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let entry = entries[indexPath.row]
        
        if let url = URL(string: entry.url!) {
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true) { }
        } else {
            DialogHelper.showOKDialog(viewController: self, message: "Story URL not found")
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if (tblEntries.contentOffset.y <= cellSize) {
            tblEntries.contentInset = UIEdgeInsets(top: cellSize / 2, left: 0, bottom: 0, right: 0)
            loadData()
        }
    }
}
