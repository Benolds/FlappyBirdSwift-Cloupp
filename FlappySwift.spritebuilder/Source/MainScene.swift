//
//  MainScene.swift
//  FlappySwift
//
//  Created by Benjamin Reynolds on 9/20/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

import Foundation

class MainScene: GameplayScene {
    
    var _ground1: CCNode? = nil
    var _ground2: CCNode? = nil
    var _grounds: [CCNode] = []
    
    var _sinceTouch: NSTimeInterval? = nil
    var _obstacles: [CCNode] = []
    var powerups: [CCNode] = []
    
    var _restartButton: CCButton? = nil
    
    var _gameOver:Bool = false
    var _scoreLabel: CCLabelTTF? = nil;
    var _nameLabel: CCLabelTTF? = nil;
    
    override init() {}
    
    // is called when CCB file has completed loading
    override func didLoadFromCCB() {
        userInteractionEnabled = true
        _grounds = [_ground1!, _ground2!]
        
        for ground in _grounds {
            // set collision type
            ground.physicsBody.collisionType = "level"
            ground.zOrder = DrawingOrder.Ground.toRaw()
        }
        
        //set this class as delegate
        physicsNode!.collisionDelegate = self
        
        _obstacles = []
        powerups = []
        points = 0
        
        trail = CCBReader.load("Trail") as CCParticleSystem?
        trail!.particlePositionType = CCParticleSystemPositionType.Relative
        physicsNode!.addChild(trail)
        trail!.visible = false
        
        super.initialize()
    }
    
    func addToScene(node: CCNode) {
        physicsNode!.addChild(node)
    }
    
    override func showScore() {
        _scoreLabel!.visible = true
    }
    
    override func updateScore() {
        _scoreLabel!.string = "\(points)"
    }
    
    override func touchBegan(touch: UITouch, withEvent event: UIEvent) {
        
        if !_gameOver {
            character!.physicsBody.applyAngularImpulse(10000.0)
            _sinceTouch = 0.0
            
            super.touchBegan(touch, withEvent:event)
            
        }
    }
    
    override func gameOver() {
        if !_gameOver {
            _gameOver = true
            _restartButton!.visible = true
            
            character!.physicsBody.velocity = CGPoint(x:0.0, y:character!.physicsBody.velocity.y)
            character!.rotation = 90.0
            character!.physicsBody.allowsRotation = false
            character!.stopAllActions()
            
            let moveBy:CCActionMoveBy = CCActionMoveBy(duration: 0.2, position:CGPoint(x:-2.0,y:2.0))
            let reverseMovement:CCActionInterval = moveBy.reverse()
            let shakeSequence:CCActionSequence = CCActionSequence(one: moveBy, two: reverseMovement)
            let bounce:CCActionEaseBounce = CCActionEaseBounce(action: shakeSequence)
            
            self.runAction(bounce)
        }
    }
    
}
