//
//  SettingsView.swift
//  ToDoApp
//
//  Created by Rasmus Nielsen on 13/01/2021.
//

import SwiftUI
import UserNotifications

func getRegisteredPushNotifications() {
  let center = UNUserNotificationCenter.current()
  center.getPendingNotificationRequests(completionHandler: { requests in
      for request in requests {
          print(request)
      }
  })
}


struct SettingsView: View {
  @ObservedObject var settingsVM = SettingsViewModel();
  @State private var timeofDay = Date()
  @State var notificationsOn = false
    
  var body: some View {
      List {
        Button("Pending"){getRegisteredPushNotifications()}
        Section(header: Text("Notificiations")) {
        Toggle(isOn: self.$settingsVM.isOn) {Text("Activate") }
        DatePicker("Time of day", selection: self.$settingsVM.NotificationTime, displayedComponents: .hourAndMinute)
        }
      }
      .listStyle(InsetGroupedListStyle())
  }

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
}
