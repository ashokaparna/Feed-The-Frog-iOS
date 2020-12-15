//
//  GameSceneBase.swift
//  FeedTheFrog
//
//  Created by Aparna Ashok on 12/14/20.
//

import SpriteKit
import GameplayKit

class GameSceneBase: SKScene, SKPhysicsContactDelegate {
    var frog: SKSpriteNode!
    var candy: SKSpriteNode!
    
    var timeLabel: SKLabelNode?
    var pause: SKSpriteNode?
    
    let frogCategory:UInt32 = 0x1 << 0
    let candyCategory:UInt32 = 0x1 << 1
    
    private var didCutRope = false
    private let canCutMultipleRope = false
    private var isLevelOver = false
    
    var remainingTime: TimeInterval = 60 {
        didSet {
            self.timeLabel?.text = "Time: \(Int(self.remainingTime))"
        }
    }
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        physicsWorld.speed = 1.0
        let currentLevel = GameLevelHandler.sharedInstance.currentLevel
        setUpFrog(position: getFrogPositionBasedOnLevel(level: currentLevel))
        setupCandy(position: getCandyPositionBasedOnLevel(level: currentLevel))
        createRopes()
        createTimerAndPauseButton()
        launchGameTimer()
        playBgSound()
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if remainingTime <= 5 {
            timeLabel?.fontColor = UIColor.red
        }
        if remainingTime == 0 {
            showGameOverScreenWithTransition(transition: .fade(withDuration:0.5), didCollide: false)
        }
        
