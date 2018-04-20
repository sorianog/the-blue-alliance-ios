//
//  Award.swift
//  the-blue-alliance-ios
//
//  Created by Zach Orr on 5/17/17.
//  Copyright © 2017 The Blue Alliance. All rights reserved.
//

import Foundation
import CoreData
import TBAClient

extension Award: Managed {
    
    static func insert(with model: TBAAward, in context: NSManagedObjectContext) -> Award {
        let predicate = NSPredicate(format: "awardType == %ld && year == %ld && eventKey == %@", model.awardType, model.year, model.eventKey)
        return findOrCreate(in: context, matching: predicate) { (award) in
            // Required: awardType, event, name, year, recipientList
            award.name = model.name
            award.awardType = Int16(model.awardType)
            award.eventKey = model.eventKey
            award.year = Int16(model.year)
            
            award.recipients = Set(model.recipientList.map({ (modelAwardRecipient) -> AwardRecipient in
                return AwardRecipient.insert(with: modelAwardRecipient, for: award, in: context)
            })) as NSSet
        }
    }

}


extension AwardRecipient: Managed {
    
    static func insert(with model: TBAAwardRecipient, for award: Award, in context: NSManagedObjectContext) -> AwardRecipient {
        var predicate: NSPredicate?
        var team: Team?
        if let awardee = model.awardee, let teamKey = model.teamKey {
            // TODO: Use findOrCreate, instead of doing a fetch then create
            team = Team.findOrFetch(in: context, matching: NSPredicate(format: "key == %@", teamKey))
            if team == nil {
                team = Team.insert(with: teamKey, in: context)
            }
            predicate = NSPredicate(format: "awardee == %@ AND award == %@ AND team == %@", awardee, award, team!)
        } else if let teamKey = model.teamKey {
            // TODO: Use findOrCreate, instead of doing a fetch then create
            team = Team.findOrFetch(in: context, matching: NSPredicate(format: "key == %@", teamKey))
            if team == nil {
                team = Team.insert(with: teamKey, in: context)
            }
            predicate = NSPredicate(format: "team == %@ AND award == %@", team!, award)
        } else if let awardee = model.awardee {
            predicate = NSPredicate(format: "awardee == %@ AND award == %@", awardee, award)
        } else {
            fatalError("Award has no info")
        }

        return findOrCreate(in: context, matching: predicate!) { (awardRecipient) in
            awardRecipient.team = team
            awardRecipient.awardee = model.awardee
            awardRecipient.award = award
        }
    }
    
    public var awardText: [String] {
        var awardText: [String] = []
        if let team = team, let awardee = awardee {
            awardText.append(awardee)
            awardText.append(team.nickname ?? team.fallbackNickname)
        } else if let team = team {
            if team.nickname != nil {
                awardText.append("\(team.teamNumber)")
            }
            awardText.append(team.nickname ?? team.fallbackNickname)
        } else if let awardee = awardee {
            awardText.append(awardee)
        }
        return awardText
    }
    
}
