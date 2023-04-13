//
//  User.swift
//  TinderUI
//
//  Created by minii on 2023/04/13.
//

import SwiftUI

struct User: Identifiable {
  var id = UUID().uuidString
  var userColor: Color
}

extension User {
  static func mock() -> User {
    User(userColor: .random())
  }
  
  static func mockArray(count: Int) -> [User] {
    return (0 ..< count).map { _ in User.mock() }
  }
}
