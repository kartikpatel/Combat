//: Playground - noun: a place where people can play

import UIKit
import SpriteKit
import PlaygroundSupport

let frame = CGRect(x: 0, y: 0, width: 320, height: 256)

var scene = SKScene(size: frame.size)

let view = SKView(frame: frame)
view.presentScene(scene)

PlaygroundPage.current.liveView = view