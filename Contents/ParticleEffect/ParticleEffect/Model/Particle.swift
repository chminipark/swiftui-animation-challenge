//
//  Particle.swift
//  ParticleEffect
//
//  Created by minii on 2023/05/01.
//

import SwiftUI

struct Particle: Identifiable {
  var id: UUID = .init()
  var randomX: CGFloat = 0
  var randomY: CGFloat = 0
  var scale: CGFloat = 1
  var opacity: CGFloat = 1
  
  /// Reset All Properties
  mutating func reset() {
    randomX = 0
    randomY = 0
    scale = 1
    opacity = 1
  }
}
