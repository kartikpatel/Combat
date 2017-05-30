//: Playground - noun: a place where people can play

import UIKit
import SpriteKit
import PlaygroundSupport

let frame = CGRect(x: 0, y: 0, width: 320, height: 256)
let midPoint = CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0)

var scene = SKScene(size: frame.size)

let spaceship = SKSpriteNode(imageNamed: "Spaceship")
spaceship.position = midPoint
spaceship.setScale(0.1)

scene.addChild(spaceship)

let view = SKView(frame: frame)
view.presentScene(scene)

PlaygroundPage.current.liveView = view