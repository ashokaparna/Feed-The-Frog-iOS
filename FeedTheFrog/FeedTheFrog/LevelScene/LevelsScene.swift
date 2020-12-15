//
//  LevelsScene.swift
//  CutTheRope
//
//  Created by Aparna Ashok on 12/11/20.
//

import SpriteKit
import RealmSwift

class LevelsScene: SKScene {
    
    var levels: Results<LevelData>?
    
    override func didMove(to view: SKView) {
        levels = GameLevelHandler.sharedInstance.getGameLevels() as? Results<LevelData>
        let tileSize = self.size.width/4
        let rows = 3
        let cols = 3
        let tileX = CGFloat(3) * self.size.width/16
        let tileY = 3 * self.size.height/4
        var x = tileX
        var y = tileY
        var counter = 0
        for _ in 1...rows {
            for _ in 1...cols {
                counter += 1
                if levels!.count >= counter {
                    let data = levels?[counter-1]
                    let tile = LevelsTile.init(position: CGPoint(x: x, y: y), levelData: data, size: CGSize(width: tileSize, height: tileSize), name :"\(counter)")
                    self.addChild(tile)
                } else {
                    let tile = LevelsTile.init( position: CGPoint(x: x, y: y), levelData: nil, size: CGSize(width: tileSize, height: tileSize), name :"\(counter)")
                    self.addChild(tile)
                }
                x = x + 5 * self.size.width/16
            }
            x = tileX
            y = y - self.size.height/4
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
   
    }
    
    override func willMove(from view: SKView) {
        self.removeAllChildren()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.previousLocation(in: self)
            let node = self.nodes(at: location).first
            if node?.name == "1" || node?.name == "2" || node?.name == "3" || node?.name == "4" || node?.name == "5" || node?.name == "6" || node?.name == "7" || node?.name == "8" || node?.name == "9" {
                let scale = SKAction.customAction(withDuration: 0.5) { (node, location) in
                    node.alpha = 0.5
                }
                node?.run(scale)
                let level = Int((node?.name)!)
                if level! > GameLevelHandler.sharedInstance.getLastScoredLevel()+1 {
                    return
                }
                GameLevelHandler.sharedInstance.currentLevel = level!
                GameLevelHandler.sharedInstance.instantiateLevelData(level: level!, levels: levels)
                let delay = SKAction.wait(forDuration: 0.5)
                let sceneChange = SKAction.run {
                    let scene = SKScene(fileNamed: "GameScene")
                    scene?.scaleMode =  .aspectFill
                    self.view?.presentScene(scene!, transition: .fade(withDuration: 0.5))
                }
                run(.sequence([delay, sceneChange]))
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
}
