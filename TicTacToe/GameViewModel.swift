//
//  GameViewModel.swift
//  TicTacToe
//
//  Created by Aryaman Sharda on 9/1/24.
//

import SwiftUI
import GroupActivities

@MainActor
@Observable
class GameViewModel {
    var session: GroupSession<TicTacToeActivity>?
    var game: TicTacToeGame

    var tasks = Set<Task<Void, Never>>()
    var messenger: GroupSessionMessenger?


    init() {
        self.game = TicTacToeGame()

        Task {
            await self.watchForSessions()
        }
    }

    func watchForSessions() async {
        for await session in TicTacToeActivity.sessions() {
            configureSession(session)
        }
    }

    func configureSession(_ session: GroupSession<TicTacToeActivity>) {
        self.session = session
        if session.state != .joined {
            session.join()
        }

        let messenger = GroupSessionMessenger(session: session, deliveryMode: .reliable)
        self.messenger = messenger

        let task = Task.detached { [weak self] in
            for await (gameState, _) in messenger.messages(of: TicTacToeGame.self) {
                await self?.receive(gameState)
            }
        }

        tasks.insert(task)
    }


    func makeMove(at square: Int) {
        game.makeMove(at: square)
        send(game)
    }

    func send(_ model: TicTacToeGame) {
        Task {
            do {
                try await messenger?.send(model)
            } catch {
                print("Sending SharePlayModel failed: \(error)")
            }
        }
    }

    func resetGame() {
        game.resetGame()
    }

    func stopSharePlay() {
        /// Ends the activity for the entire group and stops the transfer
        /// of synchronized data.
        session?.end()

        /// Leaves the current activity and stops receiving synchronized data.
        session?.leave()

        // Cleanup
        session = nil
        tasks.forEach { $0.cancel() }
        tasks.removeAll()

    }



    func receive(_ model: TicTacToeGame) {
        self.game = model
        game.updateCurrentPlayer()
    }

}
