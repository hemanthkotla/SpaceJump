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
import SpriteKit
class Level1 : GameScene {
    
    override func didMove(to view: SKView)
    {
        super.didMove(to: view)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        super.touchesBegan(touches, with: event)
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        super.touchesMoved(touches, with: event)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        super.touchesEnded(touches, with: event)
    }
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        if score == 8 {
                   let nextLevel = GameScene(fileNamed: "Level2")
                   nextLevel?.scaleMode = .aspectFill
                   view?.presentScene(nextLevel)
                   run(Sound.levelUp.action)
               }

        
    }
}
