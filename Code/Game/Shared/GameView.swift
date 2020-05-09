//
//  GameView.swift
//  Game
//
//  Created by Nicolás Miari on 2020/05/08.
//  Copyright © 2020 Nicolás Miari. All rights reserved.
//

import SceneKit
import SpriteKit
import CoreGraphics

class GameView: SCNView, OverlayScenePresenter {

    var overlayScene: OverlayScene? {
        set {
            self.overlaySKScene = newValue as? SKScene
        }
        get {
            return (overlaySKScene as? OverlayScene)
        }
    }

    weak var inputDelegate: GameInputDelegate?

    private var trackingInput: Bool = false

    // MARK: - Input Handling (Platform-Agnostic)

    func inputBegan(at location: CGPoint) {
        guard let inputDelegate = inputDelegate else {
            return
        }
        let results = hitTest(location, options: nil)
        guard let result = results.first else {
            return
        }
        guard inputDelegate.inputSourceShouldTrackInput(at: location, object: result) else {
            return
        }
        /*
         On iOS, Y axis is flipped. Correct it here, at its source, once, so the
         rest of the code can remain platform-agnostic:
        */
        #if os(iOS)
        inputDelegate.inputBegan(at: location.flippingY)
        #else
        inputDelegate.inputBegan(at: location)
        #endif

        self.trackingInput = true
    }

    func inputMoved(to location: CGPoint) {
        guard let inputDelegate = inputDelegate, trackingInput == true else {
            return
        }
        #if os(iOS)
        inputDelegate.inputMoved(to: location.flippingY)
        #else
        inputDelegate.inputMoved(to: location)
        #endif
    }

    func inputEnded(at location: CGPoint) {
        guard let inputDelegate = inputDelegate, trackingInput == true else {
            return
        }
        #if os(iOS)
        inputDelegate.inputEnded(at: location.flippingY)
        #else
        inputDelegate.inputEnded(at: location)
        #endif
        self.trackingInput = false
    }

    #if os(macOS)
    // MARK: - NSResponder (macOS)

    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        let location = convert(event.locationInWindow, from: nil)
        inputBegan(at: location)
    }

    override func mouseDragged(with event: NSEvent) {
        super.mouseDragged(with: event)
        let location = convert(event.locationInWindow, from: nil)
        inputMoved(to: location)
    }

    override func mouseUp(with event: NSEvent) {
        super.mouseUp(with: event)
        let location = convert(event.locationInWindow, from: nil)
        inputEnded(at: location)
    }
    #endif

    #if os(iOS)
    // MARK: - UIResponder (iOS)

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let location = Array(touches)[0].location(in: self)
        inputBegan(at: location)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        let location = Array(touches)[0].location(in: self)
        inputMoved(to: location)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        let location = Array(touches)[0].location(in: self)
        inputEnded(at: location)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        let location = Array(touches)[0].location(in: self)
        inputEnded(at: location)
    }
    #endif
}

private extension CGPoint {

    var flippingY: CGPoint {
        return CGPoint(x: x, y: -y)
    }
}
