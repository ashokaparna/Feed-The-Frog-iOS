//
//  StartScene.swift
//  CutTheRope
//
//  Created by Aparna Ashok on 12/10/20.
//

import SpriteKit
import GameplayKit

class StartScene: SKScene {
    var playButton:SKSpriteNode?
    var levelsScene:SKScene!
    
    override func didMove(to view: SKView) {
        playButton = self.childNode(withName: "startButton") as? SKSpriteNode
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let node = self.atPoint(location)
            if node == playButton {
                let scale = SKAction.customAction(withDuration: 0.5) { (node, location) in
                    node.alpha = 0.5
                }
                playButton?.run(scale)
                let transition = SKTransition.fade(withDuration: 1)
                levelsScene = SKScene(fileNamed: "LevelsScene")
                levelsScene.scaleMode =  .aspectFill
                self.view?.presentScene(levelsScene, transition: transition)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.previousLocation(in: self)
            let node = self.nodes(at: location).first
            node?.alpha = 1.0
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }

}
