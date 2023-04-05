//
//  Home.swift
//  MetaBall
//
//  Created by minii on 2023/04/04.
//

import SwiftUI

struct Home: View {
  @State var metaballAnimation: MetaballAnimations = .Single
  @State var dragOffset: CGSize = .zero
  @State var startAnimation: Bool = false
  
  var body: some View {
    VStack {
      Text("Metaball Annimation")
        .font(.title)
        .fontWeight(.semibold)
        .frame(maxWidth: .infinity,alignment: .leading)
        .padding(15)
      
      Picker("", selection: $metaballAnimation) {
        ForEach(MetaballAnimations.allCases, id: \.self) { myAnimation in
          Text(myAnimation.rawValue)
        }
      }
      .pickerStyle(.segmented)
      .padding()
      
      if metaballAnimation == .Single {
        SingleMetaBall()
      } else{
        ClubbedView()
      }
    }
    .preferredColorScheme(.dark)
  }
}

// MARK: MetaballAnimations
extension Home {
  enum MetaballAnimations: String, CaseIterable {
    case Single
    case Clubbed
  }
}

// MARK: SingleMetaBall
extension Home {
  @ViewBuilder
  func SingleMetaBall() -> some View {
    Rectangle()
      .fill(
        .linearGradient(
          colors: [.pink, .purple],
          startPoint: .top, endPoint: .bottom
        )
      )
      .mask {
        Canvas { context, size in
          // MARK: Adding Filters
          // Change here If you need Custom Color
          context.addFilter(.alphaThreshold(min: 0.5,color: .yellow))
          // MARK: This blur Radius determines the amount of elasticity between two elements
          context.addFilter(.blur(radius: 35))
          
          // MARK: Drawing Layer
          context.drawLayer { ctx in
            // MARK: Placing Symbols
            for index in [1,2] {
              if let resolvedView = context.resolveSymbol(id: index) {
                ctx.draw(resolvedView, at: CGPoint(x: size.width / 2, y: size.height / 2))
              }
            }
          }
        } symbols: {
          Ball()
            .tag(1)
          
          Ball(offset: dragOffset)
            .tag(2)
        }
      }
      .gesture(
        DragGesture()
          .onChanged({ value in
            dragOffset = value.translation
          }).onEnded({ _ in
            withAnimation(.interactiveSpring(
              response: 0.6,
              dampingFraction: 0.7,
              blendDuration: 0.7)) {
                dragOffset = .zero
              }
          })
      )
  }
  
  @ViewBuilder
  func Ball(offset: CGSize = .zero) -> some View {
    Circle()
      .fill(.white)
      .frame(width: 130, height: 130)
      .offset(offset)
  }
}

// MARK: ClubbedView
extension Home {
  @ViewBuilder
  func ClubbedView() -> some View {
    Rectangle()
      .fill(
        .linearGradient(
          colors: [.pink, .purple],
          startPoint: .top, endPoint: .bottom
        )
      )
      .mask({
        // MARK: Timing Is Your Wish for how Long The Animation needs to be Changed
        TimelineView(.animation(minimumInterval: 3.6, paused: false)) { _ in
          Canvas { context, size in
            // MARK: Adding Filters
            // Change here If you need Custom Color
            context.addFilter(.alphaThreshold(min: 0.5,color: .white))
            // MARK: This blur Radius determines the amount of elasticity between two elements
            context.addFilter(.blur(radius: 30))
            
            // MARK: Drawing Layer
            context.drawLayer { ctx in
              // MARK: Placing Symbols
              for index in 1...15 {
                if let resolvedView = context.resolveSymbol(id: index) {
                  ctx.draw(resolvedView, at: CGPoint(x: size.width / 2, y: size.height / 2))
                }
              }
            }
          } symbols: {
            // MARK: Count is your wish
            ForEach(1...15, id: \.self) { index in
              // MARK: Generating Custom Offset For Each Time
              // Thus It will be at random places and clubbed with each other
              let offset = (startAnimation ? CGSize(width: .random(in: -180...180), height: .random(in: -240...240)) : .zero)
              ClubbedRoundedRectangle(offset: offset)
                .tag(index)
            }
          }
        }
      })
      .contentShape(Rectangle())
      .onTapGesture {
        startAnimation.toggle()
      }
  }
  
  @ViewBuilder
  func ClubbedRoundedRectangle(offset: CGSize) -> some View {
    RoundedRectangle(cornerRadius: 30, style: .continuous)
      .fill(.white)
      .frame(width: 120, height: 120)
      .offset(offset)
    // MARK: Adding Animation[Less Than TimelineView Refresh Rate]
      .animation(.easeInOut(duration: 4), value: offset)
  }
}

struct Home_Previews: PreviewProvider {
  static var previews: some View {
    Home()
  }
}
