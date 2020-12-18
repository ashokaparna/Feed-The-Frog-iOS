//
//  GameOverCompletedScene.swift
//  FeedTheFrog
//
//  Created by Aparna Ashok on 12/16/20.
//

import UIKit
import SpriteKit

class GameCompletedScene: SKScene {
    
    override func didMove(to view: SKView) {
    }
    
    //MARK: - Touch handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.previousLocation(in: self)
            let node = self.nodes(at: location).first
            if node?.name == "exit" {
                    exit(0)
            }
        }
        
    }
    
    

}
