//
//  PauseGameView.swift
//  Chromi
//
//  Created by ALBERTO YOHANES WIDAGDO on 17/07/26.
//

import SwiftUI

struct PauseMenuView: View {
    let onMainMenu: () -> Void
    let onRestart: () -> Void
    let onResume: () -> Void

    var body: some View {
        PauseOverlayView(
            onMainMenu: onMainMenu,
            onRestart: onRestart,
            onResume: onResume
        )
        .presentationBackground(.clear)
    }
}

#Preview {
    PauseMenuView(onMainMenu: {}, onRestart: {}, onResume: {})
}
