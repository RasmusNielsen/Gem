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
  
  let csvArray = [
      [ "section0-key0": "section0-value0",
        "section0-key1": "section0-value1"],
      [ "section1-key0": "section1-value0",
        "section1-key1": "section1-value1"],
      [ "section2-key0": "hallo-value0",
        "section2-key1": "section2-value1",
        "section2-key2": "jada",
      ]
  ]
  
  struct SectionView : View {
      @State var dict = [String: String]()

      var body: some View {
          let keys = dict.map{$0.key}
          let values = dict.map {$0.value}

          return  ForEach(keys.indices) {index in
              HStack {
                  Text(keys[index])
                  Text("\(values[index])")
              }
          }
      }
  }

    var body: some View {
        NavigationView{
            VStack{
              List {
                ForEach(csvArray, id:\.self) { dict in
                  Section(header: Text("Important tasks")) {
                    SectionView(dict: dict)
                  }
                }
              }
 

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
                
                GeometryReader{ _ in
                    if !self.todayTask.isEmpty {
                        ScrollView(.vertical, showsIndicators: false){
                            VStack {
                                ForEach(0..<self.todayTask.count, id: \.self){ i in
                                    HStack {
                                        Text(self.todayTask[i].task)
                                        Spacer()
                                        Text(self.todayTask[i].date)
                                            .padding(.horizontal)
                                      Button(action: {
                                          self.deleteParticularTask(index: i)
                                      }) {
                                          Image(systemName: "checkmark.circle")
                                              .resizable()
                                              .frame(width: 22, height: 22)
                                              .foregroundColor(.green)
                                              .padding(.trailing,10)
                                      }
                                    }
                                    .padding(.horizontal)
                                    .padding(.top, 20)
                                }
                                .onDelete(perform: self.deleteNumber)
                            }
                        }
                    } else {
                      VStack(){
                      Spacer()
                      HStack(){
                        Spacer()
                        Text("No tasks")
                        Spacer()
                      }
                      Spacer()
                    }
                    }
                    
                }
                
            }
            .environment(\.editMode, self.$editMode)
            .navigationBarTitle("Gem", displayMode: .large)
            .background(Color.black.opacity(0.00).edgesIgnoringSafeArea(.bottom))
            .onAppear(){
                //self.deleteOldTask()
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
            let grouped = Dictionary(grouping: arraytodos, by: { formatter.string(for: $0.date)! })
            
            self.tasks = grouped
            //print (grouped)
            // trying for group
        
//            for obj in result as! [NSManagedObject]{
//                let task = obj.value(forKey: "task") as! String
//                let date = obj.value(forKey: "date") as! Date
//                let formatter = DateFormatter()
//                formatter.dateFormat = "dd-MM-YYYY"
//
//              //if formatter.string(from: date) >= formatter.string(from: Date()){
//                    self.todayTask.append(TaskModel(task: task, date: formatter.string(from: date)))
//              //}
//            }
        }catch{
            print("")
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
