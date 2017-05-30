//: Playground - noun: a place where people can play

import UIKit
import SpriteKit
import GameplayKit
import PlaygroundSupport

let smokeEmitter = SKEmitterNode(fileNamed: "SmokeParticles.sks")

class GameScene: SKScene {
    
    let redAgent = GKAgent2D()
    let blueAgent = GKAgent2D()
    
    var lastUpdateTime : TimeInterval = 0
    
    override func didMove(to view: SKView) {
        let spaceshipRed = SKSpriteNode(imageNamed: "Spaceship")
        spaceshipRed.name = "red spaceship"
        spaceshipRed.position = CGPoint(x: 20, y: 20)
        spaceshipRed.setScale(0.1)
        spaceshipRed.zPosition = 2
        spaceshipRed.color = .red
        spaceshipRed.colorBlendFactor = 0.5
        self.addChild(spaceshipRed)
        
        let spaceshipBlue = SKSpriteNode(imageNamed: "Spaceship")
        spaceshipBlue.name = "blue spaceship"
        spaceshipBlue.position = CGPoint(x: frame.size.width - 20, y: frame.size.height - 20)
        spaceshipBlue.setScale(0.1)
        spaceshipBlue.zPosition = 2
        spaceshipBlue.color = .blue
        spaceshipBlue.colorBlendFactor = 0.5
        self.addChild(spaceshipBlue)
        
        redAgent.position = vector2(Float(spaceshipRed.position.x), Float(spaceshipRed.position.y))
        redAgent.maxAcceleration = 100
        redAgent.maxSpeed = 90
        redAgent.delegate = self

        let blueGoal = GKGoal(toInterceptAgent: redAgent, maxPredictionTime: 2)

        blueAgent.behavior = GKBehavior(goal: blueGoal, weight: 1)
        blueAgent.position = vector2(Float(spaceshipBlue.position.x), Float(spaceshipBlue.position.y))
        blueAgent.maxAcceleration = 90
        blueAgent.maxSpeed = 200
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        self.lastUpdateTime = currentTime
        
        redAgent.update(deltaTime: dt)
        blueAgent.update(deltaTime: dt)

        if let spaceshipBlue = self.childNode(withName: "blue spaceship") {
            spaceshipBlue.position = CGPoint(x: CGFloat(blueAgent.position.x), y: CGFloat(blueAgent.position.y))
        }
        
        if let spaceshipRed = self.childNode(withName: "red spaceship") {
            let collision  = !self.nodes(at: spaceshipRed.position).filter({ $0.name == "blue spaceship" }).isEmpty
            if collision {
                if let smokeEmitter = smokeEmitter, let smoke = smokeEmitter.copy() as? SKEmitterNode {
                    self.addChild(smoke)
                    smoke.position = spaceshipRed.position
                    spaceshipRed.removeFromParent()
                    smoke.run(
                        SKAction.sequence(
                            [SKAction.wait(forDuration: 1),
                             SKAction.run { smoke.particleBirthRate = 0},
                             SKAction.wait(forDuration: 1), SKAction.removeFromParent()
                            ]
                        )
                    )
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else { return }
        
        redAgent.position = vector_float2( Float(location.x), Float(location.y))
    }
    
}

extension GameScene: GKAgentDelegate {

    func agentDidUpdate(_ agent: GKAgent) {
        guard let redAgent = agent as? GKAgent2D else { return }

        if let spaceshipRed = self.childNode(withName: "red spaceship") {
            let location = CGPoint(x: CGFloat(redAgent.position.x), y: CGFloat(redAgent.position.y))
            spaceshipRed.run(SKAction.move(to: location, duration: 1))
        }
    }

}

let frame = CGRect(x: 0, y: 0, width: 320, height: 256)
let midPoint = CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0)

var scene = GameScene(size: frame.size)

let emitter = SKEmitterNode()
emitter.particleLifetime = 40
emitter.particleBlendMode = SKBlendMode.alpha
emitter.particleBirthRate = 3
emitter.particleSize = CGSize(width: 4,height: 4)
emitter.particleColor = SKColor(red: 100, green: 100, blue: 255, alpha: 1)
emitter.position = CGPoint(x:frame.size.width,y:midPoint.y)
emitter.particleSpeed = 16
emitter.particleSpeedRange = 100
emitter.particlePositionRange = CGVector(dx: 0, dy: frame.size.height)
emitter.emissionAngle = 3.14
emitter.advanceSimulationTime(40)
emitter.particleAlpha = 0.5
emitter.particleAlphaRange = 0.5
emitter.zPosition = 1
scene.addChild(emitter)

let view = SKView(frame: frame)
view.showsFPS = true
view.showsNodeCount = true
view.presentScene(scene)

PlaygroundPage.current.liveView = view
