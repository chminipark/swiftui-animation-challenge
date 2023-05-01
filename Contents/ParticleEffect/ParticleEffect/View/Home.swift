//
//  Home.swift
//  ParticleEffect
//
//  Created by minii on 2023/05/01.
//

import SwiftUI

struct Home: View {
  @State private var isHeartButton: Bool = false
  @State private var isStarButton: Bool = false
  @State private var isMoonButton: Bool = false
  
  var body: some View {
    VStack {
      HStack(spacing: 20) {
        CustomButton(systemImage: "suit.heart.fill",
                     status: isHeartButton,
                     activeTint: .pink,
                     inActiveTint: .gray) {
          isHeartButton.toggle()
        }
        
        CustomButton(systemImage: "star.fill",
                     status: isStarButton,
                     activeTint: .yellow,
                     inActiveTint: .gray) {
          isStarButton.toggle()
        }
        
        CustomButton(systemImage: "moon.stars.fill",
                     status: isMoonButton,
                     activeTint: .blue,
                     inActiveTint: .gray) {
          isMoonButton.toggle()
        }
      }
    }
  }
}

// MARK: CustomButton
extension Home {
  @ViewBuilder
  func CustomButton(
    systemImage: String,
    status: Bool,
    activeTint: Color,
    inActiveTint: Color,
    onTap: @escaping () -> ()
  ) -> some View {
    Button(action: onTap) {
      Image(systemName: systemImage)
        .font(.title2)
        .particleEffect(
          systemImage: systemImage,
          font: .body,
          status: status,
          activeTint: activeTint
        )
        .foregroundColor(status ? activeTint : inActiveTint)
        .padding(.horizontal, 18)
        .padding(.vertical, 8)
        .background {
          Capsule()
            .fill(status ? activeTint.opacity(0.25) : inActiveTint.opacity(0.2))
        }
    }
  }
}

struct Home_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
