//
//  GameContentPresentation.swift
//  Game
//
//  Created by Nicolás Miari on 2020/05/09.
//  Copyright © 2020 Nicolás Miari. All rights reserved.
//

import Foundation

protocol GameContentPresenter: AnyObject {

    func loadNewGame()

    func updateGameObject(name: String, position: CGPoint)

    func releaseGameObject(name: String, into: CGPoint)

}
