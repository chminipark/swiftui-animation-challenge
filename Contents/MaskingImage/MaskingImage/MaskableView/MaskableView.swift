//
//  MaskableView.swift
//  MaskingImage
//
//  Created by minii on 2023/07/04.
//

import SwiftUI
import Combine

struct MaskableView: View {
  let croppedImage: UIImage
  let backgroundImage: UIImage
  
  @StateObject var maskToolState = MaskToolState()
  @StateObject var maskableViewLink = MaskableViewLink()
  
  @State var imageFrame: CGRect = .init()
  
  init(
    croppedImage: UIImage = .garlic,
    backgroundImage: UIImage = .checkerboard
  ) {
    self.croppedImage = croppedImage
    self.backgroundImage = backgroundImage
  }
  
  var body: some View {
    VStack {
      Spacer()
      
      Image(uiImage: backgroundImage)
        .resizable()
        .frame(height: 450)
        .background(
          GeometryReader { geo in
            Color.clear
              .onAppear {
                self.imageFrame = geo.frame(in: .global)
              }
          }
        )
        .overlay {
          MaskableUIViewRepresentable(
            myFrame: imageFrame,
            croppedImage: croppedImage,
            maskToolState: maskToolState,
            maskableViewLink: maskableViewLink
          )
        }
        .padding()
      
      Spacer()
      
      MaskToolView(maskToolState: maskToolState)
    }
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        Button {
          self.maskableViewLink.startMasking.toggle()
        } label: {
          Image(systemName: "square.and.arrow.down")
            .resizable()
            .font(.title2)
            .fontWeight(.semibold)
            .foregroundColor(.black)
        }
      }
    }
    .navigationDestination(
      isPresented: self.$maskableViewLink.finishMasking
    ) {
      MaskedImageView(maskedImage: self.maskableViewLink.maskedImage)
    }
  }
}

struct MaskableView_Previews: PreviewProvider {
  static var previews: some View {
    RootView()
  }
}

