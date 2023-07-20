//
//  BonesView.swift
//  ModifyJoints
//
//  Created by minii on 2023/07/20.
//

import SwiftUI

struct BonesView: View {
  @ObservedObject var modifyJointsLink: ModifyJointsLink
  let strokeColor: Color
  var skeletonDict: [String : SkeletonInfo] {
    return self.modifyJointsLink.jointsInfo.skeletonInfo
  }
  var viewRect: CGRect {
    return CGRect(origin: .init(), size: modifyJointsLink.jointsInfo.viewSize)
  }
  
  var body: some View {
    ForEach(Array(self.skeletonDict.keys), id: \.self) { myName in
      if let mySkeleton = self.skeletonDict[myName] {
        if let parentName = mySkeleton.parent,
            let parentSkeleton = self.skeletonDict[parentName] {
          BoneLine(me: mySkeleton.ratioPoint, parent: parentSkeleton.ratioPoint)
        }
      }
    }
  }
}

extension BonesView {
  @ViewBuilder
  func BoneLine(me: CGPoint, parent: CGPoint) -> some View {
    let myPoint: CGPoint = calPoint(cgPoint: me)
    let parentPoint: CGPoint = calPoint(cgPoint: parent)
    LineShape(myPoint: myPoint, parentPoint: parentPoint)
      .path(in: self.viewRect)
      .stroke(lineWidth: 5)
      .foregroundColor(strokeColor)
  }
  
  struct LineShape: Shape {
    let myPoint: CGPoint
    let parentPoint: CGPoint
    
    func path(in rect: CGRect) -> Path {
      var path = Path()
      
      path.move(to: myPoint)
      path.addLine(to: parentPoint)
      
      return path
    }
  }
  
  func calPoint(cgPoint: CGPoint) -> CGPoint {
    let x = (self.viewRect.width * cgPoint.x)
    let y = (self.viewRect.height * cgPoint.y)
    
    return CGPoint(x: x, y: y)
  }
}
