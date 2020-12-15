//
//  GameSceneLevelHandler.swift
//  FeedTheFrog
//
//  Created by Aparna Ashok on 12/14/20.
//

import SpriteKit
import UIKit

extension GameSceneBase {
    
    func getFrogPositionBasedOnLevel(level: Int) -> CGPoint{
        switch level {
        case 1:
         return CGPoint(x: size.width * 0.50, y: size.height * 0.258)
        case 2:
         return CGPoint(x: size.width * 0.75, y: size.height * 0.258)
        case 3:
         return CGPoint(x: size.width * 0.50, y: size.height * 0.258)
        case 4:
        return CGPoint(x: size.width * 0.50, y: size.height * 0.258)
        case 5:
         return CGPoint(x: size.width * 0.75, y: size.height * 0.258)
        case 6:
         return CGPoint(x: size.width * 0.50, y: size.height * 0.258)
        case 7:
         return CGPoint(x: size.width * 0.75, y: size.height * 0.258)
        case 8:
         return CGPoint(x: size.width * 0.50, y: size.height * 0.258)
        case 9:
        return CGPoint(x: size.width * 0.50, y: size.height * 0.258)
        default:
           return CGPoint(x: 0, y: 0)
        }
    }
    
    func getCandyPositionBasedOnLevel(level: Int) -> CGPoint{
        switch level {
        case 1:
         return CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        case 2:
         return CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        case 3:
         return CGPoint(x: size.width * 0.25, y: size.height * 0.45)
        case 4:
         return CGPoint(x: size.width * 0.5, y: size.height * 0.7)
        case 5:
         return CGPoint(x: size.width * 0.5, y: size.height * 0.7)
        case 6:
         return CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        case 7:
         return CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        case 8:
         return CGPoint(x: size.width * 0.25, y: size.height * 0.45)
        case 9:
         return CGPoint(x: size.width * 0.5, y: size.height * 0.7)
        default:
           return CGPoint(x: 0, y: 0)
        }
    }
    
    func getRopeDataFromPlist(level: Int) -> [RopeDataModel]{
        let decoder = PropertyListDecoder()
        guard
          let dataFile = Bundle.main.url(
            forResource: "RopeDataLevels.plist",
            withExtension: nil),
          let data = try? Data(contentsOf: dataFile),
            let ropeDatas = try? decoder.decode([String: [RopeDataModel]].self, from: data)
       else {
            print("Error reading plist")
            return []
        }
        if ropeDatas.count >= level {
            let levelData = ropeDatas["level\(level)"]
            return levelData!
        }
        return []
    }
}
