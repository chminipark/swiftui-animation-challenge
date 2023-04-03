//
//  Home.swift
//  GridMagnificationEffect
//
//  Created by minii on 2023/03/29.
//

import SwiftUI

struct Home: View {
  var body: some View {
    TabView {
      GridMagnificationEffect1()
        .tabItem {
          Image(systemName: "1.square")
        }
      
      GridMagnificationEffect2()
        .tabItem {
          Image(systemName: "2.square")
        }
      
      GridMagnificationEffect3()
        .tabItem {
          Image(systemName: "3.square")
        }
    }
  }
}

struct GridMagnificationEffect1: View {
  let rowCount = 10
  let coordinateSpaceName = "GESTURE"
  @GestureState var tapLocation: CGPoint = .zero
  
  var body: some View {
    GeometryReader { proxy in
      let gridSize = proxy.size
      
      let itemWidth = gridSize.width / 10
      let itemCount = Int((gridSize.height / itemWidth).rounded()) * rowCount
      
      LinearGradient(
        colors: [.cyan, .yellow, .mint, .pink, .purple],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
      )
      .mask {
        LazyVGrid(
          columns: Array(
            repeating: GridItem(.flexible(), spacing: 0),
            count: rowCount
          ),
          spacing: 0
        ) {
          ForEach(0 ..< itemCount, id: \.self) { _ in
            GeometryReader { innerProxy in
              let itemRect = innerProxy.frame(in: .named(coordinateSpaceName))
              let scale = itemScale(itemRect: itemRect, gridSize: gridSize)
              
              RoundedRectangle(cornerRadius: 4)
                .fill(.orange)
                .scaleEffect(scale)
            }
            .padding(4)
            .frame(height: itemWidth)
          }
        }
      }
    }
    .padding(10)
    .preferredColorScheme(.dark)
    .gesture(
      DragGesture(minimumDistance: 0)
        .updating($tapLocation, body: {value, out, _ in
          out = value.location
        })
    )
    .coordinateSpace(name: coordinateSpaceName)
    .animation(.easeInOut, value: tapLocation == .zero)
  }
  
  func itemScale(itemRect: CGRect, gridSize: CGSize) -> CGFloat {
    let a = tapLocation.x - itemRect.minX
    let b = tapLocation.y - itemRect.midY
    
    let distanceItemTapLocation = sqrt((a * a) + (b * b))
    let gridValue = sqrt((gridSize.width * gridSize.width) + (gridSize.height * gridSize.height))
    
    let scale = distanceItemTapLocation / (gridValue / 1.5)
    let modifiedScale = tapLocation == .zero ? 1 : (1 - scale)
    
    // To avoid SwiftUI Transform Warning
    return modifiedScale > 0 ? modifiedScale : 0.001
  }
}

struct GridMagnificationEffect2: View {
  let rowCount = 10
  let coordinateSpaceName = "GESTURE"
  @GestureState var tapLocation: CGPoint = .zero
  
  var body: some View {
    GeometryReader { proxy in
      let gridSize = proxy.size
      
      let itemWidth = gridSize.width / 10
      let itemCount = Int((gridSize.height / itemWidth).rounded()) * rowCount
      
      LinearGradient(
        colors: [.cyan, .yellow, .mint, .pink, .purple],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
      )
      .mask {
        LazyVGrid(
          columns: Array(
            repeating: GridItem(.flexible(), spacing: 0),
            count: rowCount
          ),
          spacing: 0
        ) {
          ForEach(0 ..< itemCount, id: \.self) { _ in
            GeometryReader { innerProxy in
              let itemRect = innerProxy.frame(in: .named(coordinateSpaceName))
              let scale = itemScale(itemRect: itemRect, gridSize: gridSize)
              
              let transformedRect = itemRect.applying(.init(scaleX: scale, y: scale))
              let transformedLocation = tapLocation.applying(.init(scaleX: scale, y: scale))
              
              RoundedRectangle(cornerRadius: 4)
                .fill(.orange)
                .scaleEffect(scale)
                .offset(x: (transformedRect.midX - itemRect.midX),
                        y: (transformedRect.midY - itemRect.midY))
                .offset(x: (tapLocation.x - transformedLocation.x),
                        y: (tapLocation.y - transformedLocation.y))
            }
            .padding(4)
            .frame(height: itemWidth)
          }
        }
      }
    }
    .padding(10)
    .preferredColorScheme(.dark)
    .gesture(
      DragGesture(minimumDistance: 0)
        .updating($tapLocation, body: {value, out, _ in
          out = value.location
        })
    )
    .coordinateSpace(name: coordinateSpaceName)
    .animation(.easeInOut, value: tapLocation == .zero)
  }
  
