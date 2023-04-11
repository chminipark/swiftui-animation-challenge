//
//  AnimationCompletionObserver.swift
//  MatchedGeometry_FullScreenCover
//
//  Created by minii on 2023/04/11.
//

import SwiftUI

/// An Animatable modifier which will gives a call back when an animation finished
struct AnimationCompletionObserver<Value>: Animatable, ViewModifier where Value: VectorArithmetic {
  var animatableData: Value {
    didSet {
      notifyCompletion()
    }
  }
  private var targetValue: Value
  private var completion: () -> Void
  
  init(observedValue: Value, completion: @escaping () -> Void) {
    self.completion = completion
    self.animatableData = observedValue
    targetValue = observedValue
  }
  
  private func notifyCompletion() {
    guard animatableData == targetValue else { return }
    
    DispatchQueue.main.async {
      self.completion()
    }
  }
  
  func body(content: Content) -> some View {
    return content
  }
}
