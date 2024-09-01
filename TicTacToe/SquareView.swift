//
//  SquareView.swift
//  TicTacToe
//
//  Created by Aryaman Sharda on 9/1/24.
//

import SwiftUI

struct SquareView: View {
    let square: GameSquare
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Group {
                if let player = square.player {
                    Image(player.symbol)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding()
                } else {
                    Spacer()
                }
            }
            .font(.title)
            .fontWeight(.medium)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .aspectRatio(1, contentMode: .fit)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(12)
        }
        .disabled(square.player != nil)
    }
}