        if candy.position.y <= 0 {
            print("candy gone")
            isLevelOver = true
            showGameOverScreenWithTransition(transition: .fade(withDuration: 0.5), didCollide: false)
        }
    }
    
    func setUpFrog(position: CGPoint) {
        frog = SKSpriteNode(imageNamed: frogImageClosedMouth)
        frog?.position = position
        frog?.zPosition = 2
        frog?.scale(to: CGSize(width: 210, height: 210))
        frog?.physicsBody = SKPhysicsBody(circleOfRadius: frog!.size.width / 2)
        frog?.physicsBody?.categoryBitMask = frogCategory
        frog?.physicsBody?.collisionBitMask = 0
        frog?.physicsBody?.contactTestBitMask = candyCategory
        frog?.physicsBody?.isDynamic = false
        frog?.physicsBody?.affectedByGravity = false
        addChild(frog)
        animateFrog()
    }
    
    func setupCandy(position: CGPoint) {
        candy = SKSpriteNode(imageNamed: "Pineapple")
        candy?.position = position
        candy?.zPosition = 2
        candy?.physicsBody = SKPhysicsBody(circleOfRadius: candy.size.height / 2)
        candy?.physicsBody?.categoryBitMask = candyCategory
        candy?.physicsBody?.collisionBitMask = 0
        candy?.physicsBody?.density = 0.5
        addChild(candy)
    }
    
    func createTimerAndPauseButton() {
        pause = self.childNode(withName: "pause") as? SKSpriteNode
        timeLabel = self.childNode(withName: "time") as? SKLabelNode
        remainingTime = 60
    }
        
    func  launchGameTimer() {
        let timeAction = SKAction.repeatForever(SKAction.sequence([SKAction.run {
            self.remainingTime -= 1
        }, SKAction.wait(forDuration: 1)]))
        timeLabel?.run(timeAction)
    }
    

    func createRopes() {
        let ropeDatas = getRopeDataFromPlist(level: GameLevelHandler.sharedInstance.currentLevel)
        for (i, ropeData) in ropeDatas.enumerated() {
          let anchorPoint = CGPoint(
            x: ropeData.relativeAnchorPoint.x * size.width,
            y: ropeData.relativeAnchorPoint.y * size.height)
          let rope = RopeNode(length: ropeData.length, anchorPoint: anchorPoint, name: "\(i)")
            rope.addToScene(self)
            rope.attachToPrize(candy)
        }
    }
    
    //MARK: - Touch handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      didCutRope = false
        if let touch = touches.first {
            let location = touch.previousLocation(in: self)
            let node = self.nodes(at: location).first
            if node?.name == "pause", let scene = self.scene {
                    if scene.isPaused  {
                        scene.isPaused = false
                        if let pb = node as? SKSpriteNode {
                            pb.texture = SKTexture(imageNamed: "PauseButton")
                        }
                    } else{
                        scene.isPaused = true
                        if let pb = node as? SKSpriteNode {
                            pb.texture = SKTexture(imageNamed: "playbutton")
                        }
                    }
            }
            else if node?.name == "cancel" {
                let transition = SKTransition.fade(withDuration: 0.5)
                let levelsScene = SKScene(fileNamed: "LevelsScene")
                levelsScene?.scaleMode =  .aspectFill
                self.view?.presentScene(levelsScene!, transition: transition)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let scene = self.scene, scene.isPaused {
            return
        }
      for touch in touches {
        let startPoint = touch.location(in: self)
        let endPoint = touch.previousLocation(in: self)
        self.physicsWorld.enumerateBodies(
          alongRayStart: startPoint,
          end: endPoint,
          using: { body, _, _, _ in
            self.checkIfRopeCut(withBody: body)
        })
      }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }

    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.node == frog && contact.bodyB.node == candy)
          || (contact.bodyA.node == frog && contact.bodyB.node == candy) {
            print("frog and pineapple contact")
            frog.removeAllActions()
              let shrink = SKAction.scale(to: 0, duration: 0.08)
              let removeNode = SKAction.removeFromParent()
              let sequence = SKAction.sequence([shrink, removeNode])
              isLevelOver = true
            playLevelCompletedSoundAction()
            frogMouthOpenAndCloseAnimation(delay: 0.15)
              showGameOverScreenWithTransition(transition: .fade(withDuration: 1.0), didCollide: true)
              candy.run(sequence)
        }
    }
    
    func checkIfRopeCut(withBody body: SKPhysicsBody) {
      if didCutRope && !canCutMultipleRope{
        return
      }
      let node = body.node!
      if let name = node.name {
        if  name == "0" || name == "1" || name == "2" {
            node.removeFromParent()
            enumerateChildNodes(withName: name, using: { node, _ in
              let fadeAway = SKAction.fadeOut(withDuration: 0.25)
              let removeNode = SKAction.removeFromParent()
              let sequence = SKAction.sequence([fadeAway, removeNode])
              node.run(sequence)
            })
            didCutRope = true
        }
      }
    }
    
    func showGameOverScreenWithTransition(transition: SKTransition, didCollide: Bool) {
        saveData(didCollide: didCollide)
        let delay = SKAction.wait(forDuration: 1)
        let sceneChange = SKAction.run {
           let gameOverScene = SKScene(fileNamed: "GameOverScene")
            gameOverScene?.scaleMode =  .aspectFill
            self.view?.presentScene(gameOverScene!, transition: transition)
        }
        run(.sequence([delay, sceneChange]))
    }
    
    func saveData(didCollide: Bool) {
        var score: Double = 0
        if didCollide {
            if remainingTime > 0 {
                score = 1
            }
            if remainingTime > 20 {
                score = 2
            }
            if remainingTime > 40 {
                score = 3
            }
            GameLevelHandler.sharedInstance.currentScore = Int(score)
            if score > GameLevelHandler.sharedInstance.levelData!.score {
                let currentLevel = GameLevelHandler.sharedInstance.levelData?.levelNumber
                if currentLevel!  > GameLevelHandler.sharedInstance.getLastScoredLevel() {
                    GameLevelHandler.sharedInstance.saveLastScoredLevel(lastScoredLevel: currentLevel!)
                }
                GameLevelHandler.sharedInstance.saveGameStatus(score: score)
            }
        } else {
            GameLevelHandler.sharedInstance.currentScore = 0
        }
    }
    
    func animateFrog() {
        let duration = Double.random(in: 2...4)
        let open = SKAction.setTexture(SKTexture(imageNamed: frogImageOpenMouth))
        let wait = SKAction.wait(forDuration: duration)
        let close = SKAction.setTexture(SKTexture(imageNamed: frogImageClosedMouth))
        let sequence = SKAction.sequence([wait, open, wait, close])
        frog.run(.repeatForever(sequence))
        let currentLevel = GameLevelHandler.sharedInstance.currentLevel
        if currentLevel > 5 {
            if currentLevel == 5 || currentLevel == 6 {
                moveFrogLeftAndRight(duration: TimeInterval(2.0))
            } else {
                moveFrogLeftAndRight(duration: TimeInterval(1.5))
            }
        }
    }
    
    func frogMouthOpenAndCloseAnimation(delay: TimeInterval) {
        frog.removeAllActions()
        let closeMouth = SKAction.setTexture(SKTexture(imageNamed: frogImageClosedMouth))
        let wait = SKAction.wait(forDuration: delay)
        let openMouth = SKAction.setTexture(SKTexture(imageNamed: frogImageOpenMouth))
        let sequence = SKAction.sequence([closeMouth, wait, openMouth, wait, closeMouth])
        frog.run(sequence)
    }
    
    func moveFrogLeftAndRight(duration: TimeInterval) {
        let moveRight = SKAction.move(to: CGPoint(x: self.size.width - frog.size.width/2 , y: frog.position.y), duration: duration)
        let moveLeft = SKAction.move(to: CGPoint(x: frog.size.width/2 , y: frog.position.y), duration: duration)
        let moveRightSequence = SKAction.sequence([moveRight, moveLeft])
        frog.run(.repeatForever(moveRightSequence))
    }
    
    func playLevelCompletedSoundAction() {
        let soundAction = SKAction.playSoundFileNamed("levelcompleted.wav", waitForCompletion: true)
        run(soundAction)
    }
    
    func playBgSound() {
        let soundAction = SKAction.playSoundFileNamed("bg.mp3", waitForCompletion: true)
        run(soundAction)
    }
    
}
