//
//  Level2.swift
//  PKH-SpaceJump
//
//  Created by Hemanth Kotla on 2020-02-12.
//  Copyright © 2020 Hemanth Kotla. All rights reserved.
//

import Foundation
import SpriteKit
class Level2: GameScene
{
    

    override func didMove(to view: SKView)
    {
        super.didMove(to: view)
    }
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
        
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
    }
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        if score == 3 {
            let nextLevel = GameScene(fileNamed: "Winner")
            nextLevel?.scaleMode = .aspectFill
            view?.presentScene(nextLevel)
            run(Sound.levelUp.action)
        }
       
    }
}
