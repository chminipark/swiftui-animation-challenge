//
//  HomeView.swift
//  TinderUI
//
//  Created by minii on 2023/04/12.
//

import SwiftUI

struct HomeView: View {
  @StateObject var homeData = HomeViewModel()
  
  var body: some View {
    NavigationStack {
      VStack {
        Spacer()
        
        UserCards()
          .padding(.top,30)
          .padding()
          .padding(.vertical)
          .frame(maxWidth: .infinity, maxHeight: .infinity)
        
        CircleButtons()
          .padding(.bottom)
          .disabled(homeData.displayingUsers?.isEmpty ?? false)
          .opacity((homeData.displayingUsers?.isEmpty ?? false) ? 0.6 : 1)
      }
      .navigationTitle("TinderUI")
    }
  }
}

extension HomeView {
  @ViewBuilder
  func UserCards() -> some View {
    ZStack {
      if let users = homeData.displayingUsers {
        if users.isEmpty {
          Text("Come back later we can find more matches for you!")
              .font(.caption)
              .foregroundColor(.gray)
        } else {
          ForEach(users.reversed()) { user in
            StackCardView(user: user)
              .environmentObject(homeData)
          }
        }
      } else {
        ProgressView()
      }
    }
  }
}

extension HomeView {
  @ViewBuilder
  func CircleButtons() -> some View {
    HStack(spacing: 15) {
      Button {
        
      } label: {
        Image(systemName: "arrow.uturn.backward")
          .font(.system(size: 15, weight: .bold))
          .foregroundColor(.white)
          .shadow(radius: 5)
          .padding(13)
          .background(Color.gray)
          .clipShape(Circle())
      }
      
      Button {
        doSwipe(rightSwipe: false)
      } label: {
        Image(systemName: "xmark")
          .font(.system(size: 20, weight: .black))
          .foregroundColor(.white)
          .shadow(radius: 5)
          .padding(18)
          .background(Color.blue)
          .clipShape(Circle())
      }
      
      Button {
        
      } label: {
        Image(systemName: "star.fill")
          .font(.system(size: 15, weight: .bold))
          .foregroundColor(.white)
          .shadow(radius: 5)
          .padding(13)
          .background(Color.yellow)
          .clipShape(Circle())
      }
      
      Button {
        doSwipe(rightSwipe: true)
      } label: {
        Image(systemName: "suit.heart.fill")
          .font(.system(size: 20, weight: .black))
          .foregroundColor(.white)
          .shadow(radius: 5)
          .padding(18)
          .background(Color.pink)
          .clipShape(Circle())
      }
    }
  }
}

extension HomeView {
  func doSwipe(rightSwipe: Bool){
    guard let first = homeData.displayingUsers?.first else {
      return
    }
    
    NotificationCenter.default.post(
      name: NSNotification.Name("ACTIONFROMBUTTON"),
      object: nil,
      userInfo: [
      "id": first.id,
      "rightSwipe": rightSwipe
    ])
  }
}

struct Home_Previews: PreviewProvider {
  static var previews: some View {
    HomeView()
  }
}
