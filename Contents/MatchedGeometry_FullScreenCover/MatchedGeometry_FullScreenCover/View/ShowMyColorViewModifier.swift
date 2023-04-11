//
//  ShowMyColorViewModifier.swift
//  MatchedGeometry_FullScreenCover
//
//  Created by minii on 2023/04/11.
//

import SwiftUI

// Use
extension View {
  @ViewBuilder
  func showMyColor<Overlay: View>(
    show: Binding<Bool>,
    @ViewBuilder overlay: @escaping () -> Overlay
  ) -> some View {
    self.modifier(ShowMyColorViewModifier(show: show, overlay: overlay()))
  }
}

fileprivate struct ShowMyColorViewModifier<Overlay: View>: ViewModifier {
  @Binding var show: Bool
  var overlay: Overlay
  
  @State private var hostView: CustomHostingView<Overlay>?
  @State private var parentController: UIViewController?
  
  func body(content: Content) -> some View {
    content
      .background {
        ExtractSwiftUIParentController(overlay: overlay, hostView: $hostView) { viewcontroller in
          parentController = viewcontroller
        }
      }
    /// Presenting/Dismissing Host View based on Show State
      .onChange(of: show) { newValue in
        if newValue {
          hostView = CustomHostingView(show: $show, rootView: overlay)
          /// Present View
          if let hostView {
            /// Changing Presentation Style and Transition Style
            hostView.modalPresentationStyle = .overCurrentContext
            hostView.modalTransitionStyle = .crossDissolve
            hostView.view.backgroundColor = .clear
            /// We Need a parent View controller to present it
            parentController?.present(hostView, animated: false)
          }
        } else {
          /// Dismiss View
          hostView?.dismiss(animated: false)
        }
      }
  }
}

fileprivate struct ExtractSwiftUIParentController<Overlay: View>: UIViewRepresentable {
  var overlay: Overlay
  @Binding var hostView: CustomHostingView<Overlay>?
  var parentController: (UIViewController?) -> ()
  
  func makeUIView(context: Context) -> UIView {
    /// Simply Return Empty View
    return UIView()
  }
  
  func updateUIView(_ uiView: UIView, context: Context) {
    /// Update HostView's Root View (So that SwiftUI Will be updated when ever any state changes occurs in it's view)
    hostView?.rootView = overlay
    DispatchQueue.main.async {
      /// Retrieve it's parent view controller
      // MARK: ...
      parentController(uiView.superview?.superview?.parentController)
    }
  }
}

fileprivate class CustomHostingView<Overlay: View>: UIHostingController<Overlay> {
  @Binding var show: Bool
  
  init(show: Binding<Bool>, rootView: Overlay) {
    self._show = show
    super.init(rootView: rootView)
  }
  
  required dynamic init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    /// Since we don't need any default animation while dismissing
    super.viewWillDisappear(false)
    /// Setting show Status to false
    show = false
  }
}

/// Return parent view controller for the given UIView
fileprivate extension UIView {
  var parentController: UIViewController? {
    var responder = self.next
    while responder != nil {
      if let viewController = responder as? UIViewController {
        return viewController
      }
      responder = responder?.next
    }
    
    return nil
  }
}
