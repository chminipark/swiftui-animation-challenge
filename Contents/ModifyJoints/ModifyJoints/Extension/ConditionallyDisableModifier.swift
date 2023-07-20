//
//  ConditionallyDisableModifier.swift
//  ModifyJoints
//
//  Created by minii on 2023/07/20.
//

import SwiftUI

public extension View {
  @ViewBuilder
  func `if`<T: View, U: View>(
    _ condition: Bool,
    then modifierT: (Self) -> T,
    else modifierU: (Self) -> U
  ) -> some View {
    if condition { modifierT(self) }
    else { modifierU(self) }
  }
}
