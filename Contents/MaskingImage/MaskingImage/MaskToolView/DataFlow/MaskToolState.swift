//
//  MaskToolState.swift
//  MaskingImage
//
//  Created by minii on 2023/07/10.
//

import SwiftUI

class MaskToolState: ObservableObject {
  @Published var drawingAction: DrawingAction = .erase
  @Published var resetAction: ResetAction = .undo
  @Published var circleRadius: CGFloat = 15
}
