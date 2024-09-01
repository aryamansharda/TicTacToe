//
//  TicTacToeActivity.swift
//  TicTacToe
//
//  Created by Aryaman Sharda on 8/9/24.
//


import SwiftUI
import GroupActivities

struct TicTacToeActivity: GroupActivity {
    /// An app-defined string that uniquely identifies the activity.
    ///
    /// If you don't implement this property yourself, the default
    /// implementation composes an activity identifier using your app's
    /// bundle identifier and the current class or struct name.
    static let activityIdentifier = "com.AryamanSharda.TicTacToe.TicTacToeActivity"

    var game: TicTacToeGame?

    var metadata: GroupActivityMetadata {
        var metadata = GroupActivityMetadata()
        metadata.title = "Tic Tac Toe Match"
        metadata.subtitle = "Play with friends over SharePlay"
        metadata.previewImage = UIImage(named: "preview-image")?.cgImage
        metadata.type = .generic
        return metadata
    }
}
