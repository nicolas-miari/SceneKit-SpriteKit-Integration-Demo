//
//  MainTitleOverlay.swift
//  Game
//
//  Created by Nicolás Miari on 2020/05/08.
//  Copyright © 2020 Nicolás Miari. All rights reserved.
//

import SpriteKit

class MainTitleOverlay: BaseOverlayScene {

    override init(size: CGSize) {
        super.init(size: size)

        self.backgroundColor = Color.blue

        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)

        let start = SKLabelNode(text: "START")
        start.fontColor = .white
        self.addChild(start)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var transitioning: Bool = false

    private func proceedToGame() {
        if transitioning {
            return
        }
        self.transitioning = true
        let game = GameplayOverlay(size: self.size)
        self.transition(to: game, completion: {
            
        })
    }

    #if os(macOS)
    override func mouseDown(with event: NSEvent) {
        proceedToGame()
    }
    #endif

    #if os(iOS)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        proceedToGame()
    }
    #endif
}

// MARK: -

class ButtonNode: SKLabelNode {

    var handler: (() -> Void)? {
        didSet {
            if handler != nil {
                self.isUserInteractionEnabled = true
            }
        }
    }

    #if os(iOS)

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = Array(touches)[0].location(in: parent!)
        if calculateAccumulatedFrame().contains(location) {
            handler?()
        }
    }
    #endif

    #if os(macOS)
    override func mouseUp(with event: NSEvent) {
        let location = event.location(in: parent!)
        if calculateAccumulatedFrame().contains(location) {
            handler?()
        }
    }
    #endif
}
