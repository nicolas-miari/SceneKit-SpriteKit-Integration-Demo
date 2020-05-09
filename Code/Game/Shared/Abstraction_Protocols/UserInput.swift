//
//  UserInput.swift
//  Game
//
//  Created by Nicolás Miari on 2020/05/08.
//  Copyright © 2020 Nicolás Miari. All rights reserved.
//

import CoreGraphics

protocol GameInputDelegate: AnyObject {

    func inputSourceShouldTrackInput(at location: CGPoint, object: Any) -> Bool

    func inputBegan(at location: CGPoint)

    func inputMoved(to location: CGPoint)
    
    func inputEnded(at location: CGPoint)
}
