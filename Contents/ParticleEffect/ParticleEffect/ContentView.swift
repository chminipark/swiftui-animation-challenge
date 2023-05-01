//
//  ContentView.swift
//  ParticleEffect
//
//  Created by minii on 2023/05/01.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    NavigationStack {
      Home()
        .navigationTitle("ParticleEffect")
    }
    .preferredColorScheme(.dark)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
