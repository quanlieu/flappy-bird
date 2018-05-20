//
//  GameManager.swift
//  Flappy Bird
//
//  Created by Quan Lieu on 5/19/18.
//  Copyright © 2018 Quan Lieu. All rights reserved.
//

import Foundation

class GameManager {
    
    static let instance = GameManager()
    private var birdIndex = 0
    private var birds = ["Blue", "Green", "Red"]
    
    private init() {}
    
    var bird: String {
        get {
            return birds[birdIndex]
        }
    }
    
    func changeBird() {
        if birdIndex < birds.count - 1 {
            birdIndex += 1
        } else {
            birdIndex = 0
        }
    }
    
    func setHighscore(_ highscore: Int) {
        UserDefaults.standard.set(highscore, forKey: "highscore")
    }
    
    func getHighscore() -> Int {
        return UserDefaults.standard.integer(forKey: "highscore")
    }
}
