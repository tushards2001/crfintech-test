//
//  Recipes+CoreDataProperties.swift
//  crfintech-test
//
//  Created by MacBookPro on 12/22/17.
//  Copyright © 2017 basicdas. All rights reserved.
//
//

import Foundation
import CoreData


extension Recipes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recipes> {
        return NSFetchRequest<Recipes>(entityName: "Recipes")
    }

    @NSManaged public var recipeName: String?
    @NSManaged public var recipeDuration: Int16
    @NSManaged public var image: String?

}
