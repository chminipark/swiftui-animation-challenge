//
//  JointsDTO.swift
//  ModifyJoints
//
//  Created by minii on 2023/07/17.
//

import Foundation

struct JointsDTO: Decodable {
  var width: Int
  var height: Int
  var skeletonDTO: [SkeletonDTO]
  
  enum CodingKeys: String, CodingKey {
    case width
    case height
    case skeletonDTO = "skeleton"
  }
}

struct SkeletonDTO: Decodable {
  var name: String
  var location: [Int]
  var parent: String?
  
  enum CodingKeys: String, CodingKey {
    case name
    case location = "loc"
    case parent
  }
}

extension JointsDTO {
  func toDomain() -> JointsInfo {
    let cgWidth = CGFloat(self.width)
    let cgHeight = CGFloat(self.height)
    
    return JointsInfo(
      viewSize: CGSize(width: cgWidth, height: cgHeight),
      skeletonInfo: self.skeletonDTO
        .reduce(into: [String : SkeletonInfo]()) { dict, dto in
          let ratioX: CGFloat = cgWidth == 0 ? 0 : CGFloat(dto.location[0]) / cgWidth
          let ratioY: CGFloat = cgHeight == 0 ? 0 : CGFloat(dto.location[1]) / cgHeight
          
          let skeletonInfo = SkeletonInfo(
            name: dto.name,
            ratioPoint: CGPoint(x: ratioX, y: ratioY),
            parent: dto.parent
          )
          
          dict[dto.name] = skeletonInfo
      }
    )
  }
}

