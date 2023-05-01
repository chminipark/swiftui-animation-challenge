//
//  ParticleEffect.swift
//  ParticleEmitter
//
//  Created by minii on 2023/05/01.
//

import SwiftUI

extension View {
  @ViewBuilder
  func particleEffect(
    systemImage: String,
    font: Font,
    status: Bool,
    activeTint: Color
  ) -> some View {
    self
      .modifier(
        ParticleModifier(
          systemImage: systemImage,
          font: font,
          status: status,
          activeTint: activeTint
        )
      )
  }
}

fileprivate struct ParticleModifier: ViewModifier {
  var systemImage: String
  var font: Font
  var status: Bool
  var activeTint: Color
  
  @State private var particles: [Particle] = []
  let particleCount: Int = 15
  
  func body(content: Content) -> some View {
    content
      .overlay(alignment: .top) {
        ZStack {
          ForEach(particles) { particle in
            Image(systemName: systemImage)
              .font(font)
              .foregroundColor(activeTint)
              .scaleEffect(particle.scale)
              .offset(x: particle.randomX, y: particle.randomY)
              .opacity(particle.opacity)
            /// Only Visible When Status is Active
              .opacity(status ? 1 : 0)
            /// Making Base Visibility With Zero Animation
              .animation(.none, value: status)
          }
        }
        /// init particles
        .onAppear {
          if particles.isEmpty {
            for _ in 1...particleCount {
              let particle = Particle()
              particles.append(particle)
            }
          }
        }
        .onChange(of: status, perform: performParticle)
      }
  }
}

extension ParticleModifier {
  func performParticle(_ newValue: Bool) {
    /// When not selected, reset Animation
    if !newValue {
      for index in particles.indices {
        particles[index].reset()
      }
      /// When selected, activating Particles
    } else {
      for index in particles.indices {
        /// Random X & Y Calculation Based on Index
        let total: CGFloat = CGFloat(particleCount)
        let progress: CGFloat = CGFloat(index) / total
        
        let maxX: CGFloat = (progress > 0.5) ? 100 : -100
        let maxY: CGFloat = 60
        
        let randomX: CGFloat = ((progress > 0.5 ? progress - 0.5 : progress) * maxX)
        let randomY: CGFloat = ((progress > 0.5 ? progress - 0.5 : progress) * maxY) + 35
        /// Min Scale = 0.35
        /// Max Scale = 1
        let randomScale: CGFloat = .random(in: 0.35...1)
        
        /// Move Particle with Animation
        withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
          /// Extra Random Values For Spreading Particles Across the View
          let extraRandomX: CGFloat = (progress < 0.5 ? .random(in: 0...10) : .random(in: -10...0))
          let extraRandomY: CGFloat = .random(in: 0...30)
          
          particles[index].randomX = randomX + extraRandomX
          particles[index].randomY = -randomY - extraRandomY
        }
        
        /// Scaling With Ease Animation
        withAnimation(.easeInOut(duration: 0.3)) {
          particles[index].scale = randomScale
        }
        
        /// Removing Particles Based on Index
        withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)
          .delay(0.25 + (Double(index) * 0.005))) {
            particles[index].scale = 0
          }
      }
    }
  }
}

struct ParticleEffect_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
