//
//  GameContentScene.swift
//  Game
//
//  Created by Nicolás Miari on 2020/05/08.
//  Copyright © 2020 Nicolás Miari. All rights reserved.
//

import SceneKit

class GameContentScene: SCNScene {

    private var cubeNode: SCNNode?

    override init() {
        super.init()

        self.background.contents = Color(displayP3Red: 0.4, green: 0.5, blue: 1, alpha: 1)

        let camera = SCNCamera()
        camera.fieldOfView = 60
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        rootNode.addChildNode(cameraNode)
        #if os(macOS)
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 3)
        #endif
        #if os(iOS)
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 13)
        #endif
        cameraNode.look(at: SCNVector3(x: 0, y: 0, z: 0))

        let light = SCNLight()
        light.type = .directional
        light.intensity = 1000
        let lightNode = SCNNode()
        lightNode.light = light
        rootNode.addChildNode(lightNode)
        lightNode.position = SCNVector3(x: 1, y: 2, z: 12)
        lightNode.look(at: SCNVector3(x: 0, y: 0, z: 0))

        let ambientLight = SCNLight()
        ambientLight.intensity = 100
        ambientLight.type = .ambient
        let ambientNode = SCNNode()
        ambientNode.light = ambientLight
        rootNode.addChildNode(ambientNode)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - GameContentPresenter

extension GameContentScene: GameContentPresenter {

    func loadNewGame() {
        // Reset the geometry
        cubeNode?.removeFromParentNode()

        let cube = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0.05)

        //let colors: [Color] = [.red, .cyan, .blue, .yellow, .green, .magenta]
        let colors: [Color] = [.red, .green, .cyan, .magenta, .blue, .yellow]

        cube.materials = colors.map { (color) -> SCNMaterial in
            let material = SCNMaterial()
            material.lightingModel = .blinn
            material.diffuse.contents = color
            material.ambient.contents = 0.1
            material.specular.contents = 1
            material.shininess = 1
            return material
        }

        let node = SCNNode(geometry: cube)

        let rotate1 = SCNAction.rotateBy(x: 3*CGFloat.pi, y: 0, z: 0, duration: 4)
        let rotate2 = SCNAction.rotateBy(x: 0, y: 2*CGFloat.pi, z: 0, duration: 8)
        let loop1 = SCNAction.repeatForever(rotate1)
        let loop2 = SCNAction.repeatForever(rotate2)
        node.runAction(loop1)
        node.runAction(loop2)

        rootNode.addChildNode(node)

        //node.position = SCNVector3(0, 0, 0)

        self.cubeNode = node
    }

    func updateGameObject(name: String, position: CGPoint) {
        /*
         We are ignoring the `name` parameter (there's only one scene object in
         this demo), but in a real game you would want a way to identify which
         node's state you need to update.

         This is a very basic demo, for clarity. In practive you should modify
         the protocol so that the methods fit your game's specific needs. In my
         game, which is a puzzle that consists of spinning cubes laid out in a
         2D array, the equivalent of this method takes instead a 2D grid
         location to identifiy a single cube, and a 4x4 matrix to set as its new
         transform (3D orientation).
         */

        // Translate the cube into the specified position:
        cubeNode?.position = SCNVector3(position.x, position.y, 0)
    }

    func releaseGameObject(name: String, into position: CGPoint) {
        // Animate the cube into the specified position:
        let action = SCNAction.move(to: SCNVector3(position.x, position.y, 0), duration: 0.25)
        action.timingMode = .easeOut
        cubeNode?.runAction(action)
    }

    func presentClearStageAnimation() {
        // (not covered in this demo, but you get the idea)
    }

    func presentGameOverAnimation() {
        // (not covered in this demo, but you get the idea)
    }
}
