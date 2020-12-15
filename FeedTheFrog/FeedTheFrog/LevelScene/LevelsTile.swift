//
//  LevelsTile.swift
//  CutTheRope
//
//  Created by Aparna Ashok on 12/11/20.
//

import SpriteKit

class LevelsTile: SKNode {

    var tile: SKSpriteNode!

    init(position: CGPoint, levelData: LevelData?, size: CGSize, name: String) {
        super.init()
        tile = SKSpriteNode(color: .clear, size: size)
        tile.name = name
        tile.position = position
        tile.zPosition = 3
        self.addChild(tile)
        let ratingWidth = tile.size.width
        let ratingHeight = tile.size.height/2
        let ratingIcon = SKSpriteNode(color: .clear, size: CGSize(width: ratingWidth, height: ratingHeight))
        ratingIcon.position = CGPoint(x: tile.position.x , y: tile.position.y - size.height/4 )
        ratingIcon.zPosition = 1
        self.addChild(ratingIcon)
        var imageName: String!
        var scaleSize: CGSize!
        if let data = levelData {
            if data.locked {
                //add lock icon
                imageName = "lock"
                scaleSize = CGSize(width: 40, height: 40)
            } else {
                scaleSize = CGSize(width: 120, height: 40)
                if levelData?.score == 0 {
                    imageName = zeroStar
                }
                else if levelData?.score == 1{
                    imageName = oneStar
                }else if levelData?.score == 2{
                    imageName = twoStar
                }
                else if levelData?.score == 3{
                    imageName = threeStar
                }
            }
        } else{
            //add lock icon
            let currentLevel = Int(name)
            if  currentLevel == GameLevelHandler.sharedInstance.getLastScoredLevel()+1{
                imageName = zeroStar
                scaleSize = CGSize(width: 120, height: 40)
            } else {
                imageName = "lock"
                scaleSize = CGSize(width: 40, height: 40)
            }
        }
        let ratingImageNode = SKSpriteNode(imageNamed: imageName)
        ratingImageNode.scale(to: scaleSize)
        ratingImageNode.zPosition = 1
        ratingIcon.addChild(ratingImageNode)
        
        let numberImageNode = SKSpriteNode(imageNamed: getLevelImageName(currentLevel: Int(name)!))
        numberImageNode.scale(to: CGSize(width: tile.size.width, height: tile.size.height/2))
//        let numberImageNode = SKSpriteNode(color: UIColor.black, size: CGSize(width: tile.size.width, height: tile.size.height/2))
        numberImageNode.position = CGPoint(x: tile.position.x , y: tile.position.y
                                           + size.height/4 )
        numberImageNode.zPosition = 1
        self.addChild(numberImageNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func getLevelImageName(currentLevel: Int) -> String {
        switch  currentLevel{
        case 1:
            return "one"
        case 2:
            return "two"
        case 3:
            return "three"
        case 4:
            return "four"
        case 5:
            return "five"
        case 6:
            return "six"
        case 7:
            return "seven"
        case 8:
            return "eight"
        case 9:
            return "nine"
        default:
            return ""
        }
    }
}




