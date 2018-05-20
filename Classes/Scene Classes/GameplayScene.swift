//
//  GameplayScene.swift
//  Flappy Bird
//
//  Created by Quan Lieu on 5/18/18.
//  Copyright © 2018 Quan Lieu. All rights reserved.
//

import SpriteKit

class GameplayScene: SKScene, SKPhysicsContactDelegate {
    
    private var bird = Bird()
    private var pipesHolder = SKNode()
    private var scoreLabel = SKLabelNode(fontNamed: "04b_19")
    private var guide = SKSpriteNode()
    
    private var score = 0
    private var gameStarted = false
    private var isAlive = false
    
    override func didMove(to view: SKView) {
        initialize()
    }
    
    override func update(_ currentTime: TimeInterval) {
        if isAlive {
            moveBackgroundAndGround()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !gameStarted {
            // First touch
            isAlive = true
            gameStarted = true
            spawnPipes()
            guide.removeFromParent()
            bird.physicsBody?.affectedByGravity = true
        }
        
        if isAlive {
            bird.flap()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            switch atPoint(location).name {
            case "Retry":
                self.removeAllActions()
                self.removeAllChildren()
                initialize()
            case "Quit":
                let mainmenu = MainmenuScene(fileNamed: "MainmenuScene")
                mainmenu?.scaleMode = .aspectFill
                self.view?.presentScene(mainmenu!, transition: SKTransition.fade(withDuration: 1))
            default:
                break
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        //        let birdBody = contact.bodyA.node?.name == "Bird" ? contact.bodyA : contact.bodyB // TODO: Remove
        let objectBody = contact.bodyA.node?.name == "Bird" ? contact.bodyB : contact.bodyA
        
        if objectBody.node?.name == "Score" {
            increaseScore()
        } else if objectBody.node?.name == "Pipe" || objectBody.node?.name == "Ground" {
            if isAlive {
                birdDied()
                saveScore()
            }
        }
    }
    
    func initialize() {
        gameStarted = false
        isAlive = false
        score = 0
        
        physicsWorld.contactDelegate = self
        showIntruction()
        birdInit()
        scoreLabelInit()
        backgroundInit()
        groundInit()
    }
    
    func showIntruction() {
        guide = SKSpriteNode(imageNamed: "Press")
        guide.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        guide.setScale(1.8)
        guide.zPosition = 4
        self.addChild(guide)
    }
    
    func birdInit() {
        bird = Bird(imageNamed: "\(GameManager.instance.bird) 1")
        bird.initialize()
        bird.position = CGPoint(x: -50, y: 0)
        self.addChild(bird)
    }
    
    func birdDied() {
        let retry = SKSpriteNode(imageNamed: "Retry")
        let quit = SKSpriteNode(imageNamed: "Quit")
        let scaleUp = SKAction.scale(to: 1, duration: 0.5)
        
        retry.name = "Retry"
        retry.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        retry.position.x = -150
        retry.zPosition = 4
        retry.setScale(0)
        
        quit.name = "Quit"
        quit.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        quit.position.x = 150
        quit.zPosition = 4
        quit.setScale(0)
        
        retry.run(scaleUp)
        quit.run(scaleUp)
        
        self.addChild(retry)
        self.addChild(quit)
        
        self.isAlive = false
        self.removeAction(forKey: "Spawn")
        for child in self.children {
            if child.name == "Holder" {
                child.removeAction(forKey: "Move")
            }
        }
        
        bird.texture = bird.diedTexture
    }
    
    func saveScore() {
        let highscore = GameManager.instance.getHighscore()
        if highscore < score {
            GameManager.instance.setHighscore(score)
        }
    }
    
    func createPipes() {
        let pipeUp = SKSpriteNode(imageNamed: "Pipe 1")
        let pipeDown = SKSpriteNode(imageNamed: "Pipe 1")
        let scoreNode = SKSpriteNode()
        pipesHolder = SKNode()
        
        pipeUp.name = "Pipe"
        pipeUp.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        pipeUp.position = CGPoint(x: 0, y: 550)
        pipeUp.zRotation = CGFloat(Double.pi)
        pipeUp.physicsBody = SKPhysicsBody(rectangleOf: pipeUp.size)
        pipeUp.physicsBody?.categoryBitMask = ColliderType.Pipes.rawValue
        pipeUp.physicsBody?.isDynamic = false
        
        pipeDown.name = "Pipe"
        pipeDown.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        pipeDown.position = CGPoint(x: 0, y: -550)
        pipeDown.physicsBody = SKPhysicsBody(rectangleOf: pipeUp.size)
        pipeDown.physicsBody?.categoryBitMask = ColliderType.Pipes.rawValue
        pipeDown.physicsBody?.isDynamic = false
        
        scoreNode.name = "Score"
        scoreNode.position = CGPoint(x: 0, y: 0)
        scoreNode.size = CGSize(width: 2, height: 300)
        scoreNode.physicsBody = SKPhysicsBody(rectangleOf: scoreNode.size)
        scoreNode.physicsBody?.categoryBitMask = ColliderType.Score.rawValue
        scoreNode.physicsBody?.collisionBitMask = 0
        scoreNode.physicsBody?.isDynamic = false
        
        pipesHolder.name = "Holder"
        pipesHolder.zPosition = 1
        pipesHolder.position.x = self.frame.width + 100
        pipesHolder.position.y = CGFloat.randomNumberBetween(min: -300, max: 300)
        pipesHolder.addChild(pipeUp)
        pipesHolder.addChild(pipeDown)
        pipesHolder.addChild(scoreNode)
        
        let destination = -(self.frame.width * 2)
        let move = SKAction.moveTo(x: destination, duration: 10)
        let remove = SKAction.removeFromParent()
        
        self.addChild(pipesHolder)
        pipesHolder.run(SKAction.sequence([move, remove]), withKey: "Move")
    }
    
    func spawnPipes() {
        let spawn = SKAction.run {
            self.createPipes()
        }
        let delay = SKAction.wait(forDuration: 2)
        let sequence = SKAction.sequence([spawn, delay])
        self.run(SKAction.repeatForever(sequence), withKey: "Spawn")
    }
    
    func scoreLabelInit() {
        scoreLabel.zPosition = 3
        scoreLabel.position = CGPoint(x: 0, y: 450)
        scoreLabel.fontSize = 120
        scoreLabel.text = "0"
        self.addChild(scoreLabel)
    }
    
    func increaseScore() {
        self.score += 1
        scoreLabel.text = String(self.score)
    }
    
    func backgroundInit() {
        for i in 0...2 {
            let bg = SKSpriteNode(imageNamed: "BG Day")
            bg.name = "BG"
            bg.zPosition = 0
            bg.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            bg.position = CGPoint(x: CGFloat(i) * bg.size.width, y: 0)
            self.addChild(bg)
        }
    }
    
    func groundInit() {
        for i in 0...2 {
            let ground = SKSpriteNode(imageNamed: "Ground")
            ground.name = "Ground"
            ground.zPosition = 2
            ground.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            ground.position = CGPoint(x: CGFloat(i) * ground.size.width, y: -(self.frame.size.height / 2))
            ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
            // No need Collision and Contact bit mask
            ground.physicsBody?.categoryBitMask = ColliderType.Bird.rawValue
            ground.physicsBody?.isDynamic = false
            self.addChild(ground)
        }
    }
    
    func moveBackgroundAndGround() {
        let handler: (SKNode, UnsafeMutablePointer<ObjCBool>) -> Void = {
            (node, error) in
            node.position.x -= 4.5
            if node.position.x < -(self.frame.width) {
                node.position.x += self.frame.width * 3
            }
        }
        
        enumerateChildNodes(withName: "BG", using: handler)
        enumerateChildNodes(withName: "Ground", using: handler)
    }
}
