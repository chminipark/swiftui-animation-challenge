//
//  UmbrellaScene.swift
//  Umbrella
//
//  Created by minii on 2023/04/09.
//

import SwiftUI
import SpriteKit

class UmbrellaScene: SKScene {
  let rainRadius: CGFloat = 10
  var timer: Timer?
  var smallCircleNode: SKShapeNode!
  var largeCircleNode: SKShapeNode!
  var smallBoxNode: SKShapeNode!
  
  override func didMove(to view: SKView) {
    timer = Timer.scheduledTimer(
      timeInterval: 0.03,
      target: self,
      selector: #selector(createRain),
      userInfo: nil,
      repeats: true
    )
    
    let largeDiv: CGFloat = 3.0
    let largeSize = self.size.width < self.size.height ? self.size.width / largeDiv : self.size.height / largeDiv
    let smallSize = largeSize / 12
    addChildLargeCircleNode(largeSize: largeSize)
    addChildSmallCircleNode(largeSize: largeSize, smallSize: smallSize)
    addChildSmallBoxNode(smallSize: smallSize)
  }
  
  override func update(_ currentTime: TimeInterval) {
    for node in self.children {
      if largeCircleNode != node && smallCircleNode != node && smallBoxNode != node {
        node.xScale += 0.01
        node.yScale += 0.01
      }
      
      if node.position.y < -rainRadius || node.position.x < -rainRadius || self.size.width + rainRadius < node.position.x {
        node.removeFromParent()
      }
    }
  }
  
  deinit {
    self.timer?.invalidate()
  }
}

// MARK: LargeCircleNode
extension UmbrellaScene {
  func addChildLargeCircleNode(largeSize: CGFloat) {
    largeCircleNode = SKShapeNode(circleOfRadius: largeSize)
    largeCircleNode.fillColor = SKColor.blue
    largeCircleNode.strokeColor = SKColor.clear
    largeCircleNode.physicsBody = SKPhysicsBody(circleOfRadius: largeSize)
    largeCircleNode.physicsBody?.isDynamic = false
    largeCircleNode.isHidden = true
    largeCircleNode.position = CGPoint(x: self.size.width / 2, y: (self.size.height / 2) - largeSize * 0.05)
    addChild(largeCircleNode)
  }
}

// MARK: SmallCircleNode
extension UmbrellaScene {
  func addChildSmallCircleNode(largeSize: CGFloat, smallSize: CGFloat) {
    smallCircleNode = SKShapeNode(circleOfRadius: smallSize)
    smallCircleNode.fillColor = SKColor.red
    smallCircleNode.strokeColor = SKColor.clear
    smallCircleNode.physicsBody = SKPhysicsBody(circleOfRadius: smallSize)
    smallCircleNode.physicsBody?.isDynamic = false
    smallCircleNode.isHidden = true
    smallCircleNode.position = CGPoint(x: largeCircleNode.position.x, y: largeCircleNode.position.y + largeSize * 1.14)
    addChild(smallCircleNode)
  }
}

// MARK: SmallBoxNode
extension UmbrellaScene {
  func addChildSmallBoxNode(smallSize: CGFloat) {
    let rect = CGRect(x: smallCircleNode.position.x - smallSize, y: smallCircleNode.position.y - smallSize * 4, width: smallSize * 2, height: smallSize * 4)
    smallBoxNode = SKShapeNode(rect: rect)
    smallBoxNode.fillColor = SKColor.green
    smallBoxNode.strokeColor = SKColor.clear
    smallBoxNode.physicsBody = SKPhysicsBody(edgeLoopFrom: rect)
    smallBoxNode.physicsBody?.isDynamic = false
    smallBoxNode.isHidden = true
    addChild(smallBoxNode)
  }
}

// MARK: createRain
extension UmbrellaScene {
  @objc func createRain() {
    let location = CGPoint(
      x: CGFloat.random(in: 0 ..< self.size.width),
      y: self.size.height
    )
    
    let rain = rainNode()
    rain.position = location
    addChild(rain)
  }
  
  func rainNode() -> SKShapeNode {
    let rain = SKShapeNode(circleOfRadius: rainRadius)
    rain.fillColor = UIColor.random
    rain.strokeColor = .clear
    rain.physicsBody = SKPhysicsBody(circleOfRadius: rainRadius * 1.1)
    return rain
  }
}

struct UmbrellaSceneView_Previews: PreviewProvider {
  static var previews: some View {
    UmbrellaSceneView()
  }
}
