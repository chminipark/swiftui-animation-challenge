//
//  HomeViewModel.swift
//  TinderUI
//
//  Created by minii on 2023/04/13.
//

import SwiftUI

class HomeViewModel: ObservableObject {
  @Published var fetchedUsers: [User] = []
  @Published var displayingUsers: [User]?
  
  init() {
    fetchedUsers = User.mockArray(count: 5)
    displayingUsers = fetchedUsers
  }
  
  func getIndex(user: User) -> Int {
    let index = displayingUsers?.firstIndex(where: { currentUser in
      return user.id == currentUser.id
    }) ?? 0
    
    return index
  }
}
