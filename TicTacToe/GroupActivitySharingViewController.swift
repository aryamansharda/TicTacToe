//
//  ActivitySharingViewController.swift
//  TicTacToe
//
//  Created by Aryaman Sharda on 8/5/24.
//

import GroupActivities
import SwiftUI
import UIKit

struct GroupActivitySharingViewController: UIViewControllerRepresentable {

    let activity: GroupActivity

    func makeUIViewController(context: Context) -> GroupActivitySharingController {
        return try! GroupActivitySharingController(activity)
    }

    func updateUIViewController(
        _ uiViewController: GroupActivitySharingController,
        context: Context
    ) { }
}
