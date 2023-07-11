//
//  TouchDownPanGestureRecognizer.swift
//  MaskingImage
//
//  Created by minii on 2023/07/05.
//

import UIKit

class TouchDownPanGestureRecognizer: UIPanGestureRecognizer {
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
    super.touchesBegan(touches, with: event)
    state = .began
  }
}
