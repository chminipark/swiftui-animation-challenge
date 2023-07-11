//
//  Extension+View.swift
//  MaskingImage
//
//  Created by minii on 2023/07/07.
//

import SwiftUI

extension View {
  public func reverseMask<Mask: View>(
    alignment: Alignment = .center,
    @ViewBuilder _ mask: () -> Mask
  ) -> some View {
    self.mask {
      Rectangle()
        .overlay(alignment: alignment) {
          mask()
            .blendMode(.destinationOut)
        }
    }
  }
}
