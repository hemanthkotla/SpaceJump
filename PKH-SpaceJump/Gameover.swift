//
//  Gameover.swift
//  PKH-SpaceJump
//
//  Created by Hemanth Kotla on 2020-02-12.
//  Copyright © 2020 Hemanth Kotla. All rights reserved.
//

import Foundation
import SpriteKit
class GameOver : SKScene
{
    override func sceneDidLoad() {
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (timer) in
            let level1 = GameScene(fileNamed: "Level1")
            self.view?.presentScene(level1)
            self.removeAllActions()
        }
    }
}
