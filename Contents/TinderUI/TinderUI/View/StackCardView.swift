//
//  StackCardView.swift
//  TinderUI
//
//  Created by minii on 2023/04/13.
//

import SwiftUI

struct StackCardView: View {
  @EnvironmentObject var homeData: HomeViewModel
  var user: User
  
  @State var offset: CGFloat = 0
  @GestureState var isDragging: Bool = false
  @State var endSwipe: Bool = false
  
  var body: some View {
    GeometryReader { proxy in
      let size = proxy.size
      let index = CGFloat(homeData.getIndex(user: user))
      let topOffset = (index <= 2 ? index : 2) * 15
      
      ZStack {
        RoundedRectangle(cornerRadius: 15)
          .fill(user.userColor)
          .frame(width: size.width - topOffset, height: size.height)
          .offset(y: -topOffset)
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
    .offset(x: offset)
    .rotationEffect(.init(degrees: getRotation(angle: 8)))
    .gesture(
      cardDragGesture()
    )
    .onReceive(
      NotificationCenter.default.publisher(
        for: Notification.Name("ACTIONFROMBUTTON"),
        object: nil
      ),
      perform: circleButtonPerform
    )
  }
}

// MARK: Gesture
extension StackCardView {
  func getRotation(angle: Double) -> Double {
    let rotation = (offset / (getRect().width - 50)) * angle
    return rotation
  }
  
  func cardDragGesture() -> some Gesture {
    DragGesture()
      .updating($isDragging, body: { value, out, _ in
        out = true
      })
      .onChanged({ value in
        let translation = value.translation.width
        offset = translation
      })
      .onEnded({ value in
        let width = getRect().width - 50
        let translation = value.translation.width
        let checkingStatus = (0 < translation ? translation : -translation)
        
        withAnimation {
          if (width / 2) < checkingStatus {
            offset = (0 < translation ? width : -width) * 2
            endSwipeActions()
            
            if translation < 0 {
              leftSwipe()
            } else {
              rightSwipe()
            }
          } else {
            offset = .zero
          }
        }
      })
  }
}

// MARK: Action
extension StackCardView {
  func endSwipeActions(){
    withAnimation(.none) { endSwipe = true }
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      if let _ = homeData.displayingUsers?.first{
        let _ = withAnimation {
          homeData.displayingUsers?.removeFirst()
        }
      }
    }
  }
  
  func leftSwipe(){
    // DO ACTIONS HERE...
    print("Left Swiped")
  }
  
  func rightSwipe(){
    // DO ACTIONS HERE...
    print("Right Swiped")
  }
  
  func circleButtonPerform(data: NotificationCenter.Publisher.Output) {
    guard let info = data.userInfo else{
      return
    }
    
    let id = info["id"] as? String ?? ""
    let rightSwipe = info["rightSwipe"] as? Bool ?? false
    let width = getRect().width - 50
    
    if user.id == id {
      withAnimation{
        offset = (rightSwipe ? width : -width) * 2
        endSwipeActions()
        
        if rightSwipe{
          self.rightSwipe()
        }
        else{
          leftSwipe()
        }
      }
    }
  }
}

struct StackCardView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView()
  }
}
