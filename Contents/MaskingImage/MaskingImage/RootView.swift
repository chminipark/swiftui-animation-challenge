//
//  RootView.swift
//  MaskingImage
//
//  Created by minii on 2023/07/04.
//

import SwiftUI

struct RootView: View {
  var body: some View {
    NavigationStack {
      MaskableView()
        .navigationTitle("MaskingImage")
    }
  }
}
