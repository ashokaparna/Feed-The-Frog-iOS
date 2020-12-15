//
//  RopeNode.swift
//  CutTheRope
//
//  Created by Aparna Ashok on 12/10/20.
//

import UIKit
import SpriteKit

class RopeNode: SKNode {
    private let length: Int
    private let anchorPoint: CGPoint
    private var ropeSegments: [SKNode] = []
    
    let ropeCategory:UInt32 = 0x1 << 2
    let ropeHolderCategory:UInt32 = 0x1 << 3
    
    init(length: Int, anchorPoint: CGPoint, name: String) {
      self.length = length
      self.anchorPoint = anchorPoint
      super.init()
      self.name = name
    }
    
    required init?(coder aDecoder: NSCoder) {
      length = aDecoder.decodeInteger(forKey: "length")
      anchorPoint = aDecoder.decodeCGPoint(forKey: "anchorPoint")
      super.init(coder: aDecoder)
    }
    
    func addToScene(_ scene: SKScene) {
      // add vine to scene
      zPosition = 1
      scene.addChild(self)
      
      // create vine holder
      let ropeHolder = SKSpriteNode(imageNamed: "VineHolder")
      ropeHolder.position = anchorPoint
      ropeHolder.zPosition = 1

      addChild(ropeHolder)

      ropeHolder.physicsBody = SKPhysicsBody(circleOfRadius: ropeHolder.size.width / 2)
      ropeHolder.physicsBody?.isDynamic = false
      ropeHolder.physicsBody?.categoryBitMask =  ropeHolderCategory
      ropeHolder.physicsBody?.collisionBitMask = 0
      
      // add each of the vine parts
      for i in 0..<length {
        let ropeSegment = SKSpriteNode(imageNamed: "VineTexture")
        let offset = ropeSegment.size.height * CGFloat(i + 1)
        ropeSegment.position = CGPoint(x: anchorPoint.x, y: anchorPoint.y - offset)
        ropeSegment.name = name
        ropeSegments.append(ropeSegment)
        addChild(ropeSegment)
        
        ropeSegment.physicsBody = SKPhysicsBody(rectangleOf: ropeSegment.size)
        ropeSegment.physicsBody?.categoryBitMask = ropeCategory
        ropeSegment.physicsBody?.collisionBitMask = ropeHolderCategory
      }
      
      // set up joint for vine holder
      let joint = SKPhysicsJointPin.joint(
        withBodyA: ropeHolder.physicsBody!,
        bodyB: ropeSegments[0].physicsBody!,
        anchor: CGPoint(
          x: ropeHolder.frame.midX,
          y: ropeHolder.frame.midY))

      scene.physicsWorld.add(joint)

      // set up joints between vine parts
      for i in 1..<length {
        let nodeA = ropeSegments[i - 1]
        let nodeB = ropeSegments[i]
        let joint = SKPhysicsJointPin.joint(
          withBodyA: nodeA.physicsBody!,
          bodyB: nodeB.physicsBody!,
          anchor: CGPoint(
            x: nodeA.frame.midX,
            y: nodeA.frame.minY))
        
        scene.physicsWorld.add(joint)
      }
    }
    
    func attachToPrize(_ prize: SKSpriteNode) {
      // align last segment of vine with prize
      let lastNode = ropeSegments.last!
      lastNode.position = CGPoint(x: prize.position.x,
                                  y: prize.position.y + prize.size.height * 0.1)
          
      // set up connecting joint
      let joint = SKPhysicsJointPin.joint(withBodyA: lastNode.physicsBody!,
                                          bodyB: prize.physicsBody!,
                                          anchor: lastNode.position)
          
      prize.scene?.physicsWorld.add(joint)
    }

}
