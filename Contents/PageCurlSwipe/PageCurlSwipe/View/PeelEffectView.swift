//
//  PeelEffectView.swift
//  PageCurlSwipe
//
//  Created by minii on 2023/05/15.
//

import SwiftUI

struct PeelEffectView<Content: View>: View {
  var onDelete: () -> ()
  var content: Content
  
  @State private var dragProgress: CGFloat = 0
  @State private var isExpanded: Bool = false
  
  init(
    onDelete: @escaping () -> (),
    @ViewBuilder content: () -> Content
  ) {
    self.onDelete = onDelete
    self.content = content()
  }
  
  var body: some View {
    content
      .hidden()
      .overlay {
        DeleteButton()
      }
      .overlay {
        RollingImage()
      }
  }
}

extension PeelEffectView {
  @ViewBuilder
  func DeleteButton() -> some View  {
    GeometryReader { proxy in
      let rect = proxy.frame(in: .global)
      let minX = rect.minX
      
      RoundedRectangle(cornerRadius: 15, style: .continuous)
        .fill(.red.gradient)
        .overlay(alignment: .trailing) {
          Button(action: deleteAction) {
            Image(systemName: "trash")
              .font(.title)
              .fontWeight(.semibold)
              .padding(.trailing, 20)
              .foregroundColor(.white)
              .contentShape(Rectangle())
          }
          .disabled(!isExpanded)
          
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
        .gesture(
          DragGesture()
            .onChanged({ value in
              guard !isExpanded else { return }
              var translationX = value.translation.width
              // 0 <= translationX <= 0.9
              translationX = max(0, -translationX)
              translationX = min(0.9, translationX / rect.width)
              dragProgress = translationX
            })
            .onEnded({ value in
              guard !isExpanded else { return }
              withAnimation(.spring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                if dragProgress > 0.25 {
                  dragProgress = 0.6
                  isExpanded = true
                } else {
                  dragProgress = .zero
                  isExpanded = false
                }
              }
            })
        )
        // reset rolling image
        .onTapGesture {
          withAnimation(.spring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
            dragProgress = .zero
            isExpanded = false
          }
        }
      
      // shadow
      Rectangle()
        .fill(.black)
        .padding(.vertical, 23)
        .shadow(color: .black.opacity(0.3), radius: 15, x: 30, y: 0)
        .padding(.trailing, rect.width * dragProgress)
        .mask(content)
        .allowsHitTesting(false)
        .offset(x: dragProgress == 1 ? -minX : 0)
      
      // Masking Orignal Content
      content
        .mask {
          Rectangle()
            .padding(.trailing, dragProgress * rect.width)
        }
        .allowsHitTesting(false)
        .offset(x: dragProgress == 1 ? -minX : 0)
    }
  }
  
  func deleteAction() -> () {
    withAnimation(.spring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
      dragProgress = 1
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
      onDelete()
    }
  }
}

extension PeelEffectView {
  @ViewBuilder
  func RollingImage() -> some View  {
    GeometryReader { proxy in
      let size = proxy.size
      let minX = proxy.frame(in: .global).minX
      let minOpacity = dragProgress / 0.05
      let opacity = min(1, minOpacity)
      
      content
        .shadow(color: .black.opacity(dragProgress != 0 ? 0.2 : 0), radius: 5, x: 15, y: 0)
        .overlay {
          Rectangle()
            .fill(.white.opacity(0.25))
            .mask(content)
        }
        .overlay(alignment: .trailing) {
          Rectangle()
            .fill(
              .linearGradient(colors: [
                .clear,
                .white,
                .clear,
                .clear
              ], startPoint: .leading, endPoint: .trailing)
            )
            .frame(width: 60)
            .offset(x: 40)
            .offset(x: -30 + (30 * opacity))
            .offset(x: size.width * -dragProgress)
        }
        // Flipping Horizontally for Upside Image
        .scaleEffect(x: -1)
        .offset(x: size.width - (size.width * dragProgress))
        .offset(x: size.width * -dragProgress)
        // Masking Overlayed Image For Removing Outbound Visibilty
        .mask {
          Rectangle()
            .offset(x: size.width * -dragProgress)
        }
        .offset(x: dragProgress == 1 ? -minX : 0)
    }
    .allowsHitTesting(false)
  }
}

struct PeelEffectView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
