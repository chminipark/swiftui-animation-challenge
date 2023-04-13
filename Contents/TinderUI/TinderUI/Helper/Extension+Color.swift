//
//  Extension+Color.swift
//  TinderUI
//
//  Created by minii on 2023/04/13.
//

import SwiftUI

public extension Color {
  static func random() -> Color {
    Color(
      red: .random(in: 0...1),
      green: .random(in: 0...1),
      blue: .random(in: 0...1)
    )
  }
}
