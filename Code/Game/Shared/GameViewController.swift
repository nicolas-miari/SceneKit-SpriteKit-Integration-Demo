//
//  GameViewController.swift
//  Game
//
//  Created by Nicolás Miari on 2020/05/08.
//  Copyright © 2020 Nicolás Miari. All rights reserved.
//

#if os(macOS)
import AppKit
typealias ViewControllerSuperclass = NSViewController
#endif
#if os(iOS)
import UIKit
typealias ViewControllerSuperclass = UIViewController
#endif

import SceneKit
import SpriteKit

class ViewController: ViewControllerSuperclass, OverlayViewController {

    var overlayView: OverlayView? {
        return gameView
    }

    /*
     Strong reference to prevent deallocation. In a real app, give some thought
     about what presistent object (other than the view controller) would be a
     meaningful owner of the game. Perhaps the Game class itself can store a
     reference to the current game in a static variable.
     */
    var currentGame: Game?

    @IBOutlet weak var gameView: GameView!

    #if os(macOS)
    override func viewWillAppear() {
        super.viewWillAppear()

        gameView.isPlaying = true
        loadMainTitle()
    }
    #endif

    #if os(iOS)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        gameView.isPlaying = true
        loadMainTitle()
    }
    #endif

    func loadMainTitle() {
        let emptyScene = SCNScene()
        emptyScene.background.contents = Color.black
        gameView.scene = emptyScene
        let overlayScene = MainTitleOverlay(size: view.bounds.size)
        present(overlayScene)
    }
}

// MARK - OverlayNavigationDelegate

extension ViewController: OverlayNavigationDelegate {

    func willTransition(to scene: OverlayScene) {
        // (unused)
    }

    func didTransition(to scene: OverlayScene) {
        /*
         Based on which SpriteKit overlay scene was transitioned into, load the
         appropriate 3D content scene (SceneKit):
         */
        switch scene {
        case is GameplayOverlay:

            // Create 3D content scene:
            let contentScene = GameContentScene()

            // Create game, with 3D scene as presenter:
            self.currentGame = Game(presenter: contentScene)

            // Set the 3D content as 'data source' for Metal rendering:
            gameView.scene = contentScene

            // Set the current game to receive user input from the view:
            gameView.inputDelegate = currentGame

            // Start game logic (tells presenter to load new level)
            currentGame?.start()

        case is MainTitleOverlay:
            /*
             The main tutle scene is 2D-only, but we still need an SCNScene set
             in order for the overlay to be rendered:
             */
            gameView.scene = SCNScene()

        default:
            break
        }
    }
}
