//
//  Navigation.swift
//  Game
//
//  Created by Nicolás Miari on 2020/05/09.
//  Copyright © 2020 Nicolás Miari. All rights reserved.
//

import Foundation
import CoreGraphics

// MARK: - Overlay Scene

protocol OverlayScene: AnyObject {

    var navigationDelegate: OverlayNavigationDelegate? { get set }

    var alpha: CGFloat { get set }

    func fadeAlpha(to value: CGFloat, duration: TimeInterval, completion: @escaping (() -> Void))

    func transition(to scene: OverlayScene, completion: @escaping (() -> Void))
}

// MARK: - Overlay Scene Presenter (View)

/**
 Accepts an instance of a type that conforms to `OverlayScene`, and presents it
 on screen.
 */
protocol OverlayScenePresenter: AnyObject {

    var overlayScene: OverlayScene? { get set }
}

// MARK: - Overlay Navigation Delegate

protocol OverlayNavigationDelegate: AnyObject {

    var overlayContainer: OverlayScenePresenter? { get }

    /**
     A default implemetation that always retuens 0.5 is provided.
     */
    var transitionDuration: TimeInterval { get }

    /**
     Optional: a default implementation that relies on the requirements of
     `OverlayScene` and `OverlayScenePresenter` ios provided.
     */
    func present(_ scene: OverlayScene)

    /**
     Optional: a default implementation that relies on the requirements of
     `OverlayScene` and `OverlayScenePresenter` ios provided.
    */
    func transition(to scene: OverlayScene, completion: @escaping (() -> Void))

    /**
     Optional (an empty implementation is provided). The provided default
     implementation of `transition(to:completion:)` calls this method **before**
     transitioning.
     */
    func willTransition(to scene: OverlayScene)

    /**
     Optional (an empty implementation is provided). The provided default
     implementation of `transition(to:completion:)` calls this method **after**
     transitioning.
    */
    func didTransition(to scene: OverlayScene)
}

// MARK: - Default Implementations

extension OverlayNavigationDelegate {

    var transitionDuration: TimeInterval {
        return 0.5
    }

    func present(_ scene: OverlayScene) {
        scene.navigationDelegate = self
        overlayContainer?.overlayScene = scene
    }

    func transition(to scene: OverlayScene, completion: @escaping (() -> Void)) {
        guard let source = overlayContainer?.overlayScene else {
            /*
             No source scene: transition to destination right away:
             */
            willTransition(to: scene)
            scene.navigationDelegate = self
            scene.alpha = 0
            overlayContainer?.overlayScene = scene
            scene.fadeAlpha(to: 1, duration: self.transitionDuration) { [weak self] in
                completion()
                self?.didTransition(to: scene)
            }
            return
        }

        /*
         Fade source out...
         */
        source.fadeAlpha(to: 0, duration: self.transitionDuration) { [weak self] in
            guard let this = self else {
                return
            }
            this.willTransition(to: scene)
            scene.navigationDelegate = this
            scene.alpha = 0
            this.overlayContainer?.overlayScene = scene
            /*
             ...and then fade destination in:
             */
            scene.fadeAlpha(to: 1, duration: this.transitionDuration) { [weak self] in
                completion()
                self?.didTransition(to: scene)
            }
        }
    }
}
