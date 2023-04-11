//
//  ContentView.swift
//  MatchedGeometry_FullScreenCover
//
//  Created by minii on 2023/04/10.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    NavigationStack {
      Home()
        .navigationTitle("MatchedGeometry")
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

