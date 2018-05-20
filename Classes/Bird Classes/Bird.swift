//
//  GameplayScene.swift
//  Flappy Bird
//
//  Created by Quan Lieu on 5/19/18.
//  Copyright © 2018 Quan Lieu. All rights reserved.
//

import SpriteKit

enum ColliderType: UInt32 {
    case Bird = 1, Ground, Pipes, Score
}

class Bird: SKSpriteNode {
    
    var diedTexture = SKTexture()
    private var birdAnimation = [SKTexture]()
    private var birdAnimationAction = SKAction()
    
    func initialize() {
        for i in 2...3 {
            let name = "\(GameManager.instance.bird) \(i)"
            self.birdAnimation.append(SKTexture(imageNamed: name))
        }
        
        self.birdAnimationAction = SKAction.animate(with: self.birdAnimation, timePerFrame: 0.08, resize: true, restore: true)
        
        self.diedTexture = SKTexture(imageNamed: "\(GameManager.instance.bird) 4")
        
        self.name = "Bird"
        self.zPosition = 2
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.height / 2)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = ColliderType.Bird.rawValue
        self.physicsBody?.collisionBitMask = ColliderType.Ground.rawValue | ColliderType.Pipes.rawValue
        self.physicsBody?.contactTestBitMask = ColliderType.Ground.rawValue | ColliderType.Pipes.rawValue | ColliderType.Score.rawValue
        
    }
    
    func flap() {
        self.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        self.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 120))
        self.run(birdAnimationAction)
    }
}
