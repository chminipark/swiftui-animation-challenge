//
//  ContentView.swift
//  ShimmerText
//
//  Created by minii on 2023/03/22.
//

import SwiftUI

struct ContentView: View {
  let imageNames = [
    "suit.heart.fill",
    "box.truck.badge.clock.fill",
    "sun.max.trianglebadge.exclamationmark.fill"
  ]
  
  var body: some View {
    NavigationStack {
      VStack(spacing: 20) {
        shimmerText()
        
        HStack(spacing: 15) {
          ForEach(imageNames, id: \.self) { imageName in
            indigoButton(imageName: imageName)
          }
        }
        
        myProgressView()
      }
      .navigationTitle("Shimmer Effect")
      .preferredColorScheme(.dark)
    }
  }
  
  func shimmerText() -> some View {
    Text("Shimmer Text")
      .font(.title)
      .fontWeight(.black)
      .shimmer(.init(tint: .white.opacity(0.5), highlight: .white, blur: 5))
      .padding()
      .background(
        RoundedRectangle(cornerRadius: 15, style: .continuous)
          .fill(.red.gradient)
      )
  }
  
  func indigoButton(imageName: String) -> some View {
    Image(systemName: imageName)
      .font(.title)
      .fontWeight(.black)
      .shimmer(.init(tint: .white.opacity(0.4), highlight: .white, blur: 5))
      .frame(width: 40, height: 40)
      .padding()
      .background(
        RoundedRectangle(cornerRadius: 15, style: .continuous)
          .fill(.indigo.gradient)
      )
  }
  
  func myProgressView() -> some View {
    HStack {
      Circle()
        .frame(width: 55, height: 55)
      
      VStack(alignment: .leading, spacing: 6) {
        RoundedRectangle(cornerRadius: 4)
          .frame(height: 10)
        
        RoundedRectangle(cornerRadius: 4)
          .frame(height: 10)
          .padding(.trailing, 50)
        
        RoundedRectangle(cornerRadius: 4)
          .frame(height: 10)
          .padding(.trailing, 100)
      }
    }
    .padding(15)
    .padding(.horizontal, 30)
    .shimmer(.init(tint: .gray.opacity(0.3), highlight: .white, blur: 5))
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
