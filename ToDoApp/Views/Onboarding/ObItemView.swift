//
//  ObItemView.swift
//  ToDoApp
//
//  Created by Kasper Kronborg on 18/05/2021.
//

import SwiftUI
import AVKit

struct ObItemView: View {
    
    let description: String
    let onboardingVideo: String
    let headerImg: String
   
  var body: some View {
        VStack(spacing: 0) {
           
           
            if let videoUrl = Bundle.main.url(forResource: self.onboardingVideo, withExtension: "mov") {
            //VideoPlayer(player: AVPlayer(url: videoUrl))
            }
          
          LottieView(name: self.onboardingVideo).frame(width: 300, height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
          
            Image(self.headerImg)
              .resizable()
              .scaledToFit()
              .frame(width: 220)
              .padding(.bottom, 10)
          
            Text(self.description).foregroundColor(Theme.Palette.Text.Primary)
              .padding(20)
              .fixedSize(horizontal: false, vertical: true)
              .multilineTextAlignment(.center)

            
            Spacer()
        }
    }
}

struct OnboardingPageView_Previews: PreviewProvider {
    static var previews: some View {
        ObItemView(description: "", onboardingVideo: "", headerImg: "")
    }
}
