//
//  GameOverScene.swift
//  CutTheRope
//
//  Created by Aparna Ashok on 12/12/20.
//

import SpriteKit
import RealmSwift

class GameOverScene: SKScene {
    
    override func didMove(to view: SKView) {
        
        let starOne = self.childNode(withName: "starone") as? SKSpriteNode
        let starTwo = self.childNode(withName: "startwo") as? SKSpriteNode
        let starThree = self.childNode(withName: "starthree") as? SKSpriteNode
        let playNext = self.childNode(withName: "playNext") as? SKSpriteNode
        
        let score = GameLevelHandler.sharedInstance.currentScore
        
        if score == 0{
            starOne?.texture = SKTexture(imageNamed: "emptystar")
            starTwo?.texture = SKTexture(imageNamed: "emptystar")
            starThree?.texture = SKTexture(imageNamed: "emptystar")
        }
        else if score == 1{
            starOne?.texture = SKTexture(imageNamed: "fullstar")
            starTwo?.texture = SKTexture(imageNamed: "emptystar")
            starThree?.texture = SKTexture(imageNamed: "emptystar")
        }
        else if score == 2{
            starOne?.texture = SKTexture(imageNamed: "fullstar")
            starTwo?.texture = SKTexture(imageNamed: "fullstar")
            starThree?.texture = SKTexture(imageNamed: "emptystar")
        }
        else if score == 3{
            starOne?.texture = SKTexture(imageNamed: "fullstar")
            starTwo?.texture = SKTexture(imageNamed: "fullstar")
            starThree?.texture = SKTexture(imageNamed: "fullstar")
        }
        
        if GameLevelHandler.sharedInstance.levelData!.score <= 0 || GameLevelHandler.sharedInstance.currentLevel == 9{
            playNext?.alpha = 0.4
        } else {
            playNext?.alpha = 1.0
        }
    }
    
    //MARK: - Touch handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.previousLocation(in: self)
            let node = self.nodes(at: location).first
            let scale = SKAction.customAction(withDuration: 0.5) { (node, location) in
                node.alpha = 0.5
            }
            node?.run(scale)
            if node?.name == "close" {
                //display levels
                let transition = SKTransition.fade(withDuration: 1)
                let levelsScene = SKScene(fileNamed: "LevelsScene")
                levelsScene?.scaleMode =  .aspectFill
                self.view?.presentScene(levelsScene!, transition: transition)
            } else if node?.name == "replay"{
                // GameScene with same level
                let transition = SKTransition.fade(withDuration: 1)
                let gameScene = SKScene(fileNamed: "GameScene")
                gameScene?.scaleMode =  .aspectFill
                self.view?.presentScene(gameScene!, transition: transition)
            }
            else if node?.name == "playNext"{
                var level = GameLevelHandler.sharedInstance.currentLevel
                if level < 9 {
                    level = level + 1
                    GameLevelHandler.sharedInstance.currentLevel = level
                    GameLevelHandler.sharedInstance.instantiateLevelData(level: level, levels: GameLevelHandler.sharedInstance.getGameLevels() as? Results<LevelData>)
                    let delay = SKAction.wait(forDuration: 0.5)
                    let sceneChange = SKAction.run {
                        let scene = SKScene(fileNamed: "GameScene")
                        scene?.scaleMode =  .aspectFill
                        self.view?.presentScene(scene!, transition: .fade(withDuration: 0.5))
                    }
                    run(.sequence([delay, sceneChange]))
                } else {
                    //no new level
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.previousLocation(in: self)
            let node = self.nodes(at: location).first
            node?.alpha = 1.0
        }
    }
}
