//
//  Sound.swift
//  PKH-SpaceJump
//
//  Created by Hemanth Kotla on 2020-02-12.
//  Copyright © 2020 Hemanth Kotla. All rights reserved.
//

import Foundation
import SpriteKit

enum Sound: String
{
    case hit, jump, levelUp, meteorFalling, oxygen
    
    var action: SKAction
    {
        return SKAction.playSoundFileNamed(rawValue + "Sound.wav", waitForCompletion: false)
    }
}


extension SKAction
{
    static let bgm : SKAction = repeatForever(playSoundFileNamed("backost.wav", waitForCompletion: false))
}
