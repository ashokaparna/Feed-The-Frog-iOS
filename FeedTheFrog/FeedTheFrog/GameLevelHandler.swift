//
//  GameLevelHandler.swift
//  CutTheRope
//
//  Created by Aparna Ashok on 12/11/20.
//

import Foundation
import RealmSwift

class GameLevelHandler {
    var levelData: LevelData?
    var currentScore = 0
    var currentLevel = 0
    
    class var sharedInstance: GameLevelHandler {
        struct SingleTon {
            static let instance = GameLevelHandler ()
        }
        return SingleTon.instance
    }
    init() {
        
    }
    
    func saveGameStatus(score: Double) {
        // Get the default Realm
        let realm = try! Realm()
        if let level = getLevelFromLevels(levelNumber: levelData!.levelNumber) {
            print("update level \(level)")
            try! realm.write {
                level.score = score
                levelData = level
            }
        } else {
            print("add level \(String(describing: levelData))")
            levelData?.score = score
            try! realm.write {
                realm.add(levelData!);
            }
        }
    }
    
    func getGameLevels() -> Any? {
        let realm = try! Realm()
        let levels = realm.objects(LevelData.self)
        return levels;
    }
    
    func getLevelFromLevels(levelNumber: Int) -> LevelData? {
        let realm = try! Realm()
        let level = realm.objects(LevelData.self).filter("levelNumber == \(levelNumber)").first
        return level
    }
    
    func saveLastScoredLevel(lastScoredLevel: Int) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(lastScoredLevel, forKey: "lastscoredlevel")
        userDefaults.synchronize()
    }
    
    func getLastScoredLevel() -> Int {
        let userDefaults = UserDefaults.standard
        return userDefaults.integer(forKey: "lastscoredlevel")
    }
    
    func instantiateLevelData(level: Int, levels: Results<LevelData>?) {
        if levels != nil && (levels?.count)! > level - 1 {
            GameLevelHandler.sharedInstance.levelData = GameLevelHandler.sharedInstance.getLevelFromLevels(levelNumber: level)
        } else {
            GameLevelHandler.sharedInstance.levelData = LevelData.init(levelNumber: level, score: 0, locked: false)
        }
    }
}

