//  Created by Hemanth Kotla(301084656), Pratiksha Kathiriya (301093309), Kevin Nobel (301093673) on 2020-01-17.
// last modified on 2020-02-16
// File Description : Game view controller
// Revision history :
// v1 : Added assets and the scenes for the world 1
// v2: Added Player Movement and Joystick Movement
// v3 : Added the player state (moving/idle/jump) using the GKStatemachine
// v4 : Added Camera. parallax animation for mountains and stars
//v5 : Added collision and the app icon
//v6 : Added scoring system
//v7 : Added sound and Level 2
//v8 : added intro scene

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
        
        if stateClass is shockedState.Type { return true }
        
        if finishedJumping && stateClass is landingState.Type {return true}
        return false
        
    }
    let textures : Array<SKTexture> = (0..<2).map({return "Jump\($0)"}).map(SKTexture.init)
    lazy var action = { SKAction.animate(with: textures , timePerFrame: 0.1) } ()
    
    
    //func for performing action
    override func didEnter(from previousState: GKState?) {
        
        playerNode.removeAction(forKey: characterAnimation)
        playerNode.run(action, withKey: characterAnimation)
        
        finishedJumping = false
        
        playerNode.run(.applyForce(CGVector(dx: 0, dy: 160), duration: 0.1 ))
        
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
    var isshocked : Bool = false
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        if isshocked {return false}
        
        switch stateClass {
        case is idleState.Type: return true
            
        default:
            return false
        }
    }
    let action = SKAction.repeat(.sequence([
        .fadeAlpha(to: 0.5, duration: 0.01),
        .wait(forDuration: 0.25),
        .fadeAlpha(to: 1.0, duration: 0.01),
        .wait(forDuration: 0.25),]), count: 5)
    
    override func didEnter(from previousState: GKState?) {
        isshocked = true
        playerNode.run(action)
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { (timer) in
            self.isshocked = false
            self.stateMachine?.enter(idleState.self)
        }
    }
}
