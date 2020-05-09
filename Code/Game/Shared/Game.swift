//
//  Game.swift
//  Game
//
//  Created by Nicolás Miari on 2020/05/08.
//  Copyright © 2020 Nicolás Miari. All rights reserved.
//

import Foundation
import CoreGraphics

/**
 Represents the game being played.
 */
class Game {
    /**
     The `presenter` property is made non-optional to avoid the clutter of
     unwrapping every time, and because it makes little sense to have a game
     instance running without its state displayed onscreen. If you want to
     unit-test the Game class without all the 3D node baggage, simply define a
     mock presenter class that conforms to `GameContentPresenter` but does
     nothing, and inject an instance thereof on instantiation.
     */
    unowned var presenter: GameContentPresenter

    private var moveStartLocation: CGPoint?

    init(presenter: GameContentPresenter) {
        self.presenter = presenter
    }

    func start() {
        presenter.loadNewGame()
    }
}

// MARK: - GameInputDelegate

extension Game: GameInputDelegate {

    func inputSourceShouldTrackInput(at location: CGPoint, object: Any) -> Bool {
        return true
    }

    func inputBegan(at location: CGPoint) {
        self.moveStartLocation = location
    }

    func inputMoved(to location: CGPoint) {
        guard let start = moveStartLocation else {
            return
        }
        let travelled = CGPoint(x: location.x - start.x, y: location.y - start.y)

        // Map from screen coordinates (points) to a value that makes more sense
        // in the game's 3D world:
        let mapped = CGPoint(x: travelled.x / 100, y: travelled.y / 100)

        // Update game objects
        presenter.updateGameObject(name: "Test", position: mapped)
    }

    func inputEnded(at location: CGPoint) {

        // Update game objects
        presenter.releaseGameObject(name: "Test", into: .zero)

        self.moveStartLocation = nil
    }
}
