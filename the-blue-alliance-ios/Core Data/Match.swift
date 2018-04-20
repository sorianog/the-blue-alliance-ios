//
//  Match.swift
//  the-blue-alliance-ios
//
//  Created by Zach Orr on 5/22/17.
//  Copyright © 2017 The Blue Alliance. All rights reserved.
//

import Foundation
import CoreData
import TBAClient

typealias Score = NSNumber

extension Match: Managed {
        
    var compLevelString: String {
        guard let compLevel = compLevel else {
            return ""
        }
        switch compLevel {
        case TBAMatch.TBACompLevel.qm.rawValue:
            return "Qualification"
        case TBAMatch.TBACompLevel.ef.rawValue:
            return "Octofinal"
        case TBAMatch.TBACompLevel.qf.rawValue:
            return "Quarterfinal"
        case TBAMatch.TBACompLevel.sf.rawValue:
            return "Semifinal"
        case TBAMatch.TBACompLevel.f.rawValue:
            return "Finals"
        default:
            return ""
        }
    }

    var shortCompLevelString: String {
        guard let compLevel = compLevel else {
            return ""
        }
        switch compLevel {
        case TBAMatch.TBACompLevel.qm.rawValue:
            return "Qual"
        case TBAMatch.TBACompLevel.ef.rawValue:
            return "Octofinal"
        case TBAMatch.TBACompLevel.qf.rawValue:
            return "Quarter"
        case TBAMatch.TBACompLevel.sf.rawValue:
            return "Semi"
        case TBAMatch.TBACompLevel.f.rawValue:
            return "Final"
        default:
            return ""
        }
    }
    
    var timeString: String? {
        guard let time = time else {
            return nil
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE h:mm a"
        
        let date = Date(timeIntervalSince1970: time.doubleValue)
        return dateFormatter.string(from: date)
    }
    
    static func insert(with model: TBAMatch, for event: Event, in context: NSManagedObjectContext) -> Match {
        return findOrCreate(in: context, with: model.key) { (match) in
            // Required: compLevel, eventKey, key, matchNumber, setNumber
            match.key = model.key
            match.compLevel = model.compLevel.rawValue

            match.setNumber = Int16(model.setNumber)
            match.matchNumber = Int16(model.matchNumber)
            
            if let redAlliance = model.alliances?.red {
                match.redTeamKeys = redAlliance.teamKeys
                // TODO: Think about this... beacuse this should be a UInt?
                match.redScore = Score(value: redAlliance.score)
                match.redSurrogateTeamKeys = redAlliance.surrogateTeamKeys
                match.redDQTeamKeys = redAlliance.dqTeamKeys
            }
            
            if let blueAlliance = model.alliances?.blue {
                match.blueTeamKeys = blueAlliance.teamKeys
                // TODO: Think about this... beacuse this should be a UInt?
                match.blueScore = Score(value: blueAlliance.score)
                match.blueSurrogateTeamKeys = blueAlliance.surrogateTeamKeys
                match.blueDQTeamKeys = blueAlliance.dqTeamKeys
            }
            
            match.winningAlliance = model.winningAlliance
            match.eventKey = model.eventKey
            if let time = model.time {
                match.time = NSNumber(value: time)
            }
            if let actualTime = model.actualTime {
                match.actualTime = NSNumber(value: actualTime)
            }
            if let predictedTime = model.predictedTime {
                match.predictedTime = NSNumber(value: predictedTime)
            }
            if let postResultTime = model.postResultTime {
                match.postResultTime = NSNumber(value: postResultTime)
            }
            
            if let breakdown = model.scoreBreakdown as? [String: Any] {
                if let blueBreakdown = breakdown["blue"] as? [String: Any] {
                    match.blueBreakdown = blueBreakdown
                }
                if let redBreakdown = breakdown["red"] as? [String: Any] {
                    match.redBreakdown = redBreakdown
                }
                
                // Add coopertition and coopertition points to breakdown in 2015
                if let coopertition = breakdown["coopertition"] as? String {
                    match.blueBreakdown?["coopertition"] = coopertition
                    match.redBreakdown?["coopertition"] = coopertition
                }
                if let coopertitionPoints = breakdown["coopertition_points"] as? Int {
                    match.blueBreakdown?["coopertition_points"] = coopertitionPoints
                    match.redBreakdown?["coopertition_points"] = coopertitionPoints
                }
            }

            if let videos = model.videos {
                match.videos = Set(videos.map({ (modelVideo) -> MatchVideo in
                    return MatchVideo.insert(with: modelVideo, in: context)
                })) as NSSet
            }
        }
    }

    public func friendlyMatchName() -> String {
        guard let compLevel = compLevel else {
            return ""
        }
        
        let matchName = shortCompLevelString
        
        switch compLevel {
        case TBAMatch.TBACompLevel.qm.rawValue:
            return "\(matchName) \(matchNumber)"
        case TBAMatch.TBACompLevel.ef.rawValue,
             TBAMatch.TBACompLevel.qf.rawValue,
             TBAMatch.TBACompLevel.sf.rawValue,
             TBAMatch.TBACompLevel.f.rawValue:
            return "\(matchName) \(setNumber) - \(matchNumber)"

        default:
            return matchName
        }
    }
    
}
