//
//  MaskToolPanel.swift
//  MaskingImage
//
//  Created by minii on 2023/07/07.
//

import SwiftUI

struct MaskToolPanel: View {
  @Binding var toolSizerSize: CGFloat
  let height: CGFloat
  
  var body: some View {
    RoundedRectangle(cornerRadius: 55)
      .reverseMask {
        ToolSizerCurveShape()
      }
      .foregroundColor(.white)
      .frame(height: height)
      .shadow(radius: 10)
  }
  
  func ToolSizerCurveShape() -> some View {
    GeometryReader { geo in
      let widthShape: CGFloat = toolSizerSize * 2
      let heightShape: CGFloat = height / 2
      
      let midX: CGFloat = (geo.size.width / 2)
      let startX: CGFloat = midX - (widthShape / 2)
      
      CurveShape(
        widthShape: widthShape,
        heightShape: heightShape,
        startX: startX
      )
    }
  }
}

extension MaskToolPanel {
  struct CurveShape: Shape {
    let width: CGFloat
    let height: CGFloat
    let startX: CGFloat
    let midX: CGFloat
    
    init(
      widthShape: CGFloat,
      heightShape: CGFloat,
      startX: CGFloat)
    {
      self.width = widthShape
      self.height = heightShape
      self.startX = startX
      self.midX = (startX + (widthShape / 2))
    }
    
    func path(in rect: CGRect) -> Path {
      var path = Path()
      
      let startPoint = CGPoint(x: startX, y: 0)
      path.move(to: startPoint)
      
      let dist: CGFloat = width / 4
      
      let curve1ControlX: CGFloat = midX - dist
      addCurve1(
        path: &path,
        midXShape: midX,
        controlX: curve1ControlX
      )
      
      let curve2ControlX: CGFloat = midX + dist
      addCurve2(
        path: &path,
        controlX: curve2ControlX
      )
      
      return path
    }
    
    func addCurve1(
      path: inout Path,
      midXShape: CGFloat,
      controlX: CGFloat
    ) {
      path.addCurve(
        to: CGPoint(x: midXShape, y: height),
        control1: CGPoint(x: controlX, y: 0),
        control2: CGPoint(x: controlX, y: height)
      )
    }
    
    func addCurve2(
      path: inout Path,
      controlX: CGFloat
    ) {
      path.addCurve(
        to: CGPoint(x: startX + width, y: 0),
        control1: CGPoint(x: controlX, y: height),
        control2: CGPoint(x: controlX, y: 0)
      )
    }
  }
}

struct MaskToolPanel_Previews: PreviewProvider {
  static var previews: some View {
    RootView()
  }
}
