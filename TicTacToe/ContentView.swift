//
//  ContentView.swift
//  TicTacToe
//
//  Created by Aryaman Sharda on 7/26/24.
//

import SwiftUI
import GroupActivities

// Tic Tac Toe Board
struct ContentView: View {
    @State var viewModel = GameViewModel()
    @State var isActivitySharingSheetPresented = false
    @StateObject var groupStateObserver = GroupStateObserver()

    var body: some View {
        VStack(spacing: 16) {
            gameState
            ticTacToeGrid
            gameControls
            ShareLink(
                item: TicTacToeGame(),
                preview: .init("Share this Tic Tac Toe Activity!")
            )
        }
        .foregroundColor(.white)
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.brand)
        .sheet(isPresented: $isActivitySharingSheetPresented) {
            GroupActivitySharingViewController(
                activity: TicTacToeActivity()
            )
        }

    }

    @ViewBuilder
    private var gameState: some View {
        if viewModel.game.gameOver {
            Text("Game over!")
                .font(.largeTitle)
                .padding(.bottom, 16.0)
        } else {
            Text(LocalizedStringKey(viewModel.game.currentMove))
                .font(.largeTitle)
                .padding(.bottom, 16.0)
        }
    }

    private var ticTacToeGrid: some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible(), spacing: 6.0), count: 3),
            spacing: 6.0
        ) {
            ForEach(viewModel.game.board) { square in
                SquareView(square: square, action: {
                    viewModel.makeMove(at: square.index)
                })
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(16.0)
        .frame(maxWidth: .infinity)
    }

    private var gameControls: some View {
        HStack(spacing: 20) {
            Button {
                if groupStateObserver.isEligibleForGroupSession {
                    Task {
                        let activity = TicTacToeActivity()
                        let result = await activity.prepareForActivation()

                        if result == .activationPreferred {
                            _ = try? await activity.activate()
                        }
                    }

                } else {
                    isActivitySharingSheetPresented = true
                }

            } label: {
                Image(systemName: "shareplay")
                    .font(.title)
                    .fontWeight(.medium)
            }

            Rectangle()
                .frame(width: 2, height: 30)
                .foregroundColor(.secondary)

            Button(action: {
                viewModel.resetGame()
            }, label: {
                Image(systemName: "arrow.circlepath")
                    .font(.title)
                    .fontWeight(.medium)
            })
        }
        .padding()
        .foregroundStyle(Color.accentColor)
        .background(Color.black.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.top, 16)
    }
}

#Preview {
    ContentView()
}
