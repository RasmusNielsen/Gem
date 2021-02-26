//
//  SettingsView.swift
//  ToDoApp
//
//  Created by Rasmus Nielsen on 13/01/2021.
//

 
import SwiftUI
import CoreData
struct Home: View {
    @ObservedObject var userData: UserData = UserData()
    @State var editMode = EditMode.inactive
  
    @State var isPresented = false
    @State var isSettingsPresented = false
    @State var isEditPresented = false
  
    var body: some View {
        ZStack() {
        NavigationView {
            VStack {
                Button(action: { self.isSettingsPresented = true }) {Text("Settings")}
                    .sheet(isPresented: $isSettingsPresented, onDismiss: {self.fetchTasks()}) {
                  SettingsView()
                }
                List {
                    ForEach(userData.tasks.keys.sorted(by: >), id:\.self) { key in
                      let tasks = userData.tasks[key]!
                      Section(header: Text(key)) {
                        ForEach(tasks) { task in
                            HStack {
                                Text(task.value(forKey: "task") as! String)
                                Spacer()
    
                                Button(action: { self.isEditPresented = true }) {
                                    Image(systemName: "pencil").imageScale(.medium)
                                }.sheet(isPresented: $isEditPresented, onDismiss: {
                                    self.fetchTasks()
                                }) {
                                    EditView(task: task, name: task.value(forKey: "task") as! String)
                                }
//                                Button(action: {
//                                    self.delete(key: key, task: task)
//                                 }) {
//                                    Image(systemName: "trash").imageScale(.medium)
//                                 }

                            }
                        }
                      }
                    }
                }.listStyle(GroupedListStyle())
            }
            .environment(\.editMode, self.$editMode)
            .navigationBarTitle("Mineral", displayMode: .large)
            .background(Color.black.opacity(0.00).edgesIgnoringSafeArea(.bottom))
            .onAppear() {
                self.fetchTasks()
            }
        }
            VStack() {
                Spacer()
                Button(action: { self.isPresented = true }) {
                  Image(uiImage: UIImage(named: "BtnSubmit")!)
                    .resizable()
                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                }
                .sheet(isPresented: $isPresented, onDismiss: {
                    self.fetchTasks()
                }) {
                  AddTaskPage()
                }
            }
        }
    }
    
    func fetchTasks() {
        let appDeleggate = UIApplication.shared.delegate as! AppDelegate
        let context = appDeleggate.persistentContainer.viewContext
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDo")
        
        let sort = NSSortDescriptor(key: "date", ascending: false)
        fetchReq.sortDescriptors = [sort]
      
      do {
            let result = try context.fetch(fetchReq)
        
            // trying for group
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-YYYY"
        
            let arraytodos = result as! [ToDo]
            let grouped = Dictionary(grouping: arraytodos, by: { formatter.string(for: $0.date)!  })
            userData.tasks = grouped
        } catch{
            print("Unhandled error.")
        }
    }
    
    func delete(key: String, task: ToDo) {
        let appDeleggate = UIApplication.shared.delegate as! AppDelegate
        let context = appDeleggate.persistentContainer.viewContext
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDo")
        do {
            let result = try context.fetch(fetchReq)
            for obj in result as! [NSManagedObject]{
                if task.objectID == obj.objectID {
                    context.delete(obj)
                    try context.save()
                    fetchTasks()
                }
            }
        } catch {
            // Unhandled.
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
