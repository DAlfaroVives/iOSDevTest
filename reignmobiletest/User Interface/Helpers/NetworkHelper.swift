//
//  NetworkHelper.swift
//  reignmobiletest
//
//  Created by Diego Alfaro Vives on 8/26/21.
//  Copyright © 2021 Diego Alfaro. All rights reserved.
//

import UIKit
import Reachability

class NetworkHelper: NSObject {
    static func ifReachable(completion: @escaping (_ result: Bool) -> Void) {
        do {
            let reachability = try Reachability()
            try reachability.startNotifier()
            
            if reachability.connection != Reachability.Connection.unavailable {
                completion(true)
            } else {
                completion(false)
            }
            
            reachability.stopNotifier()
        } catch {
            print("Unable to start notifier")
            completion(false)
        }
    }
}
