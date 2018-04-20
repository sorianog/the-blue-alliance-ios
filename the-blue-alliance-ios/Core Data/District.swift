//
//  District.swift
//  the-blue-alliance-ios
//
//  Created by Zach Orr on 3/13/17.
//  Copyright © 2017 The Blue Alliance. All rights reserved.
//

import Foundation
import CoreData
import TBAClient

extension District: Managed {
    
    static func insert(with model: TBADistrictList, in context: NSManagedObjectContext) -> District {
        return findOrCreate(in: context, with: model.key, configure: { (district) in
            // Required: key, name, year, abbreviation
            district.abbreviation = model.abbreviation
            district.name = model.displayName
            district.key = model.key
            district.year = Int16(model.year)
        })
    }
    
}
