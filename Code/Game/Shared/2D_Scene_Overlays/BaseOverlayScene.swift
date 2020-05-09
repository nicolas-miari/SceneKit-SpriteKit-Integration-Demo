//
//  BaseOverlayswift.swift
//  Game
//
//  Created by Nicolás Miari on 2020/05/09.
//  Copyright © 2020 Nicolás Miari. All rights reserved.
//

import SpriteKit

/**
 Provides common functionality to all SpriteKit scenes in the app, to be
 successively used as overlays over the (persistent) SceneKit view.
 */
class BaseOverlayScene: SKScene, OverlayScene {

    // MARK: - OverlayScene

    // (var alpha: CGFloat is automatically satisfied by SKScene)

    // (func transition(to:completion:) has a default implementation delgating to `navigationDelegate`)

    var navigationDelegate: OverlayNavigationDelegate?

    func fadeAlpha(to newAlpha: CGFloat, duration: TimeInterval, completion: @escaping (() -> Void)) {
        run(.fadeAlpha(to: newAlpha, duration: duration), completion: completion)
    }
}
