//
//  Home.swift
//  MatchedGeometry_FullScreenCover
//
//  Created by minii on 2023/04/10.
//

import SwiftUI

struct Home: View {
  let myColors: [MyColor] = MyColor.mockArray(count: 30)
  @State var show: Bool = false
  @State private var selectedColor: MyColor = .init(color: .clear)
  @Namespace private var animationID
  
  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      LazyVGrid(
        columns: Array(repeating: .init(.flexible(), spacing: 5), count: 3),
        spacing: 5
      ) {
        ForEach(myColors) { myColor in
          if selectedColor.id == myColor.id {
            Rectangle()
              .fill(.clear)
              .frame(height: 100)
          } else {
            Rectangle()
              .fill(myColor.color.gradient)
              .matchedGeometryEffect(id: myColor.id.uuidString, in: animationID)
              .frame(height: 100)
              .onTapGesture {
                withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.8, blendDuration: 0.8)) {
                  selectedColor = myColor
                  show.toggle()
                }
              }
          }
        }
      }
      .padding(15)
    }
    .showMyColor(show: $show) {
      MyColorDetailView(myColor: $selectedColor, animationID: animationID)
    }
  }
}

struct Home_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