  func itemScale(itemRect: CGRect, gridSize: CGSize) -> CGFloat {
    let a = tapLocation.x - itemRect.minX
    let b = tapLocation.y - itemRect.midY
    
    let distanceItemTapLocation = sqrt((a * a) + (b * b))
    let gridValue = sqrt((gridSize.width * gridSize.width) + (gridSize.height * gridSize.height))
    
    let scale = distanceItemTapLocation / (gridValue / 2)
    let modifiedScale = tapLocation == .zero ? 1 : (1 - scale)
    
    // To avoid SwiftUI Transform Warning
    return modifiedScale > 0 ? modifiedScale : 0.001
  }
}

struct GridMagnificationEffect3: View {
  let rowCount = 10
  let coordinateSpaceName = "GESTURE"
  @GestureState var tapLocation: CGPoint = .zero
  
  var body: some View {
    GeometryReader { proxy in
      let gridSize = proxy.size
      
      let itemWidth = gridSize.width / 10
      let itemCount = Int((gridSize.height / itemWidth).rounded()) * rowCount
      
      LinearGradient(
        colors: [.cyan, .yellow, .mint, .pink, .purple],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
      )
      .mask {
        LazyVGrid(
          columns: Array(
            repeating: GridItem(.flexible(), spacing: 0),
            count: rowCount
          ),
          spacing: 0
        ) {
          ForEach(0 ..< itemCount, id: \.self) { _ in
            GeometryReader { innerProxy in
              let itemRect = innerProxy.frame(in: .named(coordinateSpaceName))
              let scale = itemScale(itemRect: itemRect, gridSize: gridSize)
              
              let transformedRect = itemRect.applying(.init(scaleX: scale, y: scale))
              let transformedLocation = tapLocation.applying(.init(scaleX: scale, y: scale))
              
              RoundedRectangle(cornerRadius: 4)
                .fill(.orange)
                .offset(x: (transformedRect.midX - itemRect.midX),
                        y: (transformedRect.midY - itemRect.midY))
                .offset(x: (tapLocation.x - transformedLocation.x),
                        y: (tapLocation.y - transformedLocation.y))
                .scaleEffect(scale)
            }
            .padding(4)
            .frame(height: itemWidth)
          }
        }
      }
    }
    .padding(10)
    .preferredColorScheme(.dark)
    .gesture(
      DragGesture(minimumDistance: 0)
        .updating($tapLocation, body: {value, out, _ in
          out = value.location
        })
    )
    .coordinateSpace(name: coordinateSpaceName)
    .animation(.easeInOut, value: tapLocation == .zero)
  }
  
  func itemScale(itemRect: CGRect, gridSize: CGSize) -> CGFloat {
    let a = tapLocation.x - itemRect.minX
    let b = tapLocation.y - itemRect.midY
    
    let distanceItemTapLocation = sqrt((a * a) + (b * b))
    let gridValue = sqrt((gridSize.width * gridSize.width) + (gridSize.height * gridSize.height))
    
    let scale = distanceItemTapLocation / (gridValue / 2)
    let modifiedScale = tapLocation == .zero ? 1 : (1 - scale)
    
    // To avoid SwiftUI Transform Warning
    return modifiedScale > 0 ? modifiedScale : 0.001
  }
}

struct Home_Previews: PreviewProvider {
  static var previews: some View {
    Home()
  }
}
