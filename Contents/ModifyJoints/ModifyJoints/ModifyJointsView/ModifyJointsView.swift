//
//  ModifyJointsView.swift
//  ModifyJoints
//
//  Created by minii on 2023/07/17.
//

import SwiftUI

struct ModifyJointsView: View {
  let maskedImage: UIImage
  @StateObject var modifyJointsLink: ModifyJointsLink
  let blue1 = Color("blue1")
  
  init(
    maskedImage: UIImage = UIImage(named: "garlic_texture")!,
    jointsDTO: JointsDTO = mockJointsDTO()!
  ) {
    self.maskedImage = maskedImage
    self._modifyJointsLink = StateObject(
      wrappedValue: ModifyJointsLink(jointsDTO: jointsDTO)
    )
  }
  
  var body: some View {
    VStack {
      ToolNaviBar()
        .frame(height: 40)
      
      Spacer()
      
      VStack {
        JointName()
          .frame(height: 50)
        
        SkeletonView(
          maskedImage: maskedImage,
          modifyJointsLink: self.modifyJointsLink,
          strokeColor: blue1
        )
        .frame(height: 450)
      }
      
      Spacer()
      
      HStack {
        Spacer()
        ResetButton()
      }
    }
    .padding()
    .navigationDestination(
      isPresented: self.$modifyJointsLink.finishSave
    ) {
      ResultView(
        modifiedJointsDTO: self.modifyJointsLink.modifiedJointsDTO,
        maskedImage: self.maskedImage,
        strokeColor: self.blue1
      )
    }
  }
}

extension ModifyJointsView {
  @ViewBuilder
  func ToolNaviBar() -> some View {
    HStack {
      CancelButton()
      Spacer()
      SaveButton()
    }
    .padding(.horizontal)
  }
  
  @ViewBuilder
  func CancelButton() -> some View {
    Image(systemName: "x.circle")
      .resizable()
      .aspectRatio(contentMode: .fit)
      .fontWeight(.semibold)
      .foregroundColor(blue1)
  }
  
  @ViewBuilder
  func SaveButton() -> some View {
    Button {
      self.modifyJointsLink.startSave.send()
    } label: {
      Image(systemName: "square.and.arrow.down")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .fontWeight(.semibold)
        .foregroundColor(blue1)
    }
  }
}

extension ModifyJointsView {
  @ViewBuilder
  func JointName() -> some View {
    let jointColor = Color("jointname")
    let textInset: CGFloat = 5
    
    RoundedRectangle(cornerRadius: 10)
      .foregroundColor(jointColor)
      .padding(.vertical, textInset)
      .overlay {
        Text(jointNameDescription)
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .lineLimit(1)
          .font(.system(size: 100))
          .minimumScaleFactor(0.001)
          .foregroundColor(.white)
          .padding(.horizontal, textInset)
      }
  }
  
  var jointNameDescription: String {
    if let name = self.modifyJointsLink.currentJoint {
      return name
    }
    return "Adjust by dragging the points"
  }
}

extension ModifyJointsView {
  @ViewBuilder
  func ResetButton() -> some View {
    let size: CGFloat = 60
    let imageName = "arrow.uturn.backward"
    
    Button(action: resetAction) {
      Circle()
        .frame(width: size, height: size)
        .foregroundColor(.white)
        .shadow(radius: 10)
        .overlay {
          Image(systemName: imageName)
            .resizable()
            .foregroundColor(blue1)
            .fontWeight(.semibold)
            .padding()
        }
    }
  }
  
  func resetAction() {
    self.modifyJointsLink.resetSkeletonRatio()
  }
}

struct Previews_ModifyJointsView: View {
  var body: some View {
    ModifyJointsView()
  }
}

struct ModifyJointsView_Previews: PreviewProvider {
  static var previews: some View {
    Previews_ModifyJointsView()
  }
}
