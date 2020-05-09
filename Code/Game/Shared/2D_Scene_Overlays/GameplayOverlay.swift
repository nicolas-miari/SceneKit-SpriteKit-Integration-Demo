//
//  GameplayOverlay.swift
//  Game
//
//  Created by Nicolás Miari on 2020/05/09.
//  Copyright © 2020 Nicolás Miari. All rights reserved.
//

import SpriteKit

class GameplayOverlay: BaseOverlayScene {

    override init(size: CGSize) {
        super.init(size: size)

        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        //let quit = SKLabelNode(text: "QUIT")
        //quit.fontColor = .white
        //self.addChild(quit)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
