//
//  HomeView.swift
//  ToDoApp
//
//  Created by Kasper Kronborg on 18/05/2021.
//

import SwiftUI

// MARK: - Implementation

struct HomeView: View {
  // MARK: - Internal State
  
  @AppStorage(K.Key.isOnboardingCompleted) private var isOnboardingCompleted = false
  
  // MARK: - Private Properties
  
  private let obItems = [
    ObItem(description: "Start by imagining your mind as the rock you see here. It’s hard, cold and sturdy", buttonLabel: "", onboardingVideo: "intro1", headerImg: "labelOnboardingHeader1"),
    ObItem(description: "Tracking down positive things that happens to you each day you will force you mind to focus on these", buttonLabel: "", onboardingVideo: "intro2", headerImg: "labelOnboardingHeader2"),
    ObItem(description: "Tracking down positive things that happens to you each day you will force you mind to focus on these", buttonLabel: "", onboardingVideo: "intro3", headerImg: "labelOnboardingHeader3"),
  ]

  
  // MARK: - Handlers
  
  func onEnd() {
    self.isOnboardingCompleted = true
  }
  
  // MARK: - Private Interface
  
  private func isOnboardingPresented() -> Binding<Bool> {
    Binding(
      get: { !self.isOnboardingCompleted },
      set: { value in self.isOnboardingCompleted = !value }
    )
  }
  
  // MARK: - Render
  
  var body: some View {
    VStack {
      Text("Home View")
      Button("Show") { self.isOnboardingCompleted = false }
    }
    .fullScreenCover(isPresented: self.isOnboardingPresented()) {
      VStack {
        ObCarouselView(items: self.obItems, onEnd: self.onEnd)
      }
      .background(Theme.Palette.Background.Default.ignoresSafeArea())
    }
  }
}

// MARK: - Preview

private struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView()
  }
}
