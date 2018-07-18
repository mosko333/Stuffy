//
//  User+Convenience.swift
//  Stuffy
//
//  Created by Hayden Murdock on 7/9/18.
//  Copyright © 2018 Adam Moskovich. All rights reserved.
//

import Foundation
import CoreData

extension User {
    convenience init(pin: String, currency: String, context:  NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.pin = pin
        self.currency = currency
    }
}
