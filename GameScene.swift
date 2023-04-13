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
    
    override func didMove(to view: SKView) {
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
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
            let box = SKSpriteNode(color: .red, size: CGSize(width: 150, height: 50))
            box.position = CGPoint(x: 500, y: 500)
            box.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 150, height: 50))
            
            addChild(box) // 오브젝트 뷰에 추가
        }
        
    }
    
}
