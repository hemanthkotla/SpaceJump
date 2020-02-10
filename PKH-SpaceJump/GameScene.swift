//
//  GameScene.swift
//  PKH-SpaceJump
//
//  Created by Hemanth Kotla on 2020-02-09.
//  Copyright © 2020 Hemanth Kotla. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    //nodes
    var player : SKNode?
    var joystick : SKNode?
    var joystickknob : SKNode?
    var Cameranode : SKCameraNode?
    var mountain1 : SKNode?
    var mountain2 : SKNode?
    var mountain3 : SKNode?
    var moon : SKNode?
    var stars : SKNode?
    
    //boolean
    
    var joystickAction = false
    var knobRadius : CGFloat = 50.0
    
    //spriteengine
    var previoustime : TimeInterval = 0
    var playerfacingright = true
    let playerspeed = 4.0
    
    //player state
    
    var playerstate : GKStateMachine!
    
    
    
    //didmove
    
    override func didMove(to view: SKView) {
        
      
        Cameranode = childNode(withName: "CameraNode") as? SKCameraNode
        mountain1 = childNode(withName: "Mountain1")
         mountain2 = childNode(withName: "Mountain2")
         mountain3 = childNode(withName: "Mountain4")
        moon = childNode(withName: "Moon")
        stars = childNode(withName: "stars")
        player = childNode(withName: "player")
        joystick = childNode(withName: "Joystick")
        joystickknob = joystick?.childNode(withName: "knob")
          playerstate = GKStateMachine(states: [
            Jumping(playerNode: player!),
            movingState(playerNode: player!),
            idleState(playerNode: player!),
            landingState(playerNode: player!),
            shockedState(playerNode: player!)
          ])
        playerstate.enter(idleState.self)
    }
    
   
}

//Touches

extension GameScene
{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
      {
           for touch in touches
           {
            if let joystickknob = joystickknob
            {
                let location = touch.location(in: joystick!)
                joystickAction = joystickknob.frame.contains(location)
            }
            
            let location = touch.location(in: self)
            if !(joystick?.contains(location))!
            {
                playerstate.enter(Jumping.self)
            }
        }
       }
       
       override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
       {
        guard let  joystick = joystick else {return}
        guard  let joystickKnob = joystickknob else {return}
        
        if !joystickAction {return}
        
        //distance
        
       for touch in touches
       {
        let position = touch.location(in: joystick)
        let length = sqrt(pow(position.y, 2) + pow(position.x, 2))
        let angle = atan2(position.y, position.x)
        
        if knobRadius > length
        {
            joystickKnob.position = position
        }
        else
        {
            joystickKnob.position = CGPoint(x: cos(angle) * knobRadius, y: sin(angle) * knobRadius)
        }
        
        }
           
       }
       
       override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
       {
        for touch in touches
        {
            let xCoordiante = touch.location(in: joystick!).x
            let xlimit : CGFloat = 200.0
            if xCoordiante > -xlimit && xCoordiante < xlimit
            {
                resetknob()
            }
        }
       }
    
    
    
}

//action

extension GameScene {

func resetknob()  {
    let intialpt = CGPoint(x: 0, y: 0)
    let moveback = SKAction.move(to: intialpt, duration: 0.1)
    moveback.timingMode = .linear
    joystickknob?.run(moveback)
    joystickAction = false
}
}



//loop

extension GameScene
{
    override func update(_ currentTime: TimeInterval) {
        let deltatime = currentTime - previoustime
        
        previoustime = currentTime
        
        
        //camera
        
        Cameranode?.position.x = player!.position.x
        joystick?.position.y = (Cameranode?.position.y)! - 100
        joystick?.position.x = (Cameranode?.position.x)! - 300
        
        
        
        //player movement
        
        guard let joystickknob = joystickknob else {return}
        let xpositon = Double(joystickknob.position.x)
        let positivePosition = xpositon > 0 ? -xpositon: xpositon
        
        if floor(positivePosition) != 0 {
            playerstate.enter(movingState.self)
        }
        else
        {
            playerstate.enter(idleState.self)
        }
        
        
        let displacement = CGVector(dx: deltatime * xpositon * playerspeed, dy: 0)
        let move = SKAction.move(by: displacement, duration: 0)
        let faceaction : SKAction!
        let moveright = xpositon > 0
        let moveleft = xpositon < 0
        
        if moveleft && playerfacingright
        {
            playerfacingright = false
            let facemovement = SKAction.scaleX(to: -1, duration:  0.0)
            
            faceaction = SKAction.sequence([move , facemovement])
            
        }
        
        else if moveright && !playerfacingright
        {
            playerfacingright = true
            
            let facemovement = SKAction.scaleX(to: 1, duration: 0.0)
            
            faceaction = SKAction.sequence([move, facemovement])
        }
        
        else
        {
            faceaction = move
        }
        
        player?.run(faceaction)
        
        //background parallax
        
        let parallax1 = SKAction.moveTo(x: (player?.position.x)!/(-10), duration: 0.0)
        mountain1?.run(parallax1)
        
        let parallax2  = SKAction.moveTo(x: (player?.position.x)!/(-20), duration: 0.0)
        mountain2?.run(parallax2)
        
        let parallax3 = SKAction.moveTo(x: (player?.position.x)!/(-40), duration: 0.0)
        mountain3?.run(parallax3)
        
        let parallax4 = SKAction.moveTo(x: (Cameranode?.position.x)!, duration: 0.0)
        moon?.run(parallax4)
        
        let parallax5 = SKAction.moveTo(x: (Cameranode?.position.x)!, duration: 0.0)
               stars?.run(parallax5)
        
        
        
        
    }
}
