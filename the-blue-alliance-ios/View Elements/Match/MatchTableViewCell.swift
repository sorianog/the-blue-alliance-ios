//
//  MatchTableViewCell.swift
//  the-blue-alliance-ios
//
//  Created by Zach Orr on 5/22/17.
//  Copyright © 2017 The Blue Alliance. All rights reserved.
//

import Foundation
import UIKit
import TBAClient

class MatchTableViewCell: UITableViewCell {
    static let reuseIdentifier = "MatchCell"
    public var match: Match? {
        didSet {
            configureCell()
        }
    }
    public var team: Team? {
        didSet {
            if match != nil {
                configureCell()
            }
        }
    }
    let winnerFont = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)
    let notWinnerFont = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
    
    @IBOutlet private var matchNumberLabel: UILabel!
    
    @IBOutlet private var redStackView: UIStackView!
    @IBOutlet private var redContainerView: UIView!
    @IBOutlet private var redScoreLabel: UILabel!

    @IBOutlet private var blueStackView: UIStackView!
    @IBOutlet private var blueContainerView: UIView!
    @IBOutlet private var blueScoreLabel: UILabel!
    
    @IBOutlet private var timeLabel: UILabel!
    @IBOutlet private var playIconImageView: UIImageView!

    private var coloredViews: [UIView] {
        return [redContainerView, redScoreLabel, blueContainerView, blueScoreLabel, timeLabel]
    }
    
    override func awakeFromNib() {
        redContainerView.layer.borderColor = UIColor.red.cgColor
        blueContainerView.layer.borderColor = UIColor.blue.cgColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        let colors = storeBaseColors(for: coloredViews)
        super.setSelected(selected, animated: animated)
        
        if selected {
            restoreBaseColors(colors, for: coloredViews)
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let colors = storeBaseColors(for: coloredViews)
        super.setHighlighted(highlighted, animated: animated)
        
        if highlighted {
            restoreBaseColors(colors, for: coloredViews)
        }
    }
    
    // TODO: This method has TERRIBLE threading issues...
    private func configureCell() {
        matchNumberLabel.text = match?.friendlyMatchName()
        playIconImageView.isHidden = (match?.videos?.count == 0)
        
        for view in redStackView.arrangedSubviews {
            if view == redScoreLabel {
                continue
            }
            view.removeFromSuperview()
        }
        
        for teamKey in (match?.redTeamKeys?.reversed() ?? []) {
            let teamLabel = MatchTableViewCell.label(for: teamKey, baseTeamKey: team?.key)
            redStackView.insertArrangedSubview(teamLabel, at: 0)
        }
        redScoreLabel.text = match?.redScore?.stringValue
        
        for view in blueStackView.arrangedSubviews {
            if view == blueScoreLabel {
                continue
            }
            view.removeFromSuperview()
        }
        
        for teamKey in (match?.blueTeamKeys?.reversed() ?? []) {
            let teamLabel = MatchTableViewCell.label(for: teamKey, baseTeamKey: team?.key)
            blueStackView.insertArrangedSubview(teamLabel, at: 0)
        }
        blueScoreLabel.text = match?.blueScore?.stringValue

        if match?.blueScore == nil && match?.redScore == nil {
            timeLabel.isHidden = false
            
            if let timeString = match?.timeString {
                timeLabel.text = timeString
            } else {
                timeLabel.text = "No Time Yet"
            }
        } else {
            timeLabel.isHidden = true
        }

        let matchYearString = match?.eventKey!.prefix(4)
        
        // Everyone is a winner in 2015 ╮ (. ❛ ᴗ ❛.) ╭
        if matchYearString == "2015", match!.compLevel != TBAMatch.TBACompLevel.f.rawValue {
            redContainerView.layer.borderWidth = 0.0
            blueContainerView.layer.borderWidth = 0.0
            
            redScoreLabel.font = notWinnerFont
            blueScoreLabel.font = notWinnerFont
        } else if match?.winningAlliance == "red" {
            redContainerView.layer.borderWidth = 2.0
            blueContainerView.layer.borderWidth = 0.0
            
            redScoreLabel.font = winnerFont
            blueScoreLabel.font = notWinnerFont
        } else if match?.winningAlliance == "blue" {
            blueContainerView.layer.borderWidth = 2.0
            redContainerView.layer.borderWidth = 0.0
            
            redScoreLabel.font = notWinnerFont
            blueScoreLabel.font = winnerFont
        } else {
            redContainerView.layer.borderWidth = 0.0
            blueContainerView.layer.borderWidth = 0.0
            
            redScoreLabel.font = notWinnerFont
            blueScoreLabel.font = notWinnerFont
        }
    }
    
    public static func label(for teamKey: String, baseTeamKey: String?) -> UILabel {
        let label = UILabel()
        label.text = "\(Team.teamNumberFrom(key: teamKey))"
        var font: UIFont = .systemFont(ofSize: 14)
        if teamKey == baseTeamKey {
            font = .boldSystemFont(ofSize: 14)
        }
        label.font = font
        label.textAlignment = .center
        return label
    }

    func storeBaseColors(for views: [UIView]) -> [UIColor] {
        var colors: [UIColor] = []
        for view in views {
            colors.append(view.backgroundColor!)
        }
        return colors
    }
    
    func restoreBaseColors(_ colors: [UIColor], for views: [UIView]) {
        if colors.count != views.count {
            return
        }
        
        for (index, view) in views.enumerated() {
            view.backgroundColor = colors[index]
        }
    }
    
}
