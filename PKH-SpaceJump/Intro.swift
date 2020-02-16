//
//  Intro.swift
//  PKH-SpaceJump
//
//  Created by Hemanth Kotla on 2020-02-16.
//  Copyright © 2020 Hemanth Kotla. All rights reserved.
//

import Foundation
import SpriteKit
class Intro: GameScene {
    override func didMove(to view: SKView)
    {
        super.didMove(to: view)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        super.touchesBegan(touches, with: event)
        let nextLevel = GameScene(fileNamed: "Level1")
        nextLevel?.scaleMode = .aspectFill
        view?.presentScene(nextLevel)
        
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
    }
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
    }
}
