//
//  ObItemView.swift
//  ToDoApp
//
//  Created by Kasper Kronborg on 18/05/2021.
//

import SwiftUI

struct ObItemView: View {
  
  let description: String
  
  var body: some View {
    VStack(spacing: 0) {
      HStack {
        Spacer()
        
        Circle()
          .fill(Color.white)
          .frame(width: 15, height: 15)

        Circle()
          .fill(Color.white)
          .frame(width: 15, height: 15)

        Circle()
          .fill(Color.white)
          .frame(width: 15, height: 15)
        
        Spacer()
      }
      .frame(height: 90)
      .background(Color.gray)
      
      Rectangle().fill(Color.gray).frame(width: 50, height: 50)
      
      Text(self.description).foregroundColor(Theme.Palette.Text.Primary)
      
      Spacer()
    }
  }
}

struct OnboardingPageView_Previews: PreviewProvider {
  static var previews: some View {
    ObItemView(description: "Hello World")
  }
}
