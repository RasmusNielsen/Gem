//
//  ObCarouselView.swift
//  ToDoApp
//
//  Created by Kasper Kronborg on 17/05/2021.
//

import SwiftUI

// MARK: - Implementation

struct ObCarouselView: View {
    // MARK: - Public Properties
    
    let items: [ObItem]
    var onEnd: () -> Void = {}
    
    // MARK: - Internal State
    
    @State private var selectedItemIndex: Int = 0
  
    // MARK: - Handlers
    
    func onNext(after: ObItem) {
        if let currentItemIndex = self.items.firstIndex(of: after) {
            self.selectedItemIndex = self.items.index(after: currentItemIndex)
        }
    }
    
    // MARK: - Private Interface
    
    func button(forItem item: ObItem) -> some View {
        item == self.items.last
            ? Button("End") { self.onEnd() }
            : Button("Next") { withAnimation { onNext(after: item) } }
    }
    
    // MARK: - Render
    
    var body: some View {
        TabView(selection: self.$selectedItemIndex) {
            ForEach(0 ..< self.items.count) { itemIndex in
                if let item = self.items[itemIndex] {
                    VStack {
                        ObItemView(description: item.description)
                        Spacer()
                        self.button(forItem: item)
                            .foregroundColor(Theme.Palette.Primary.TextContrast)
                            .padding()
                            .background(Theme.Palette.Primary.Main)
                            .cornerRadius(8)
                            .padding(30)
                    }.tag(itemIndex)
                }
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
    }
}

// MARK: - Preview

private struct OnboardingPageCarouselView_Previews: PreviewProvider {
    static var previews: some View {
        ObCarouselView(items: [
            ObItem(description: "Hello World")
        ])
    }
}
