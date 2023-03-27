//
//  CloneRotatingCard.swift
//  Rotating3DCard
//
//  Created by minii on 2023/03/26.
//

import SwiftUI

enum CardDisplaySide {
  case front
  case back
}

struct RotatingCard: View {
  @State private var rotationAngle: Double = 0
  @State private var flippingAngle: Double = 0
  @State private var displaySide = CardDisplaySide.back
  
  var body: some View {
    VStack {
      RenderCard(displaySide: displaySide)
        .modifier(
          FlippingAnimation(angle: flippingAngle,
                             displaySide: $displaySide)
        )
        .modifier(RotatingAnimation(angle: rotationAngle))
        .onAppear {
          DispatchQueue.main.async {
            withAnimation(.linear(duration: 5).repeatForever(autoreverses: false)) {
              flippingAngle = 360
            }
            
            withAnimation(.linear(duration: 12).repeatForever(autoreverses: false)) {
              rotationAngle = 360
            }
          }
        }
    }
  }
}

struct RotatingAnimation: Animatable, ViewModifier {
  var angle: Double
  
  var animatableData: Double {
    get { angle }
    set { angle = newValue }
  }
  
  func body(content: Content) -> some View {
    content
      .rotationEffect(.degrees(angle))
  }
}

struct FlippingAnimation: Animatable, ViewModifier {
  var angle: Double
  @Binding var displaySide: CardDisplaySide
  
  var animatableData: Double {
    get { angle }
    set { angle = newValue }
  }
  
  func body(content: Content) -> some View {
    // So that the view is not modified while being drawn, DispatchQueue is used
    DispatchQueue.main.async {
      if 90 <= self.angle && self.angle <= 270 {
        self.displaySide = .front
      } else {
        self.displaySide = .back
      }
    }
    
    return content
      .rotation3DEffect(
        .degrees(angle),
        axis: (x: 0.0, y: 1.0, z: 0.0)
      )
    
  }
}

struct RenderCard: View {
  let displaySide: CardDisplaySide
  
  var body: some View {
    Group {
      if displaySide == .back {
        DiamondBack()
      } else {
        CardFront()
      }
    }
    .frame(width: 200, height: 280)
    .background(
      RoundedRectangle(cornerRadius: 5)
        .fill(.white)
        .shadow(radius: 5)
    )
  }
}


struct DiamondBack: View {
  private let backColor: Color = [
    Color.red,
    .blue,
    .black.opacity(0.7)
  ].randomElement()!
  
  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 5)
        .stroke(.gray)
      
      RoundedRectangle(cornerRadius: 5)
        .stroke(backColor, lineWidth: 5)
        .background(
          RoundedRectangle(cornerRadius: 5)
            .stroke(backColor, lineWidth: 2)
            .background(
              DiamondFill()
                .stroke(.white, lineWidth: 2)
                .background(backColor)
                .clipShape(
                  RoundedRectangle(cornerRadius: 5)
                )
            )
            .padding(8)
        )
        .padding(1)
    }
  }
}

struct CardFront: View {
  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 5)
        .stroke(Color.gray)
      
      Rectangle()
        .fill(Color.blue)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .shadow(radius: 3)
        .padding(40)
    }
  }
}

struct DiamondFill: Shape {
  func path(in rect: CGRect) -> Path {
    var path = Path()
    let traveling = rect.width + rect.height
    
    for loc in stride(from: 10.0, through: traveling, by: 18) {
      let forwardXStart = loc <= rect.width ? loc : rect.width
      let forwardYStart = loc <= rect.width ? 0 : loc - rect.width
      let forwardXEnd = loc <= rect.height ? 0 : loc - rect.height
      let forwardYEnd = loc <= rect.height ? loc : rect.height
      
      let backwardXStart = loc <= rect.width ? loc : rect.width
      let backwardYStart = loc <= rect.width ? rect.height : rect.height - (loc - rect.width)
      let backwardXEnd = loc <= rect.height ? 0 : loc - rect.height
      let backwardYEnd = loc <= rect.height ? rect.height - loc : 0
      
      path.move(to: .init(x: forwardXStart, y: forwardYStart))
      path.addLine(to: .init(x: forwardXEnd, y: forwardYEnd))
      
      path.move(to: .init(x: backwardXStart, y: backwardYStart))
      path.addLine(to: .init(x: backwardXEnd, y: backwardYEnd))
      
    }
    
    return path
  }
}

struct RotatingCard_Previews: PreviewProvider {
  static var previews: some View {
    RotatingCard()
  }
}
