//
//  Webcast.swift
//  the-blue-alliance-ios
//
//  Created by Zach Orr on 3/17/17.
//  Copyright © 2017 The Blue Alliance. All rights reserved.
//

import Foundation
import CoreData
import TBAClient

extension Webcast: Managed {
    
    static func insert(with model: TBAWebcast, for event: Event, in context: NSManagedObjectContext) -> Webcast {
        let predicate = NSPredicate(format: "event == %@ AND type == %@ AND channel == %@", event, model.type.rawValue, model.channel)
        return findOrCreate(in: context, matching: predicate, configure: { (webcast) in
            // Required: channel, type
            webcast.type = model.type.rawValue
            webcast.channel = model.channel
            webcast.file = model.file
            // TODO: Think about changing this in to a key?
            webcast.event = event
        })
    }
    
}
