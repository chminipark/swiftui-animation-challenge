//
//  Extension+GeometryProxy.swift
//  Umbrella
//
//  Created by minii on 2023/04/09.
//

import SwiftUI

extension GeometryProxy {
  var minSize: CGFloat {
    return min(self.size.width, self.size.height)
  }
}
