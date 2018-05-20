//
//  MainmenuScene.swift
//  Flappy Bird
//
//  Created by Quan Lieu on 5/19/18.
//  Copyright © 2018 Quan Lieu. All rights reserved.
//

import SpriteKit

class MainmenuScene: SKScene {
    
    private var birdBtn = SKSpriteNode()
    private var scoreLabel = SKLabelNode()
    
    override func didMove(to view: SKView) {
        initialize()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if atPoint(location).name == "Play" {
                let gameplay = GameplayScene(fileNamed: "GameplayScene")
                gameplay?.scaleMode = .aspectFill
                self.view?.presentScene(gameplay!, transition: SKTransition.fade(withDuration: 1))
            } else if atPoint(location).name == "Highscore" {
                scoreLabel.removeFromParent()
                createScoreLabel()
            } else if atPoint(location).name == "Bird" {
                GameManager.instance.changeBird()
                self.birdBtn.removeFromParent()
                createBirdBtn()
            }
        }
    }
    
    func initialize() {
        createBG()
        createStartBtn()
        createBirdBtn()
    }
    
    func createBG() {
        self.addChild(SKSpriteNode(imageNamed: "BG Day"))
    }
    
    func createStartBtn() {
        let play = SKSpriteNode(imageNamed: "Play")
        let highscore = SKSpriteNode(imageNamed: "Highscore")

        play.name = "Play"
        play.position = CGPoint(x: -180, y: -50)
        play.zPosition = 1;
        play.setScale(0.7)
        
        highscore.name = "Highscore"
        highscore.position = CGPoint(x: 180, y: -50)
        highscore.zPosition = 1;
        highscore.setScale(0.7)
        
        self.addChild(play)
        self.addChild(highscore)
    }
    
    func createBirdBtn() {
        birdBtn = SKSpriteNode(imageNamed: "Blue 1")
        birdBtn.name = "Bird"
        birdBtn.position.y = 200
        birdBtn.setScale(1.3)
        birdBtn.zPosition = 1
        
        var birdAnim = [SKTexture]()
        for i in 1...3 {
            let name = "\(GameManager.instance.bird) \(i)"
            birdAnim.append(SKTexture(imageNamed: name))
        }
        
        let birdAction = SKAction.animate(with: birdAnim, timePerFrame: 0.1, resize: true, restore: true)
        birdBtn.run(SKAction.repeatForever(birdAction))
        self.addChild(birdBtn)
    }
    
    func createScoreLabel() {
        scoreLabel = SKLabelNode(fontNamed: "04b_19")
        scoreLabel.name = "Highscore"
        scoreLabel.fontSize = 120
        scoreLabel.position.y = -400
        scoreLabel.text = "\(GameManager.instance.getHighscore())"
        self.addChild(scoreLabel)
    }
}
