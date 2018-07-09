//
//  Category+Convience.swift
//  Stuffy
//
//  Created by Hayden Murdock on 7/6/18.
//  Copyright © 2018 Adam Moskovich. All rights reserved.
//

import Foundation
import CoreData

extension CategoryCD {
    convenience init (name: String, isFavorited: Bool, context:  NSManagedObjectContext = CoreDataStack.context) {
           self.init(context: context)
        self.name = name
        self.isFavorited = isFavorited
    }
}
