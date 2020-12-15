//
//  LevelData.swift
//  CutTheRope
//
//  Created by Aparna Ashok on 12/10/20.
//
import Foundation
import RealmSwift

class LevelData: Object{
    @objc dynamic var levelNumber : Int = 0
    @objc dynamic var score: Double = 0.0
    @objc dynamic var locked : Bool = true
    
     init(levelNumber: Int, score: Double, locked: Bool) {
        super.init()
        self.levelNumber = levelNumber
        self.score = score
        self.locked = locked
    }
    
    override required init() {
        
    }
    
    override static func primaryKey() -> String? {
          return "levelNumber"
    }
}
