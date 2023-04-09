//
//  TestSKScene.swift
//  Umbrella
//
//  Created by minii on 2023/04/08.
//

import SwiftUI
import CoreMotion
import SpriteKit

extension UIColor {
  static var random: UIColor {
    return UIColor(
      red: .random(in: 0...1),
      green: .random(in: 0...1),
      blue: .random(in: 0...1),
      alpha: 1.0
    )
  }
}

struct TestSKSceneView: View {
  private let gXs: [CGFloat] = [-2, -1.5, -1, -0.5, 0, 0.5, 1, 1.5, 2]
  
  var body: some View {
    GeometryReader { proxy in
      SpriteView(scene: getOutsideScene(proxy.size))
//      SpriteView(scene: getInsideScene(proxy.size))
    }
  }
  
  private func getOutsideScene(_ size: CGSize) -> SKScene {
//    let scene = OutsideScene()
    let scene = TestOutsideScene()
    scene.size = size
    scene.scaleMode = .fill
    scene.backgroundColor = SKColor(named: "colorBack1") ?? SKColor.black
//    scene.physicsWorld.gravity = CGVector(dx: gXs.randomElement() ?? 0, dy: -5)
    scene.physicsWorld.gravity = CGVector(dx: 0, dy: -1)
    
    return scene
  }

  
  private func getInsideScene(_ size: CGSize) -> SKScene {
//    let scene = InsideScene()
    let scene = TestInsideSKScene()
    scene.size = size
    scene.scaleMode = .fill
    scene.backgroundColor = SKColor.black
    scene.physicsWorld.gravity = CGVector(dx: 0, dy: -1)
    return scene
  }
}

class TestInsideSKScene: SKScene {
  var timer: Timer?
  
  override func didMove(to view: SKView) {
    timer = Timer.scheduledTimer(
      timeInterval: 0.05,
      target: self,
      selector: #selector(createCircle),
      userInfo: nil,
      repeats: true
    )
  }
  
  @objc func createCircle() {
    let hWidth = self.size.width / 2
    let fontSize = (self.size.width < self.size.height ? self.size.width / 1.5 : self.size.height / 1.5) / 2
    let location = CGPoint(x: hWidth + CGFloat.random(in: -fontSize..<fontSize), y: self.size.height + 50)
    let circle = myCircleNode()
    circle.position = location
    addChild(circle)
  }
  
  deinit {
    self.timer?.invalidate()
  }
  
  func myCircleNode() -> SKShapeNode {
    let circle = SKShapeNode(circleOfRadius: 15)
    circle.fillColor = UIColor.random
    circle.strokeColor = .clear
    circle.physicsBody = SKPhysicsBody(circleOfRadius: 15 * 1.1)
    return circle
  }
}

class TestOutsideScene: SKScene {
  var timer: Timer?
//  var smallCircleNode: SKShapeNode!
  var largeCircleNode: SKShapeNode!
  
  override func didMove(to view: SKView) {
    
    timer = Timer.scheduledTimer(
      timeInterval: 0.02,
      target: self,
      selector: #selector(_createCircle),
      userInfo: nil,
      repeats: true
    )
    
    let largeDiv: CGFloat = 3.0
    let largeSize = self.size.width < self.size.height ? self.size.width / largeDiv : self.size.height / largeDiv
    largeCircleNode = SKShapeNode(circleOfRadius: largeSize)
    largeCircleNode.fillColor = SKColor.blue
    largeCircleNode.strokeColor = SKColor.clear
    largeCircleNode.physicsBody = SKPhysicsBody(circleOfRadius: largeSize)
    largeCircleNode.physicsBody?.isDynamic = false
//    largeCircleNode.isHidden = true
    largeCircleNode.position = CGPoint(x: self.size.width / 2, y: (self.size.height / 2) - largeSize * 0.05)
    addChild(largeCircleNode)
  }
  
  @objc func _createCircle() {
    let hWidth = self.size.width / 2
    let location = CGPoint(x: hWidth + CGFloat.random(in: -hWidth..<hWidth), y: self.size.height + 50)
    
    let circle = SKShapeNode(circleOfRadius: 15)
    circle.position = location
    addChild(circle)
  }
  
  deinit {
    self.timer?.invalidate()
  }
}

struct TestSKSceneView_Previews: PreviewProvider {
  static var previews: some View {
    TestSKSceneView()
  }
}
