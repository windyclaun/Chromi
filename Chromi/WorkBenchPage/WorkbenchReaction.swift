//
//  WorkbenchReaction.swift
//  Chromi
//
//  Created by Windy Claudia Napitupulu on 19/07/26.
//

import Foundation

enum WorkbenchReaction {
    case smile
    case happy
    case sad

    var assetName: String {
        switch self {
        case .smile:
            return "reactionsmile"
        case .happy:
            return "reactionhappy"
        case .sad:
            return "reactionsad"
        }
    }
}
