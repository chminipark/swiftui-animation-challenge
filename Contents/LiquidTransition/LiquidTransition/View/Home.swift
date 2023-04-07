//
//  Home.swift
//  LiquidTransition
//
//  Created by minii on 2023/04/06.
//

import SwiftUI
import Lottie

struct Home: View {
  let liquidColor: Color = .purple
  
  @State var expandCard: Bool = false
  @State var bottomLiquidView = LottieAnimationView(name: "LiquidWave", bundle: .main)
  @State var topLiquidView = LottieAnimationView(name: "LiquidWave", bundle: .main)
  
  // Avoiding Multitapping
  @State var isfinished: Bool = false
  
  var body: some View {
    NavigationStack {
      VStack {
        ZStack {
          TopCard()
            .overlay(alignment: .bottom) {
              ChevronDownButton(action: chevronDownButtonAction)
                .padding(.bottom,-25)
            }
            .zIndex(1)
          
          BottomCard()
            .zIndex(0)
            .offset(y: expandCard ? 280 : 0)
          
        }
        .offset(y: expandCard ? -120 : 0)
      }
      .navigationTitle("LiquidTransition")
    }
  }
}

// MARK: TopCard
extension Home {
  @ViewBuilder
  func TopCard() -> some View {
    VStack {
      Text("TOP")
        .font(.largeTitle.bold())
        .foregroundColor(.white)
    }
    .frame(maxWidth: .infinity)
    .frame(height: expandCard ? 250 : 350)
    .background {
      GeometryReader { proxy in
        let size = proxy.size
        // LiquidWave json width = 1000
        let scale = size.width / 1000
        
        RoundedRectangle(cornerRadius: 35, style: .continuous)
          .fill(liquidColor)
        
        RoundedRectangle(cornerRadius: 35, style: .continuous)
          .fill(liquidColor)
          .mask {
            ResizableLottieView(lottieView: $bottomLiquidView)
              .scaleEffect(x: scale, y: scale, anchor: .leading)
          }
          .rotationEffect(.init(degrees: 180))
          .offset(y: expandCard ? size.height / 1.43 : 0)
      }
    }
    .padding()
  }
}

// MARK: BottomCard
extension Home {
  @ViewBuilder
  func BottomCard() -> some View {
    VStack(spacing: 20){
      Text("BOTTOM")
        .font(.largeTitle.bold())
        .foregroundColor(.white)
    }
    .frame(maxWidth: .infinity)
    .padding(.vertical, 70)
    .background {
      GeometryReader { proxy in
        let size = proxy.size
        let scale = size.width / 1000
        
        RoundedRectangle(cornerRadius: 35, style: .continuous)
          .fill(liquidColor)
        
        RoundedRectangle(cornerRadius: 35, style: .continuous)
          .fill(liquidColor)
          .mask {
            ResizableLottieView(lottieView: $topLiquidView)
              .scaleEffect(x: scale, y: scale, anchor: .leading)
          }
          .offset(y: expandCard ? -size.height / 1.2 : -size.height / 1.4)
      }
    }
    .padding()
  }
}

// MARK: ChevronDownButton
extension Home {
  @ViewBuilder
  func ChevronDownButton(action: @escaping () -> ()) -> some View {
    Button(action: action) {
      Image(systemName: "chevron.down")
        .font(.title3.bold())
        .foregroundColor(liquidColor)
        .padding(30)
        .background(.white, in: RoundedRectangle(cornerRadius: 20, style: .continuous)
        )
        .shadow(color: .black.opacity(0.15), radius: 5, x: 5, y: 5)
        .shadow(color: .black.opacity(0.15), radius: 5, x: -5, y: -5)
    }
  }
  
  func chevronDownButtonAction() {
    if isfinished {
      return
    }
    isfinished = true
    
    // Animating Lottie View with little Delay
    DispatchQueue.main.asyncAfter(deadline: .now() + (expandCard ? 0 : 0.2)) {
      // So that it will finish soon...
      // You can play with your custom options here
      bottomLiquidView.play(fromProgress: expandCard ? 0 : 0.45, toProgress: expandCard ? 0.6 : 0)
      topLiquidView.play(fromProgress: expandCard ? 0 : 0.45, toProgress: expandCard ? 0.6 : 0) { status in
        isfinished = false
      }
    }
    
    withAnimation(.interactiveSpring(
      response: 0.7,
      dampingFraction: 0.8,
      blendDuration: 0.8
    )) {
      expandCard.toggle()
    }
  }
}

struct Home_Previews: PreviewProvider {
  static var previews: some View {
    Home()
  }
}
