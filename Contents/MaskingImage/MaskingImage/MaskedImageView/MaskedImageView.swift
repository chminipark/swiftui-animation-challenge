//
//  MaskedImageView.swift
//  MaskingImage
//
//  Created by minii on 2023/07/09.
//

import SwiftUI

struct MaskedImageView: View {
  let maskedImage: UIImage?
  
  var body: some View {
    if let uiImage = maskedImage {
      Image(uiImage: uiImage)
        .resizable()
        .frame(height: 450)
        .padding()
    } else {
      Color.red
    }
  }
}
