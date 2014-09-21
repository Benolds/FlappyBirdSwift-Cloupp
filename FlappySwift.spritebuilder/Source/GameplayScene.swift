//
//  GameplayScene.swift
//  FlappySwift
//
//  Created by Benjamin Reynolds on 9/20/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

import Foundation

enum DrawingOrder: Int {
    case Pipes
    case Ground
    case Hero
}

class GameplayScene: CCNode, CCPhysicsCollisionDelegate {
    
    var character: Character? = nil
    var physicsNode: CCPhysicsNode? = nil
    var trail: CCParticleSystem? = nil
    var points: Int = 0
    
    override init() { }
    
    // is called when CCB file has completed loading
    func didLoadFromCCB() {
    }
    
    func initialize() {}
    
    func addObstacle() {}
    
    func showScore() {}
    
    func updateScore() {}
    
    func gameOver() {}
    
    func addPowerup() {}
    
}
