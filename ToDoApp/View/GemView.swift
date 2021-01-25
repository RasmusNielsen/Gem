//
//  GemView.swift
//  ToDoApp
//
//  Created by Rasmus Nielsen on 20/01/2021.
//

import Foundation
import SwiftUI
import CoreData

struct GemView: View {
 
  @Environment(\.managedObjectContext) var moc
  @State private var date = Date()
  @FetchRequest(
    entity: ToDo.entity(),
    sortDescriptors: [
      NSSortDescriptor(keyPath: \ToDo.date, ascending: true)
    ]
  ) var todos: FetchedResults<ToDo>

  var dateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return formatter
  }
  
  func update(_ result : FetchedResults<ToDo>)-> [[ToDo]]{
    return  Dictionary(grouping: result){ (element : ToDo)  in
          dateFormatter.string(from: element.date!)
    }.values.map{$0}
  }
  
  var body: some View {
    VStack {
      List {
        ForEach(update(todos), id: \.self) { (section: [ToDo]) in
          Section(header: Text( self.dateFormatter.string(from: section[0].date!))) {
            ForEach(section, id: \.self) { todo in
              HStack {
                Text(todo.task ?? "")
                Text("\(todo.date ?? Date(), formatter: self.dateFormatter)")
              }
            }
          }
        }.id(todos.count)
      }
      
    }
  }
}

struct GemView_Previews: PreviewProvider {
    static var previews: some View {
        GemView()
    }
}
