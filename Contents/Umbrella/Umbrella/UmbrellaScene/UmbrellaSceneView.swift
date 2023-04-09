//
//  UmbrellaSceneView.swift
//  Umbrella
//
//  Created by minii on 2023/04/09.
//

import SwiftUI
import SpriteKit

struct UmbrellaSceneView: View {
  private let gXs: [CGFloat] = [-2, -1.5, -1, -0.5, 0, 0.5, 1, 1.5, 2]
  
  var body: some View {
    GeometryReader { proxy in
      ZStack {
        SpriteView(scene: getUmbrellaScene(proxy.size))
        Image(systemName: "umbrella")
          .font(.system(size: proxy.minSize / 1.5))
          .foregroundColor(.white)
      }
    }
    .edgesIgnoringSafeArea(.all)
    .preferredColorScheme(.dark)
  }
  
  func getUmbrellaScene(_ size: CGSize) -> SKScene {
    let scene = UmbrellaScene()
    scene.size = size
    scene.scaleMode = .fill
    scene.physicsWorld.gravity = CGVector(dx: gXs.randomElement() ?? 0, dy: -5)
    return scene
  }
}
