//
//  MaskableViewLink.swift
//  MaskingImage
//
//  Created by minii on 2023/07/10.
//

import SwiftUI

class MaskableViewLink: ObservableObject {
  @Published var startMasking = false
  @Published var finishMasking = false
  var maskedImage: UIImage? = nil
}
