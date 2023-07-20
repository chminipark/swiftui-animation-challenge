//
//  JointsView.swift
//  ModifyJoints
//
//  Created by minii on 2023/07/18.
//

import SwiftUI

struct JointsView: View {
  @ObservedObject var modifyJointsLink: ModifyJointsLink
  let strokeColor: Color
  let jointCircleSize: CGFloat = 15
  var skeletonDict: [String : SkeletonInfo] {
    return self.modifyJointsLink.jointsInfo.skeletonInfo
  }
  
  let enableDragGesture: Bool
  
  init(
    modifyJointsLink: ModifyJointsLink,
    strokeColor: Color,
    enableDragGesture: Bool = true
  ) {
    self.modifyJointsLink = modifyJointsLink
    self.strokeColor = strokeColor
    self.enableDragGesture = enableDragGesture
  }
  
  var body: some View {
    ForEach(Array(skeletonDict.keys), id: \.self) { name in
      if let mySkeleton = skeletonDict[name] {
        JointCircle()
          .offset(calJointOffset(mySkeleton))
          .if(self.enableDragGesture) {
            $0.gesture(
              DragGesture(coordinateSpace: .local)
                .onChanged({ value in
                  updateCurrentJoint(mySkeleton)
                  dragOnChanged(value, skeletonInfo: mySkeleton)
                })
                .onEnded(dragOnEnded(_:))
            )
          } else: { $0 }
      }
    }
  }
}

extension JointsView {
  @ViewBuilder
  func JointCircle() -> some View {
    Circle()
      .frame(width: jointCircleSize, height: jointCircleSize)
      .foregroundColor(strokeColor)
      .overlay {
        Circle()
          .strokeBorder(.white, lineWidth: 2)
      }
  }
}

extension JointsView {
  func calJointOffset(_ skeletonInfo: SkeletonInfo) -> CGSize {
    let widthView: CGFloat = self.modifyJointsLink.jointsInfo.viewSize.width
    let heightView: CGFloat = self.modifyJointsLink.jointsInfo.viewSize.height
    
    let ratioX: CGFloat = skeletonInfo.ratioPoint.x
    let ratioY: CGFloat = skeletonInfo.ratioPoint.y
    
    return CGSize(
      width: (widthView * ratioX) - (self.jointCircleSize / 2),
      height: (heightView * ratioY) - (self.jointCircleSize / 2)
    )
  }
  
  func updateCurrentJoint(_ skeletonInfo: SkeletonInfo) {
    if self.modifyJointsLink.currentJoint == nil {
      self.modifyJointsLink.currentJoint = skeletonInfo.name
    }
  }
  
  func dragOnChanged(_ value: DragGesture.Value, skeletonInfo: SkeletonInfo) {
    let widthView: CGFloat = self.modifyJointsLink.jointsInfo.viewSize.width
    let heightView: CGFloat = self.modifyJointsLink.jointsInfo.viewSize.height
    let nexX: CGFloat = value.location.x
    let nexY: CGFloat = value.location.y
    
    guard 0 <= nexX && nexX <= widthView &&
            0 <= nexY && nexY <= heightView else {
      return
    }
    
    let nexRatioPoint = CGPoint(x: nexX / widthView, y: nexY / heightView)
    skeletonInfo.ratioPoint = nexRatioPoint
  }
  
  func dragOnEnded(_ value: DragGesture.Value) {
    self.modifyJointsLink.currentJoint = nil
  }
}

struct JointsView_Previews: PreviewProvider {
  static var previews: some View {
    Previews_ModifyJointsView()
  }
}
