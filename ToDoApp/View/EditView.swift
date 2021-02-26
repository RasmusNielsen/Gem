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
    @State var task: NSManagedObject
    @State var name: String
    
    @Environment(\.presentationMode) var present

    var body: some View {
        let binding = Binding(
            get: { self.name },
            set: { self.name = $0 }
        )
        VStack {
            TextField("Edit Here", text: binding)
              .padding(.horizontal)
              .padding(.bottom)
              .padding(.top)
              .disableAutocorrection(true)
              .keyboardType(.webSearch)
              .font(.largeTitle)
              .introspectTextField { textField in
                  textField.becomeFirstResponder()
              }
            
            Button(action: { self.save() }, label: { Text("Save") }).disabled(self.name == "" ? true : false)
            Spacer()
        }
        .accentColor(.black)
    }
    
    func save() {
        let appDeleggate = UIApplication.shared.delegate as! AppDelegate
        let context = appDeleggate.persistentContainer.viewContext
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDo")
        do {
            let result = try context.fetch(fetchReq)
            for obj in result as! [NSManagedObject]{
                if task.objectID == obj.objectID {
                    obj.setValue(self.name, forKey: "task")
                    try context.save()
                    self.present.wrappedValue.dismiss()
                }
            }
        } catch {
            // Unhandled.
        }
    }
}
