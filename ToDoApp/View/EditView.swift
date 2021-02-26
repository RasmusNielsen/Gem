//
//  EditView.swift
//  ToDoApp
//
//  Created by Rasmus Nielsen on 26/02/2021.
//

import Foundation
import SwiftUI
import CoreData


struct EditView: View {

    @State var task = ""
    var body: some View {
        VStack{
            TextField("Edit Here", text: self.$task)
              .padding(.horizontal)
              .padding(.bottom)
              .padding(.top)
              .disableAutocorrection(true)
              .keyboardType(.webSearch)
              .font(.largeTitle)
              .introspectTextField { textField in
                  textField.becomeFirstResponder()
              }
            
          
          Spacer()
        
        }
        .accentColor(.black)
    }
}
