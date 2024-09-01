//
//  Game.swift
//  TicTacToe
//
//  Created by Aryaman Sharda on 8/9/24.
//

import Foundation
import Observation

enum Player: Codable {
    case x, o

    var symbol: String {
        switch self {
        case .x: return "X"
        case .o: return "O"
        }
    }
}

struct GameSquare: Identifiable, Codable {
    var player: Player?
    var index: Int

    var id: Int {
        index
    }
}

@Observable
class TicTacToeGame: Codable {
    private(set) var board: [GameSquare]
    private(set) var currentPlayer: Player
    private(set) var gameOver: Bool
    private(set) var winner: Player?

    init() {
        self.board = Array(repeating: GameSquare(player: nil, index: 0), count: 9)
        self.currentPlayer = .x
        self.gameOver = false
        self.board.indices.forEach { board[$0] = GameSquare(player: nil, index: $0) }
    }

    var currentMove: String {
        "It's **\(currentPlayer.symbol.capitalized)**'s turn"
    }

    func makeMove(at index: Int) {
        guard !gameOver, board[index].player == nil else { return }
        board[index].player = currentPlayer

        if checkWin(for: currentPlayer) {
            winner = currentPlayer
            gameOver = true
        } else if board.allSatisfy({ $0.player != nil }) {
            gameOver = true
        } else {
            updateCurrentPlayer()
        }
    }

    func togglePlayer() {
        currentPlayer = currentPlayer == .x ? .o : .x
    }

    func updateCurrentPlayer() {
        let filledSquaresCount = board.filter { $0.player != nil }.count
        currentPlayer = filledSquaresCount % 2 == 0 ? .x : .o
    }

    func resetGame() {
        board.indices.forEach { board[$0] = GameSquare(player: nil, index: $0) }
        currentPlayer = .x
        gameOver = false
        winner = nil
    }

    private func checkWin(for player: Player) -> Bool {
        let playerMoves = board.indices.filter { board[$0].player == player }
        let winningCombinations = [
            [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
            [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
            [0, 4, 8], [2, 4, 6]             // Diagonals
        ]

        return winningCombinations.contains { combination in
            combination.allSatisfy(playerMoves.contains)
        }
    }
}

import GroupActivities
import SwiftUI

extension TicTacToeGame: Transferable {
    static var transferRepresentation: some TransferRepresentation {
        // Export the game state as JSON using CodableRepresentation.
        CodableRepresentation(contentType: .json)

        // Specify the associated SharePlay activity.
        GroupActivityTransferRepresentation { game in
            TicTacToeActivity()
        }
    }
}
