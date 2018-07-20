//
//  image+Convenience.swift
//  Stuffy
//
//  Created by Hayden Murdock on 7/11/18.
//  Copyright © 2018 Adam Moskovich. All rights reserved.
//

import Foundation
import CoreData

extension ImageCD {
    convenience init(image: Data, item: ItemCD, context:  NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.image = image
        self.item = item
    }
}
