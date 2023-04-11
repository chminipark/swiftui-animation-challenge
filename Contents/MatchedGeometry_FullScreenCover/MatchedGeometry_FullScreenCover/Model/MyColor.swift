//
//  MyColor.swift
//  MatchedGeometry_FullScreenCover
//
//  Created by minii on 2023/04/10.
//

import SwiftUI

struct MyColor: Identifiable, Hashable {
  var id = UUID()
  var color: Color
}

extension MyColor {
  static func mockArray(count: Int) -> [MyColor] {
    return (0 ..< count).map { _ in
      MyColor.init(color: .random())
    }
  }
}

public extension Color {
  static func random(randomOpacity: Bool = false) -> Color {
    Color(
      red: .random(in: 0...1),
      green: .random(in: 0...1),
      blue: .random(in: 0...1),
      opacity: randomOpacity ? .random(in: 0...1) : 1
    )
  }
}
