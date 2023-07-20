//
//  ModifyJointsLink.swift
//  ModifyJoints
//
//  Created by minii on 2023/07/17.
//

import SwiftUI
import Combine

class ModifyJointsLink: ObservableObject {
  @Published var jointsInfo: JointsInfo
  var startSave = PassthroughSubject<Void, Never>()
  @Published var finishSave = false
  
  @Published var currentJoint: String? = nil
  var originData: [String : CGPoint]
  var modifiedJointsDTO: JointsDTO
  var originalDTOSize: CGSize
  
  var anyCancellable = Set<AnyCancellable>()
  
  init(jointsDTO: JointsDTO) {
    self._jointsInfo = Published(initialValue: jointsDTO.toDomain())
    self.modifiedJointsDTO = jointsDTO
    self.originalDTOSize = CGSize(width: jointsDTO.width, height: jointsDTO.height)
    
    let cgWidth = CGFloat(jointsDTO.width)
    let cgHeight = CGFloat(jointsDTO.height)
    self.originData = jointsDTO.skeletonDTO.reduce(into: [String : CGPoint]()) { dict, dto in
      let ratioX: CGFloat = cgWidth == 0 ? 0 : CGFloat(dto.location[0]) / cgWidth
      let ratioY: CGFloat = cgHeight == 0 ? 0 : CGFloat(dto.location[1]) / cgHeight
      
      dict[dto.name] = CGPoint(x: ratioX, y: ratioY)
    }
    
    self.startSave.sink { [weak self] _ in
      guard let `self` = self else {
        return
      }
      
      self.modifiedJointsDTO = self.jointsInfo.toData(originalDTOSize: originalDTOSize)
      // put any save logic
      
      `self`.finishSave.toggle()
    }
    .store(in: &self.anyCancellable)
    
    self.jointsInfo.objectWillChange.sink { [weak self] _ in
      guard let `self` = self else {
        return
      }
      
      `self`.objectWillChange.send()
    }
    .store(in: &self.anyCancellable)
  }
}

extension ModifyJointsLink {
  func resetSkeletonRatio() {
    self.originData.forEach { name, cgPoint in
      guard let curSkeletonInfo = self.jointsInfo.skeletonInfo[name] else {
        return
      }
      curSkeletonInfo.ratioPoint = cgPoint
    }
  }
}
