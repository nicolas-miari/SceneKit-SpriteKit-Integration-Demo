//
//  Navigation.swift
//  Game
//
//  Created by Nicolás Miari on 2020/05/09.
//  Copyright © 2020 Nicolás Miari. All rights reserved.
//

import Foundation
import CoreGraphics // on iOS, Foundation does not include CGFloat, CGPoint, etc.

// MARK: - Navigatable Overlay Scene

protocol OverlayScene: AnyObject {

    var navigationDelegate: OverlayNavigationDelegate? { get set }

    var alpha: CGFloat { get set }

    func fadeAlpha(to: CGFloat, duration: TimeInterval, completion: @escaping (() -> Void))

    func transition(to scene: OverlayScene, completion: @escaping (() -> Void))
}

// MARK: - Overlay View

protocol OverlayView: AnyObject {

    var overlayScene: OverlayScene? { get set }
}

// MARK: - Overlay View Owner

protocol OverlayViewController: AnyObject {

    var overlayView: OverlayView? { get }
}

// MARK: - Navigation Delegate

protocol OverlayNavigationDelegate: AnyObject {

    var transitionDuration: TimeInterval { get }

    func present(_ scene: OverlayScene)

    func transition(to scene: OverlayScene, completion: @escaping (() -> Void))

    func willTransition(to scene: OverlayScene)

    func didTransition(to scene: OverlayScene)
}

// MARK: - Default Implementations

extension OverlayScene {

    func transition(to scene: OverlayScene, completion: @escaping (() -> Void)) {
        navigationDelegate?.transition(to: scene, completion: completion)
    }
}

extension OverlayNavigationDelegate {

    var transitionDuration: TimeInterval {
        return 0.25
    }
}

extension OverlayNavigationDelegate where Self: OverlayViewController {

    func present(_ scene: OverlayScene) {
        overlayView?.overlayScene = scene
        scene.navigationDelegate = self
    }

    func transition(to scene: OverlayScene, completion: @escaping (() -> Void)) {
        /*
         [0] Notify destination scene and prepare it for fade-in:
         */
        willTransition(to: scene)
        scene.alpha = 0

        /*
         [1] This block gets ultimately executed, regardless:
         */
        let fadeIntoNewScene: (() -> Void) = { [weak self] in
            guard let this = self else {
                return completion()
            }
            this.overlayView?.overlayScene = scene
            scene.fadeAlpha(to: 1, duration: this.transitionDuration) { [weak self] in
                completion()
                self?.didTransition(to: scene)
            }
            scene.navigationDelegate = this
        }

        /*
         [2A] Animate out of the current scene first, if present:
         */
        if let current = overlayView?.overlayScene {
            current.fadeAlpha(to: 0, duration: self.transitionDuration) {
                fadeIntoNewScene()
            }
        } else {
            /*
             [2B] No current scene; transition into the new one right away:
             */
            fadeIntoNewScene()
        }
    }
}
