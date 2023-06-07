//
//  ViewFinder.swift
//  ViewFinder
//
//  Created by minii on 2023/06/06.
//

import SwiftUI

struct ViewFinder: View {
  let originalImage: UIImage
  @Binding var cropRect: CGRect
  @Binding var imageScale: CGFloat
  
  init(
    originalImage: UIImage,
    cropRect: Binding<CGRect>,
    imageScale: Binding<CGFloat>
  ) {
    self.originalImage = originalImage
    self._cropRect = cropRect
    self._imageScale = imageScale
  }
  
  var body: some View {
    VStack {
      Image(uiImage: originalImage)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .overlay {
          GeometryReader { proxy in
            let cgRect: CGRect = proxy.frame(in: .local)
            
            GridView(initRect: cgRect, cropRect: $cropRect)
              .onAppear {
                self.cropRect = cgRect
                self.imageScale = self.originalImage.size.width / cgRect.size.width
              }
          }
        }
    }
    .padding(.horizontal)
  }
}

struct TestViewFinder: View {
  let image = UIImage(named: "garlic")!
  @State var cropRect: CGRect = .init()
  @State var imageScale: CGFloat = 0
  
  var body: some View {
    ViewFinder(originalImage: image, cropRect: $cropRect, imageScale: $imageScale)
  }
}

struct ViewFinder_Previews: PreviewProvider {
  static var previews: some View {
    TestViewFinder()
  }
}
