//
//  SettingsView.swift
//  ToDoApp
//
//  Created by Rasmus Nielsen on 13/01/2021.
//

import SwiftUI
import CoreData
import Introspect

struct AddTaskPage: View {
    @State var date = Date()
    @State var task = ""
    
    @Environment(\.presentationMode) var present
//    @State var keyboardHeight : CGFloat = 0
    var body: some View {
        VStack{
            TextField("Type Here", text: self.$task)
              .padding(.horizontal)
              .padding(.bottom)
              .padding(.top)
              .disableAutocorrection(true)
              .keyboardType(.webSearch)
              .font(.largeTitle)
              .introspectTextField { textField in
                  textField.becomeFirstResponder()
              }
            

          Button(action: {self.saveTask()}, label: {Text("Submit")}).disabled(self.task == "" ? true : false)
          
          Spacer()
        
        }
        .accentColor(.black)
      }
    
    func saveTask(){
        let appDeleggate = UIApplication.shared.delegate as! AppDelegate
        let context = appDeleggate.persistentContainer.viewContext
        let coreDataBase = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: context)
        coreDataBase.setValue(self.task, forKey: "task")
        coreDataBase.setValue(self.date, forKey: "date")
        do {
            try context.save()
            self.present.wrappedValue.dismiss()
        }catch{
            print("Error")
        }
    }
}

struct AddTaskPage_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskPage()
    }
}
