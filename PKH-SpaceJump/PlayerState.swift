//
//  PlayerState.swift
//  PKH-SpaceJump
//
//  Created by Hemanth Kotla on 2020-02-09.
//  Copyright © 2020 Hemanth Kotla. All rights reserved.
//

import Foundation
import GameplayKit

fileprivate let characterAnimation = "sprit Animation"

class PlayerState: GKState {
    
    unowned var playerNode : SKNode
    
     init( playerNode : SKNode ) {
        self.playerNode = playerNode
        
        super.init()
    }

}

class Jumping: PlayerState {
    
    var finishedJumping : Bool = false
    
    
    //func for allowing transition from one state to the other
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        
//        if finishedJumping && stateClass is landingState.Type {return true}
        return true
        
    }
    let textures : Array<SKTexture> = (0..<2).map({return "Jump\($0)"}).map(SKTexture.init)
    lazy var action = { SKAction.animate(with: textures , timePerFrame: 0.1) } ()
    
    
    //func for performing action
    override func didEnter(from previousState: GKState?) {
        
        playerNode.removeAction(forKey: characterAnimation)
        playerNode.run(action, withKey: characterAnimation)
        
        finishedJumping = false
        
        playerNode.run(.applyForce(CGVector(dx: 0, dy: 75), duration: 0.1 ))
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { (timer) in self.finishedJumping = true }
        
        
    }
}



class landingState : PlayerState
{
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is landingState.Type, is Jumping.Type: return false
            
        default:
            return true
        }
    }
    
    override func didEnter(from previousState: GKState?)
    {
        stateMachine?.enter(idleState.self)
    }
    
}

class idleState : PlayerState
{
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
            case is landingState.Type, is idleState.Type: return false
                
            default:
                return true
            }
        }
    
    let textures = SKTexture(imageNamed: "Player0")
        lazy var action = { SKAction.animate(with: [textures], timePerFrame: 0.1) } ()
    
    override func didEnter(from previousState: GKState?) {
        playerNode.removeAction(forKey: characterAnimation)
        playerNode.run(action, withKey: characterAnimation)
    }
    }
    

class movingState : PlayerState
{
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
    switch stateClass {
        case is landingState.Type, is movingState.Type: return false
            
        default:
            return true
        }
    }
    
    let textures : Array<SKTexture> = (0..<6).map({ return "Player\($0)" }).map(SKTexture.init)
    lazy var action = { SKAction.repeatForever(.animate(with: textures, timePerFrame: 0.1)) } ()
    
    override func didEnter(from previousState: GKState?) {
        playerNode.removeAction(forKey: characterAnimation)
        playerNode.run(action, withKey: characterAnimation)
    }
    
}

class shockedState : PlayerState
{
    
}
