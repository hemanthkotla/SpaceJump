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
    var oxygenisnottouched = true
    var iscollided = false
    
    //spriteengine
    var previoustime : TimeInterval = 0
    var playerfacingright = true
    let playerspeed = 5.0
    
    //player state
    
    var playerstate : GKStateMachine!
    
    //score
    
    var scorelabel = SKLabelNode()
    var score = 0
    
    //lives
    
    var livesArray = [SKSpriteNode]()
    let container = SKSpriteNode()
    
    
    
    
    //didmove
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
//
//        let soundaction = SKAction.repeatForever(SKAction.playSoundFileNamed("backost.wav", waitForCompletion: false))
//        run(soundaction)
      
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
        
        //lives
        container.position = CGPoint(x: -300, y: 140)
        container.zPosition = 5
        Cameranode?.addChild(container)
        
        listlives(count: 3)
        
        
        //timer for meteor
        Timer.scheduledTimer(withTimeInterval: 2, repeats: true) {(timer) in
            self.renderMeteor()
        }
        
        scorelabel.position = CGPoint(x: (Cameranode?.position.x)! + 310, y: 140)
        
        scorelabel.fontColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        scorelabel.fontSize = 24
        scorelabel.fontName = "Arial"
        scorelabel.horizontalAlignmentMode = .right
        scorelabel.text = String(score)
        Cameranode?.addChild(scorelabel)
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
                run(Sound.jump.action)
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
            playerstate.enter(landingState.self)
            
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
    func oxygentouch()  {
        score += 1
        scorelabel.text = String(score)
    }
    func listlives(count: Int)
        
    {
        for i in 1...count
        {
            let lives = SKSpriteNode(imageNamed: "heart")
            let xposition = lives.size.width * CGFloat(i - 1)
            lives.position = CGPoint(x: xposition, y: 0)
            livesArray.append(lives)
            container.addChild(lives)
        }
    }
    
   func  looselife()
   {
    if iscollided == true
    {
        let lastelement = livesArray.count - 1
        if livesArray.indices.contains(lastelement - 1)
        {
            let lastlife = livesArray[lastelement]
            lastlife.removeFromParent()
            livesArray.remove(at: lastelement)
            Timer.scheduledTimer(withTimeInterval: 2, repeats: true)
            {(timer) in
                self.iscollided = false
            }
        }
        else
        {
            dying()
            gameoverscene()
        }
        imorttal()
    }
    }
   func imorttal()
   {
    player?.physicsBody?.categoryBitMask = 0
    Timer.scheduledTimer(withTimeInterval: 2, repeats: false)
    {(timer) in
        self.player?.physicsBody?.categoryBitMask = 2
    }
    }
    
    func dying()
    {
        let dieAction = SKAction.move(to: CGPoint(x: -300, y: 0), duration: 0.1)
        player?.run(dieAction)
        self.removeAllActions()
        listlives(count: 3)
    }
    func gameoverscene()
    {
        let gameoverScene = GameScene(fileNamed: "GameOver")
        self.view?.presentScene(gameoverScene)
    }
    
    
}



//loop

extension GameScene
{
    override func update(_ currentTime: TimeInterval) {
        let deltatime = currentTime - previoustime
        
        previoustime = currentTime
        
        oxygenisnottouched = true
        
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


//collision

extension GameScene : SKPhysicsContactDelegate
{
    struct Collision {
        enum mask: Int
        {
            case kill, player, oxygen , ground
            var bitmask: UInt32 { return 1 << self.rawValue }
            
        }
        let masks: (first: UInt32, second: UInt32)
        
        func matches (_ first: mask, _ second: mask) -> Bool
        {
            return (first.bitmask == masks.first && second.bitmask == masks.second ) || (first.bitmask == masks.second && second.bitmask == masks.first )
        }
    }
    func didBegin(_ contact: SKPhysicsContact) {
        let collision = Collision(masks: (first: contact.bodyA.categoryBitMask, second: contact.bodyB.categoryBitMask))
        
        if collision.matches(.player, .kill)
        {
          looselife()
            iscollided = true
            run(Sound.hit.action)
            playerstate.enter(shockedState.self)
        }
        
        if collision.matches(.player, .ground) {
            playerstate.enter(landingState.self)
               }
       
        if collision.matches(.player, .oxygen)
        {
            if contact.bodyA.node?.name == "oxygen" {
                contact.bodyA.node?.physicsBody?.categoryBitMask = 0
                
            }
            
            else  if contact.bodyB.node?.name == "oxygen" {
                           contact.bodyB.node?.physicsBody?.categoryBitMask = 0
                contact.bodyB.node?.removeFromParent()
                       }
            
            if oxygenisnottouched
            {
                oxygentouch()
                oxygenisnottouched = false
            }
            run(Sound.oxygen.action)
        }
        
        
        
        
        if collision.matches(.ground, .kill) {
                   if contact.bodyA.node?.name == "Meteor", let meteor = contact.bodyA.node {
                       createMolten(at: meteor.position)
                       meteor.removeFromParent()
                   }
                   
                   if contact.bodyB.node?.name == "Meteor", let meteor = contact.bodyB.node {
                       createMolten(at: meteor.position)
                       meteor.removeFromParent()
                   }
            run(Sound.meteorFalling.action)
               }
        
        
    }
}

//meteor

extension GameScene
{



func renderMeteor() {
    
    let node = SKSpriteNode(imageNamed: "meteor")
    node.name = "Meteor"
    let randomXPosition = Int(arc4random_uniform(UInt32(self.size.width)))
    
    node.position = CGPoint(x: randomXPosition, y: 270)
    node.anchorPoint = CGPoint(x: 0.5, y: 1)
    node.zPosition = 5
    
    let physicsBody = SKPhysicsBody(circleOfRadius: 30)
    node.physicsBody = physicsBody
    
    physicsBody.categoryBitMask = Collision.mask.kill.bitmask
    physicsBody.collisionBitMask = Collision.mask.player.bitmask | Collision.mask.ground.bitmask
    physicsBody.contactTestBitMask = Collision.mask.player.bitmask | Collision.mask.ground.bitmask
    physicsBody.fieldBitMask = Collision.mask.player.bitmask | Collision.mask.ground.bitmask
    
    physicsBody.affectedByGravity = true
    physicsBody.allowsRotation = false
    physicsBody.restitution = 0.2
    physicsBody.friction = 10
    
    addChild(node)
    }
    
    func createMolten(at position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "molten")
        node.position.x = position.x
        node.position.y = position.y - 110
        node.zPosition = 4
        
        addChild(node)
        
        let action = SKAction.sequence([
            SKAction.fadeIn(withDuration: 0.1),
            SKAction.wait(forDuration: 3.0),
            SKAction.fadeOut(withDuration: 0.2),
            SKAction.removeFromParent(),
            ])
        
        node.run(action)
    }
    
    
    
    
}
