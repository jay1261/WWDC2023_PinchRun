//
//  GameScene.swift
//
//
//  Created by Jay on 2023/04/11.
//
import SpriteKit
import SwiftUI

struct PhysicsCategory {
    static let cat: UInt32 = 0x1 << 0  // 1
    static let land: UInt32 = 0x1 << 1  // 2
    static let obstacle: UInt32 = 0x1 << 2  // 4
    static let score: UInt32 = 0x1 << 3 // 8
}


class GameScene: SKScene, SKPhysicsContactDelegate {
    private var gestureProcessor = HandGestureProcessor()
    //---Cat---
    var canJump = true
    //---------
    
    
    var cat = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -7.8)   // -9.8
        
        createBackground()
        createLand()
        createCat()
        createInfiniteObs(duration: 3)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        let box = SKSpriteNode(color: .red, size: CGSize(width: 150, height: 50))
        box.position = location
        box.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 150, height: 50))
        
        addChild(box) // 오브젝트 뷰에 추가
    }
    
    override func update(_ currentTime: TimeInterval) {
        cat.zRotation = CGFloat(0)
        
        if(HandGestureProcessor.isPinched == true && canJump){
            canJump = false
            // 점프
            self.cat.physicsBody?.velocity = (CGVector(dx: 0, dy: 0))
            self.cat.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 100000))
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var collideBody = SKPhysicsBody()

        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            collideBody = contact.bodyB
        } else {
            collideBody = contact.bodyA
        }

        let collideType = collideBody.categoryBitMask
        switch collideType{
        case PhysicsCategory.land:
            print("Land")
            self.canJump = true
            break
        case PhysicsCategory.obstacle:
            print("obstacle")
            break
        default:
            break
        }
//        if contact.bodyA.node?.name == "cat" && contact.bodyB.node?.name == "land"{
//            print("land")
//        }
    }
    
    
    
// MARK: - Sprite?
    
    func createCat(){
        let catTexture = SKTextureAtlas(named: "Cat")
        cat = SKSpriteNode(imageNamed: "cat1")
        cat.position = CGPoint(x: self.size.width / 4, y: self.size.height / 2)
        cat.zPosition = CGFloat(2)
        cat.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: cat.size.width, height: cat.size.height))
        cat.physicsBody?.categoryBitMask = PhysicsCategory.cat
        cat.name = "cat"
        cat.physicsBody?.contactTestBitMask = PhysicsCategory.land | PhysicsCategory.obstacle  // 2, 8
        cat.physicsBody?.affectedByGravity = true
        cat.setScale(0.07)
        addChild(cat)
        
        // 애니메이션
        var aniArray = [SKTexture]()
        for i in 1...catTexture.textureNames.count {
            aniArray.append(SKTexture(imageNamed: "cat\(i)"))
        }
        let runningAnimation = SKAction.animate(with: aniArray, timePerFrame: 0.1)
        
        cat.run(SKAction.repeatForever(runningAnimation))
    }
        
    func createBackground(){
        let envAtlas = SKTextureAtlas(named: "Environment")
        let skyTexture = envAtlas.textureNamed("background")

        let skyRepeatNum = Int(ceil(self.size.width / skyTexture.size().width))

        for i in 0...skyRepeatNum {
            let sky = SKSpriteNode(texture: skyTexture)
            sky.anchorPoint = CGPoint.zero
            sky.position = CGPoint(x: CGFloat(i) * sky.size.width, y: 0)
            sky.zPosition = CGFloat(0)
            addChild(sky)
            
            let moveLeft = SKAction.moveBy(x: -skyTexture.size().width,
                                           y: 0, duration: 40)
            let moveReset = SKAction.moveBy(x: skyTexture.size().width,
                                            y: 0, duration: 0)
            let moveSequence = SKAction.sequence([moveLeft, moveReset])
            sky.run(SKAction.repeatForever(moveSequence))
        }
    }
    
    func createLand(){
        let envAtlas = SKTextureAtlas(named: "Environment")
        let landTexture = envAtlas.textureNamed("land")
        let landRepeatNum = Int(ceil(self.size.width / landTexture.size().width))
        
        for i in 0...landRepeatNum {
            let land = SKSpriteNode(texture: landTexture)
            land.anchorPoint = CGPoint.zero
            land.position = CGPoint(x: CGFloat(i) * land.size.width, y: 0)
            land.zPosition = CGFloat(2)
            
            land.physicsBody = SKPhysicsBody(rectangleOf: land.size,
                                             center: CGPoint(x: land.size.width / 2,
                                                             y: land.size.height / 2 - 30))
            land.name = "land"
            land.physicsBody?.categoryBitMask = PhysicsCategory.land
            land.physicsBody?.affectedByGravity = false
            land.physicsBody?.isDynamic = false
            addChild(land)
            
            let moveLeft = SKAction.moveBy(x: -landTexture.size().width,
                                           y: 0, duration: 20)
            let moveReset = SKAction.moveBy(x: landTexture.size().width,
                                            y: 0, duration: 0)
            let moveSequence = SKAction.sequence([moveLeft, moveReset])
            land.run(SKAction.repeatForever(moveSequence))
        }
    }
    
    func createObstacle(){
        let envAtlas = SKTextureAtlas(named: "Environment")
        let obstacleTexture = envAtlas.textureNamed("obstacle")
        
        // 장애물
        let obstacle = SKSpriteNode(texture: obstacleTexture)
        obstacle.zPosition = CGFloat(2)
        obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacleTexture.size())
        obstacle.physicsBody?.categoryBitMask = PhysicsCategory.obstacle
        obstacle.setScale(0.5)
        addChild(obstacle)
        
        // 장애물 이동
        let max = self.size.height * 0.3    //??
        let xPos = self.size.width - obstacle.size.width
        let yPos = CGFloat(arc4random_uniform(UInt32(max)))
            + (envAtlas.textureNamed("land").size().height)
        let endPos = self.size.width + (obstacle.size.width * 2)
        obstacle.position = CGPoint(x: xPos, y: yPos)
        let moveAct = SKAction.moveBy(x: -endPos, y: 0, duration: 6)
        let moveSeq = SKAction.sequence([moveAct, SKAction.removeFromParent()])
        
        obstacle.run(moveSeq)
    }
    
    func createInfiniteObs(duration: TimeInterval){
        let create = SKAction.run { [unowned self] in
            self.createObstacle()
        }
        let wait = SKAction.wait(forDuration: duration)
        let actSeq = SKAction.sequence([create, wait])
        run(SKAction.repeatForever(actSeq))
    }
    
}
