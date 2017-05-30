//: Playground - noun: a place where people can play

import UIKit
import SpriteKit
import PlaygroundSupport

let frame = CGRect(x: 0, y: 0, width: 320, height: 256)
let midPoint = CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0)

var scene = SKScene(size: frame.size)

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

let spaceship = SKSpriteNode(imageNamed: "Spaceship")
spaceship.position = midPoint
spaceship.setScale(0.1)
spaceship.zPosition = 2
scene.addChild(spaceship)

spaceship.run(
    SKAction.repeatForever(
        SKAction.rotate(byAngle: 0.25, duration: 0.15)
    )
)

let view = SKView(frame: frame)
view.showsFPS = true
view.showsNodeCount = true
view.presentScene(scene)

PlaygroundPage.current.liveView = view
