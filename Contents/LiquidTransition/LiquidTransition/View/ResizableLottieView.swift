//
//  ResizableLottieView.swift
//  LiquidTransition
//
//  Created by minii on 2023/04/06.
//

import SwiftUI
import Lottie

struct ResizableLottieView: UIViewRepresentable {
  @Binding var lottieView: LottieAnimationView
  
  func makeUIView(context: Context) -> UIView {
    let view = UIView()
    view.backgroundColor = .clear
    addLottieView(to: view)
    return view
  }
  
  func updateUIView(_ uiView: UIView, context: Context) {
    
  }
  
  func addLottieView(to rootView: UIView){
    lottieView.backgroundColor = .clear
    lottieView.translatesAutoresizingMaskIntoConstraints = false
    // Initially setting to Finished View
    lottieView.currentProgress = 1
    
    let constraints = [
      lottieView.widthAnchor.constraint(equalTo: rootView.widthAnchor),
      lottieView.heightAnchor.constraint(equalTo: rootView.heightAnchor),
    ]
    
    rootView.addSubview(lottieView)
    rootView.addConstraints(constraints)
  }
}
