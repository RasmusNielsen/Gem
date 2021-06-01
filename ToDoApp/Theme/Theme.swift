//
//  Theme.swift
//  ToDoApp
//
//  Created by Kasper Kronborg on 20/05/2021.
//

import SwiftUI

class Theme {
    // MARK: - Palette
    
    struct Palette {
        // MARK: - Background
        
        struct Background {
            static let Default = Color("Palette.Background.Default")
        }
        
        // MARK: - Text
        
        struct Text {
            static let Primary = Color("Palette.Text.Primary")
        }
        
        // MARK: - Primary
        
        struct Primary {
            static let Main = Color("Palette.Primary.Main")
            static let TextContrast = Color("Palette.Primary.TextContrast")
        }
    }
}
