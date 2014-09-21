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
    
    var _sinceTouch: NSTimeInterval = 0
    var _obstacles: [Obstacle] = []
    var powerups: [CCNode] = []
    
    var _restartButton: CCButton? = nil
    
    var _gameOver:Bool = false
    var _scoreLabel: CCLabelTTF? = nil;
    var _nameLabel: CCLabelTTF? = nil;
    
    override init() {}
    
    // is called when CCB file has completed loading
    func didLoadFromCCB() {
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
        
//        super.initialize()
    }
    
    func addToScene(node: CCNode) {
        physicsNode!.addChild(node)
    }
    
    func showScore() {
        _scoreLabel!.visible = true
    }
    
    func updateScore() {
        _scoreLabel!.string = "\(points)"
    }
    
    override func touchBegan(touch: UITouch, withEvent event: UIEvent) {
        
        if !_gameOver {
            character!.physicsBody.applyAngularImpulse(10000.0)
            _sinceTouch = 0.0
            
            super.touchBegan(touch, withEvent:event)
        }
    }
    
    func gameOver() {
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
    
    func restart() {
        let scene:CCScene = CCBReader.loadAsScene("MainScene")
        CCDirector.sharedDirector().replaceScene(scene)
    }
    
    func addObstacle() {
        let obstacle:Obstacle = CCBReader.load("Obstacle") as Obstacle
        let screenPosition = self.convertToWorldSpace(CGPoint(x:380,y:0))
        let worldPosition = physicsNode!.convertToNodeSpace(screenPosition)
        obstacle.position = worldPosition
        obstacle.setupRandomPosition()
        obstacle.zOrder = DrawingOrder.Pipes.toRaw()
        physicsNode!.addChild(obstacle)
        _obstacles.append(obstacle)
    }
    
    func addPowerup() {
        let powerup:CCSprite = CCBReader.load("Powerup") as CCSprite
        
        let first:Obstacle = _obstacles[0]
        let second:Obstacle = _obstacles[1]
        let last:Obstacle = _obstacles.last!
        
        powerup.position = CGPoint(x:last.position.x + (second.position.x-first.position.x)/4.0 + character!.contentSize.width, y:CGFloat(arc4random()%488)+200)
    }
    
    override func update(delta: CCTime) {
        _sinceTouch += delta
//        character!.rotation = max(-30, min(character!.rotation, 90.0))
        character!.rotation = clampf(character!.rotation, -30.0, 90.0)
        trail!.position = character!.position

        let r = arc4random() % 255
        let g = arc4random() % 255
        let b = arc4random() % 255
        
//        trail!.startColor = CCColor(red:r, green:g, blue:b)
        
        //CCColor(ccColor3b: ccc3(arc4random() % 255, arc4random() % 255, arc4random() % 255))
        
        if character!.physicsBody.allowsRotation {
            let angularVelocity = clampf(Float(character!.physicsBody.angularVelocity), -2.0, 1.0)
            character!.physicsBody.angularVelocity = CGFloat(angularVelocity)
        }

        if _sinceTouch > 0.5 {
            character!.physicsBody.applyAngularImpulse(CGFloat(-40000.0 * delta)) //(-40000.0 * delta) )
        }
        
        physicsNode!.position = CGPoint(x:physicsNode!.position.x - (character!.physicsBody.velocity.x * CGFloat(delta)),y:physicsNode!.position.y)
        
        for ground in _grounds {
            let groundWorldPosition = physicsNode!.convertToWorldSpace(ground.position)
            let groundScreenPosition = self.convertToNodeSpace(groundWorldPosition)
            
            if groundScreenPosition.x <= (-1 * ground.contentSize.width) {
                ground.position = CGPoint(x:ground.position.x + 2 * ground.contentSize.width, y:ground.position.y)
            }
        }
        
        var offScreenObstacles:[Obstacle] = []
        
        for obstacle in _obstacles {
            let obstacleWorldPosition = physicsNode!.convertToWorldSpace(obstacle.position)
            let obstacleScreenPosition = self.convertToNodeSpace(obstacleWorldPosition)
            
            if obstacleScreenPosition.x < -obstacle.contentSize.width {
                offScreenObstacles.append(obstacle)
            }
        }
        
        if !_gameOver {
            character!.physicsBody.velocity = CGPoint(x:character!.physicsBody.velocity.x, y: min(character!.physicsBody.velocity.y, 200.0))
            super.update(delta)
        }
        
    }
    
}
