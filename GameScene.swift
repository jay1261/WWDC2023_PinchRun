//
//  GameScene.swift
//
//
//  Created by Jay on 2023/04/11.
//
import SpriteKit
import SwiftUI

class GameScene: SKScene {
    private var gestureProcessor = HandGestureProcessor()
    
    var cat = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        createBackground()
        createLand()
        createCat()
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
        if(HandGestureProcessor.isPinched == true){
            HandGestureProcessor.isPinched = false
//            let box = SKSpriteNode(color: .red, size: CGSize(width: 150, height: 50))
//            box.position = CGPoint(x: 500, y: 500)
//            box.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 150, height: 50))
//
//            addChild(box) // 오브젝트 뷰에 추가
            
            // 점프
            self.cat.physicsBody?.velocity = (CGVector(dx: 0, dy: 0))
            self.cat.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 70000))
        }
    }
    
    func createCat(){
        let catTexture = SKTextureAtlas(named: "Cat")
        cat = SKSpriteNode(imageNamed: "cat1")
        cat.position = CGPoint(x: self.size.width / 4, y: self.size.height / 2)
        cat.zPosition = CGFloat(2)
        cat.physicsBody = SKPhysicsBody(rectangleOf: cat.size)
        cat.physicsBody?.categoryBitMask = UInt32(0x1)
        cat.physicsBody?.affectedByGravity = true
        cat.setScale(0.1)
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
                                                             y: land.size.height / 2))
            land.physicsBody?.categoryBitMask = UInt32(0x1 << 1) // 2
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
    
}
