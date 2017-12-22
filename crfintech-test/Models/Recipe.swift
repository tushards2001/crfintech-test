//
//  Recipe.swift
//  crfintech-test
//
//  Created by MacBookPro on 12/22/17.
//  Copyright © 2017 basicdas. All rights reserved.
//

import UIKit

class Recipe: NSObject {
    
    var recipeName: String!
    var recipeDuration: Int!
    var image: String!
    let timeUnit: String = "Minutes"
    
    init(recipeName: String, recipeDuration: Int, image: String) {
        self.recipeName = recipeName
        self.recipeDuration = recipeDuration
        self.image = image
    }

    func durationString() -> String {
        return String(describing: self.recipeDuration!) + " " + self.timeUnit
    }
}
