//
//  EntryNetworking.swift
//  reignmobiletest
//
//  Created by Diego Alfaro Vives on 8/26/21.
//  Copyright © 2021 Diego Alfaro. All rights reserved.
//

import UIKit
import Alamofire
import Alamofire_SwiftyJSON
import SwiftyJSON

class EntryNetworking: NSObject {
    static func getEntries(completion: @escaping (_ result: JSON?) -> Void) {
        let apiUrl = "https://hn.algolia.com/api/v1/search_by_date?query=mobile"
        
        Alamofire.request(apiUrl, method: .get, parameters: nil,
                          encoding: JSONEncoding.default, headers: nil).responseSwiftyJSON { (response) in
                            
                            if response.result.isSuccess {
                                let jsonResponse = JSON(response.result.value!)
                                let jsonData = jsonResponse["hits"]
                                completion(jsonData)
                            } else {
                                completion([])
                            }
        }
    }
}
