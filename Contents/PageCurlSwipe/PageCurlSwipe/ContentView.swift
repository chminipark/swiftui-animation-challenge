//
//  ContentView.swift
//  PageCurlSwipe
//
//  Created by minii on 2023/05/15.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    NavigationStack {
      Home()
        .navigationTitle("PageCurlSwipe")
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
