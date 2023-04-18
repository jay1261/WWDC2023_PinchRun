//
//  GameScene.swift
//
//
//  Created by Jay on 2023/04/11.
//
import SpriteKit
import SwiftUI

enum GameState {
    case ready
    case playing
    case dead
}

class GameScene: SKScene, SKPhysicsContactDelegate {

    //---Cat---
    var canJump = true
    //---------
    let cameraNode = SKCameraNode()
    
    var timer: Timer?
    var timerNum: Int = 0
    var timerLabel: SKLabelNode!
    
    var cat = SKSpriteNode()
    
    override func didMove(to view: SKView) {
//        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        let gravity = -6.8 - Double(K.gameLevel) // 7.8 8.8 9.8   1 2 3
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0, dy: gravity)   // -9.8
        
        createBackground()
        createLand()
        createCat()
        createInfiniteObs(duration: 3)
                
        camera = cameraNode
        cameraNode.position.x = self.size.width / 2
        cameraNode.position.y = self.size.height / 2
        self.addChild(cameraNode)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            self.timerNum += 1
        }
        
        timerLabel = SKLabelNode(text: "0.0")
        timerLabel.fontName = "Copperplate"
        timerLabel.fontSize = 30
    
        timerLabel.position = CGPoint(x: size.width/2, y: size.height * 0.9)
        addChild(timerLabel)
        
        // 게임 스피드
        if K.gameLevel == 1 {
            speed = 1
        } else if K.gameLevel == 2{
            speed = 1.5
        } else {
            speed = 2
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first else { return }
//        let location = touch.location(in: self)
        
//        let box = SKSpriteNode(color: .red, size: CGSize(width: 150, height: 50))
//        box.position = location
//        box.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 150, height: 50))
//
//        addChild(box) // 오브젝트 뷰에 추가
    }
    
    override func update(_ currentTime: TimeInterval) {

        timerLabel.text = "Time: \(self.timerNum)"
        
        
        cat.zRotation = CGFloat(0)
        // 손 감지 -> 점프
        if(HandGestureProcessor.isPinched == true && canJump && HandGestureProcessor.isAparted){
            canJump = false
            HandGestureProcessor.isAparted = false
            // 점프
            self.cat.physicsBody?.velocity = (CGVector(dx: 0, dy: 0))
            self.cat.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 75000))
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
            print("obstacle, ")
            cameraShake()
            damageEffect()
            
            // 새로운 뷰 만들어서 띄우기
            self.cat.removeAllActions()
            speed = 0.1
            let score = timerNum * K.gameLevel
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                let gameOverView = GameOverView(score: score)
                let viewController = UIHostingController(rootView: gameOverView)
                if let view = self.view {
                    viewController.view.frame = view.bounds
                    viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    view.addSubview(viewController.view)
                }
            }
            timer?.invalidate()
            timer = nil
            break
        default:
            break
        }
    }
    
    
    
// MARK: - Sprite?
    
    func createCat(){
        let catTexture = SKTextureAtlas(named: "Cat")
        cat = SKSpriteNode(imageNamed: "cat1")
        cat.position = CGPoint(x: self.size.width / 4, y: self.size.height / 2)
        cat.zPosition = CGFloat(2)
        cat.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1300, height: 1532)) //width: 1824.0, height: 1532.0
        print("width: \(cat.size.width), height: \(cat.size.height)")
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
            // 사이즈 맞추기
            sky.size = CGSize(width: sky.size.width, height: self.size.height)
            
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
//            땅 사이즈...
//            land.size = CGSize(width: land.size.width, height: self.size.height / 4)
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
                                           y: 0, duration: 15.3)//20
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
        obstacle.setScale(0.2)
        addChild(obstacle)
        
        // 장애물 이동
//        let max = self.size.height * 0.3    //??
        
        let xPos = self.size.width
        let yPos = (envAtlas.textureNamed("land").size().height) //CGFloat(arc4random_uniform(UInt32(max)))
             
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
        let wait = SKAction.wait(forDuration: duration, withRange: 2)
        let actSeq = SKAction.sequence([create, wait])
        run(SKAction.repeatForever(actSeq))
    }
    
    func cameraShake() {
        let moveLeft = SKAction.moveTo(x: self.size.width / 2 - 5, duration: 0.1)
        let moveRight = SKAction.moveTo(x: self.size.width / 2 + 5, duration: 0.1)
        let moveReset = SKAction.moveTo(x: self.size.width / 2, duration: 0.1)
        let shakeAction = SKAction.sequence([moveLeft, moveRight, moveLeft, moveRight, moveReset])
        shakeAction.timingMode = .easeInEaseOut
        self.cameraNode.run(shakeAction)
    }
    
    func damageEffect() {
        let flashNode = SKSpriteNode(color: UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.7),
                                     size: self.size)
        let actionSequence = SKAction.sequence([SKAction.wait(forDuration: 0.01),
                                                SKAction.removeFromParent()])
        flashNode.name = "flashNode"
        flashNode.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        flashNode.zPosition = CGFloat(10)
        addChild(flashNode)
        flashNode.run(actionSequence)
    }
    
    
}
