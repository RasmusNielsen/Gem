//
//  SettingsViewModel.swift
//  ToDoApp
//
//  Created by Rasmus Nielsen on 17/01/2021.
//

import SwiftUI
import Foundation
import UserNotifications

func permissionNotifications(){
  print ("Asking for permission")
  UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
    if success {
      print("All set!")
    } else if let error = error {
      print(error.localizedDescription)
    }
  }
}

func removeNotifications(){
  print ("Disabling notifications")
  UIApplication.shared.unregisterForRemoteNotifications()
  UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
}

func scheduleNotifications(notificationHours: Int, notificationMinutes: Int){
  print ("Disabling notifications")
  let content = UNMutableNotificationContent()
  content.title = "Feed the cat"
  content.subtitle = "It looks hungry"
  content.sound = UNNotificationSound.default

  var dateComponents = DateComponents()
  dateComponents.hour = notificationHours
  dateComponents.minute = notificationMinutes
  dateComponents.timeZone = .current

  let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
  print(trigger.nextTriggerDate() ?? "nil")
  let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
  UNUserNotificationCenter.current().add(request)
}

func DoNotification(){
  removeNotifications()
  permissionNotifications()
  scheduleNotifications(notificationHours: 14, notificationMinutes: 25)
}

class SettingsViewModel: ObservableObject {

  @Published var isOn: Bool = UserDefaults.standard.bool(forKey: "isOn"){
    didSet {
      UserDefaults.standard.set(self.isOn, forKey: "isOn")
      if (self.isOn == true){
        
        let convhour = Calendar.current.component(.hour, from: self.NotificationTime)
        let convminute = Calendar.current.component(.minute, from: self.NotificationTime)
        removeNotifications()
        permissionNotifications()
        scheduleNotifications(notificationHours: convhour, notificationMinutes: convminute)
        
      } else {
        removeNotifications()
      }
      
    }
  }
  
  @Published var NotificationTime: Date = UserDefaults.standard.object(forKey: "NotificationTime") as? Date ?? Date()  {
    didSet {

      let convhour = Calendar.current.component(.hour, from: self.NotificationTime)
      let convminute = Calendar.current.component(.minute, from: self.NotificationTime)
      
      if (self.isOn == true){
        removeNotifications()
        permissionNotifications()
        scheduleNotifications(notificationHours: convhour, notificationMinutes: convminute)
      }
      
      UserDefaults.standard.set(self.NotificationTime, forKey: "NotificationTime")
    }
  }

}

