//
//  Team.swift
//  the-blue-alliance-ios
//
//  Created by Zach Orr on 5/12/17.
//  Copyright © 2017 The Blue Alliance. All rights reserved.
//

import Foundation
import CoreData
import TBAClient

extension Team: Locatable, Managed {
    
    var fallbackNickname: String {
        return "Team \(teamNumber)"
    }
    
    static func teamNumberFrom(key: String) -> Int32 {
        // TODO: Do a little work here eh
        return Int32(key.prefixTrim("frc"))!
    }
    
    static func insert(with key: String, in context: NSManagedObjectContext) -> Team {
        // Let's not *overwrite* shit we already have
        if let team = findOrFetch(in: context, with: key) {
            return team
        }
        return findOrCreate(in: context, with: key) { (team) in
            // Required: key, name, teamNumber
            team.key = key
            
            let teamNumber = teamNumberFrom(key: key)
            team.name = "Team \(teamNumber)"
            team.teamNumber = teamNumber
        }
    }
    
    static func insert(with model: TBATeam, in context: NSManagedObjectContext) -> Team {
        return findOrCreate(in: context, with: model.key) { (team) in
            // Required: key, name, teamNumber, rookieYear
            team.key = model.key
            team.teamNumber = Int32(model.teamNumber)
            team.nickname = model.nickname
            team.name = model.name
            
            team.city = model.city
            team.state = model.stateProv
            team.country = model.country
            team.address = model.address
            team.postalCode = model.postalCode
            team.gmapsPlaceID = model.gmapsPlaceId
            team.gmapsURL = model.gmapsUrl
            
            if let lat = model.lat {
                team.lat = NSNumber(value: lat)
            }
            if let lng = model.lng {
                team.lng = NSNumber(value: lng)
            }
            team.locationName = model.locationName

            team.website = model.website
            team.rookieYear = Int16(model.rookieYear)
            team.motto = model.motto
            // TODO: Pretty sure this is broken further down in Alamo Fire... fix it
            team.homeChampionship = model.homeChampionship as? [String: String]
        }
    }
    
    static func fetchAllTeams(pageFinished: @escaping ([TBATeam]) -> (), completion: @escaping (Error?) -> ()) {
        return fetchAllTeams(pageFinished: pageFinished, page: 0, completion: completion)
    }
    
    static private func fetchAllTeams(pageFinished: @escaping ([TBATeam]) -> (), page: Int, completion: @escaping (Error?) -> ()) {
        TeamAPI.getTeams(pageNum: page) { (teams, error) in
            if let error = error {
                completion(error)
                return
            }
            
            guard let teams = teams else {
                completion(APIError.error("No teams for page \(page)"))
                return
            }
            
            if teams.isEmpty {
                completion(nil)
            } else {
                pageFinished(teams)
                self.fetchAllTeams(pageFinished: pageFinished, page: page + 1, completion: completion)
            }
        }
    }
    
}
