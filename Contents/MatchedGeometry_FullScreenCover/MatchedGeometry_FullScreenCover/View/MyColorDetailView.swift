//
//  MyColorDetailView.swift
//  MatchedGeometry_FullScreenCover
//
//  Created by minii on 2023/04/11.
//

import SwiftUI

struct MyColorDetailView: View {
  @Binding var myColor: MyColor
  var animationID: Namespace.ID
  @Environment(\.dismiss) private var dismiss
  @State private var animateDetailView: Bool = false
  @State private var animateContent: Bool = false
  @State private var completionValue: CGFloat = 0.0
  
  var body: some View {
    VStack {
      if animateDetailView {
        Rectangle()
          .fill(myColor.color.gradient)
          .matchedGeometryEffect(id: myColor.id.uuidString, in: animationID)
          .frame(width: 200, height: 200)
        // MARK: ..
          .transition(.asymmetric(insertion: .identity, removal: .offset(x: 10, y: 10)))
      } else {
        Rectangle()
          .fill(.clear)
          .frame(width: 200, height: 200)
      }
      
      Text("MatchedGeometry With FullScreenCover")
        .padding(.top,10)
        .opacity(animateContent ? 1 : 0)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background {
      Color.white
        .ignoresSafeArea()
        .opacity(animateContent ? 1 : 0)
    }
    .overlay(alignment: .topLeading) {
      XMarkButton()
        .padding(15)
        .opacity(animateContent ? 1 : 0)
        .modifier(
          AnimationCompletionObserver(
            observedValue: completionValue,
            completion: { dismiss() }
          )
        )
    }
    .onAppear {
      withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.8, blendDuration: 0.8)) {
        animateContent = true
        animateDetailView = true
      }
    }
  }
}

extension MyColorDetailView {
  @ViewBuilder
  func XMarkButton() -> some View {
    Button {
      withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.8, blendDuration: 0.8)) {
        animateContent = false
        animateDetailView = false
        myColor = .init(color: .clear)
        completionValue = 1.0
      }
    } label: {
      Image(systemName: "xmark.circle.fill")
        .font(.title)
        .foregroundColor(.primary)
    }
  }
}
