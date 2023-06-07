//
//  CropImageView.swift
//  ViewFinder
//
//  Created by minii on 2023/06/06.
//

import SwiftUI

struct CropImageView: View {
  let originalImage: UIImage
  @State var cropRect: CGRect = .init()
  @State var imageScale: CGFloat = 0
  @State var croppedImage: UIImage? = nil
  
  @State var originalImageSize: CGSize = .init()
  
  init(originalImage: UIImage = UIImage(named: "garlic")!) {
    self.originalImage = originalImage
  }
  
  var body: some View {
    VStack(spacing: 40) {
      HStack {
        OriginalImage()
        CroppedImage()
      }
      .frame(height: 200)
      .padding()
      
      ViewFinder(originalImage: originalImage, cropRect: $cropRect, imageScale: $imageScale)
      
      CropButton()
    }
  }
}

extension CropImageView {
  @ViewBuilder
  func OriginalImage() -> some View {
    Image(uiImage: originalImage)
      .resizable()
      .aspectRatio(contentMode: .fit)
      .overlay {
        GeometryReader { proxy in
          Color.clear
            .onAppear {
              self.originalImageSize = proxy.size
            }
        }
      }
  }
  
  @ViewBuilder
  func CroppedImage() -> some View {
    Group {
      if let croppedImage = self.croppedImage {
        Image(uiImage: croppedImage)
          .resizable()
          .aspectRatio(contentMode: .fit)
      } else {
        Rectangle()
          .stroke(Color.black, lineWidth: 2)
          .overlay {
            Text("No CroppedImage")
          }
      }
    }
    .frame(width: originalImageSize.width)
  }
}

extension CropImageView {
  @ViewBuilder
  func CropButton() -> some View {
    Button(action: cropButtonAction) {
      RoundedRectangle(cornerRadius: 15)
        .frame(height: 60)
        .padding()
        .overlay {
          Text("CROP")
            .font(.title)
            .foregroundColor(.white)
        }
    }
  }
  
  func cropButtonAction() {
    let cropCGSize = CGSize(
      width: cropRect.size.width * imageScale,
      height: cropRect.size.height * imageScale
    )
    
    let cropCGPoint = CGPoint(
      x: -cropRect.origin.x * imageScale,
      y: -cropRect.origin.y * imageScale
    )
    
    UIGraphicsBeginImageContext(cropCGSize)
    
    self.originalImage.draw(at: cropCGPoint)
    let croppedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    self.croppedImage = croppedImage
  }
  
  /// Use cgImage.cropping(to: CGRect) method
  /// rotate issue... (orientation: .right)
  func cropImage() {
    let tmpRect = CGRect(
      x: cropRect.origin.x * imageScale,
      y: cropRect.origin.y * imageScale,
      width: cropRect.width * imageScale,
      height: cropRect.height * imageScale
    )
    
    let ciImage = CIImage(image: self.originalImage)!
    let ciContext = CIContext(options: nil)
    let cgImage = ciContext.createCGImage(ciImage, from: ciImage.extent)!
    
    let croppedCGImage = cgImage.cropping(to: tmpRect)
    self.croppedImage = UIImage(cgImage: croppedCGImage!, scale: self.originalImage.scale, orientation: .right)
  }
}

struct CropImageView_Previews: PreviewProvider {
  static var previews: some View {
    CropImageView()
  }
}
