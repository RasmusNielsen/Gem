//
//  SettingsView.swift
//  ToDoApp
//
//  Created by Rasmus Nielsen on 13/01/2021.
//

 
import SwiftUI
import CoreData

struct Home: View {
    @State var todayTask : [TaskModel] = []
    @State var tasks: [String : [ToDo]] = [:]
    @State var editMode = EditMode.inactive
  
    @State var isPresented = false
    @State var isSettingsPresented = false
  
    struct SectionView : View {
    @State var tasks = [ToDo]()
        
    var body: some View {
        return ForEach(tasks) { task in
            HStack {
                Text(task.value(forKey: "task") as! String)
                Spacer()
                Text("Remove")
            }
        }
      }
  }
    
    var body: some View {
        NavigationView{
            VStack {
                List {
                    ForEach(tasks.keys.sorted(by: >), id:\.self) { key in
                      let tasks = self.tasks[key]!
                      Section(header: Text(key)) {
                        SectionView(tasks: tasks)
                      }
                    }
                }.listStyle(GroupedListStyle())

                VStack {
                  Button(action: { self.isPresented = true }) {Text("Add a gem")}
                  .sheet(isPresented: $isPresented, onDismiss: {fetchList()}) {
                    AddTaskPage()
                  }
                  
                  Button(action: { self.isSettingsPresented = true }) {Text("Settings")}
                  .sheet(isPresented: $isSettingsPresented, onDismiss: {fetchList()}) {
                    SettingsView()
                  }
                  
                }
                
            }
            .environment(\.editMode, self.$editMode)
            .navigationBarTitle("Mineral", displayMode: .large)
            .background(Color.black.opacity(0.00).edgesIgnoringSafeArea(.bottom))
            .onAppear(){
                self.fetchList()
            }
        }
    }
    
    func fetchList(){
        let appDeleggate = UIApplication.shared.delegate as! AppDelegate
        let context = appDeleggate.persistentContainer.viewContext
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDo")
        
        let sort = NSSortDescriptor(key: "date", ascending: false)
        fetchReq.sortDescriptors = [sort]
      
      do {
            self.todayTask.removeAll()
            let result = try context.fetch(fetchReq)
        
            // trying for group
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-YYYY"
        
            let arraytodos = result as! [ToDo]
            let grouped = Dictionary(grouping: arraytodos, by: { formatter.string(for: $0.date)!  })
            self.tasks = grouped
        } catch{
            print("Unhandled error.")
        }
    }
    
    func deleteOldTask(){
        let appDeleggate = UIApplication.shared.delegate as! AppDelegate
        let context = appDeleggate.persistentContainer.viewContext
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDo")
        do {
            let result = try context.fetch(fetchReq)
            for obj in result as! [NSManagedObject]{
                let date = obj.value(forKey: "date") as! Date
                let formatter = DateFormatter()
                formatter.dateFormat = "dd-MM-YYYY"
                if formatter.string(from: date) < formatter.string(from: Date()){
                    context.delete(obj)
                    try context.save()
                }
            }
        }catch{
            print("")
        }
    }
    
    func deleteNumber(at offsets: IndexSet) {
        let appDeleggate = UIApplication.shared.delegate as! AppDelegate
        let context = appDeleggate.persistentContainer.viewContext
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDo")
        do {
            let result = try context.fetch(fetchReq)
            for obj in result as! [NSManagedObject]{
                let currentObject = obj.value(forKey: "task") as! String
                if self.todayTask[offsets[offsets.startIndex]].task == currentObject {
                    context.delete(obj)
                    try context.save()
                    self.todayTask.remove(atOffsets: offsets)
                    return
                    
                }
            }
        }catch{
            print("")
        }
    }
    func deleteParticularTask(index: Int){
        let appDeleggate = UIApplication.shared.delegate as! AppDelegate
        let context = appDeleggate.persistentContainer.viewContext
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDo")
        do {
            let result = try context.fetch(fetchReq)
            for obj in result as! [NSManagedObject]{
                let currentObject = obj.value(forKey: "task") as! String
                if self.todayTask[index].task == currentObject {
                    context.delete(obj)
                    try context.save()
                    self.todayTask.remove(at: index)
                    return
                    
                }
            }
        }catch{
            print("")
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
