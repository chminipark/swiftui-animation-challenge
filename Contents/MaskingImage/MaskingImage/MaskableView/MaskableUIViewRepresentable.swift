//
//  MaskableUIViewRepresentable.swift
//  MaskingImage
//
//  Created by minii on 2023/07/05.
//

import SwiftUI
import Combine

struct MaskableUIViewRepresentable: UIViewRepresentable {
  typealias UIViewType = MaskableUIView
  let myFrame: CGRect
  let croppedImage: UIImage
  let maskToolState: MaskToolState
  let maskableViewLink: MaskableViewLink
  
  func makeUIView(context: Context) -> MaskableUIView {
    let maskableUIView = MaskableUIView(
      croppedImage: self.croppedImage,
      curDrawingAction: self.maskToolState.drawingAction,
      curCircleRadius: self.maskToolState.circleRadius
    )
    
    context.coordinator.maskableUIView = maskableUIView
    context.coordinator.maskToolState = self.maskToolState
    context.coordinator.maskableViewLink = self.maskableViewLink
    
    return maskableUIView
  }
  
  func updateUIView(_ uiView: MaskableUIView, context: Context) {
    uiView.updateBounds()
    uiView.curDrawingAction = self.maskToolState.drawingAction
    uiView.curCircleRadius = self.maskToolState.circleRadius
  }
}

extension MaskableUIViewRepresentable {
  func makeCoordinator() -> Coordinator {
    return Coordinator()
  }
  
  class Coordinator {
    var maskableUIView: MaskableUIView?
    private var cancellable = Set<AnyCancellable>()
    
    var maskableViewLink: MaskableViewLink? {
      didSet {
        self.maskableViewLink?.$startMasking
          .dropFirst()
          .sink { _ in
            let maskedImage = self.maskableUIView?.maskedImage
            self.maskableViewLink?.maskedImage = maskedImage
            self.maskableViewLink?.finishMasking.toggle()
          }
          .store(in: &self.cancellable)
      }
    }
    
    var maskToolState: MaskToolState? {
      didSet {
        self.maskToolState?.$resetAction
          .dropFirst()
          .sink { action in
            switch action {
            case .undo:
              self.maskableUIView?.undo()
            case .reset:
              self.maskableUIView?.reset()
            }
          }
          .store(in: &self.cancellable)
      }
    }
  }
}

struct MaskableUIViewRepresentable_Previews: PreviewProvider {
  static var previews: some View {
    RootView()
  }
}
