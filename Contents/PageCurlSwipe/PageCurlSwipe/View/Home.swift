//
//  Home.swift
//  PageCurlSwipe
//
//  Created by minii on 2023/05/15.
//

import SwiftUI

struct Home: View {
  @State private var images: [ImageModel] = []
  
  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      VStack(spacing: 20) {
        ForEach(images) { image in
          PeelEffectView(onDelete: { onDelete(image) }) {
            CardView(assetName: image.assetName)
          }
        }
      }
      .padding(15)
    }
    .onAppear {
      self.images = (1...4).map { ImageModel(assetName: String($0)) }
    }
  }
}

extension Home {
  func onDelete(_ image: ImageModel) -> () {
    if let index = images.firstIndex(where: { curImage in
      curImage.id == image.id
    }) {
      let _ = withAnimation(.easeInOut(duration: 0.35)) {
        images.remove(at: index)
      }
    }
  }
}

extension Home {
  @ViewBuilder
  func CardView(assetName: String) -> some View {
    GeometryReader { proxy in
      let size = proxy.size
      
      ZStack {
        Image(assetName)
          .resizable()
          .aspectRatio(contentMode: .fill)
          .frame(width: size.width, height: size.height)
          .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
      }
    }
    .frame(height: 130)
    .contentShape(Rectangle())
  }
}

struct Home_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
