//
//  MatchVideo.swift
//  the-blue-alliance-ios
//
//  Created by Zach Orr on 4/19/18.
//  Copyright © 2018 The Blue Alliance. All rights reserved.
//

import Foundation

import Foundation
import CoreData
import TBAClient

extension MatchVideo: Managed {
    
    static func insert(with model: TBAMatchVideos, in context: NSManagedObjectContext) -> MatchVideo {
        guard let videoKey = model.key else {
            fatalError("TBAMatchVideo needs a key when inserting")
        }

        return findOrCreate(in: context, with: videoKey) { (matchVideo) in
            matchVideo.key = model.key
            matchVideo.type = model.type
        }
    }
    
    // TODO: Add method to get URL for these videos
    
}
