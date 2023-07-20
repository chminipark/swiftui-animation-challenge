//
//  ResultView.swift
//  ModifyJoints
//
//  Created by minii on 2023/07/17.
//

import SwiftUI

struct ResultView: View {
  let maskedImage: UIImage
  let strokeColor: Color
  @StateObject var modifyJointsLink: ModifyJointsLink
  
  init(
    modifiedJointsDTO: JointsDTO,
    maskedImage: UIImage,
    strokeColor: Color
  ) {
    self._modifyJointsLink = StateObject(
      wrappedValue: ModifyJointsLink(jointsDTO: modifiedJointsDTO)
    )
    self.maskedImage = maskedImage
    self.strokeColor = strokeColor
  }
  
  var body: some View {
    VStack {
      RoundedRectangle(cornerRadius: 10)
        .foregroundColor(.white)
        .shadow(radius: 10)
        .overlay {
          Image(uiImage: maskedImage)
            .resizable()
            .overlay {
              GeometryReader { geo in
                ZStack(alignment: .topLeading) {
                  Color.clear
                    .onAppear {
                      let viewSize = geo.frame(in: .local).size
                      self.modifyJointsLink.jointsInfo.viewSize = viewSize
                    }
                  
                  BonesView(
                    modifyJointsLink: self.modifyJointsLink,
                    strokeColor: self.strokeColor
                  )
                  JointsView(
                    modifyJointsLink: self.modifyJointsLink,
                    strokeColor: self.strokeColor,
                    enableDragGesture: false
                  )
                }
              }
            }
            .padding()
        }
    }
    .frame(height: 450)
    .padding()
  }
}
