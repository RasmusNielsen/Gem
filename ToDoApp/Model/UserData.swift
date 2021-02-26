//
//  UserData.swift
//  ToDoApp
//
//  Created by Casper on 26/02/2021.
//

import Foundation
import SwiftUI
import CoreData

class UserData: ObservableObject {
    @Published var tasks: [String : [ToDo]] = [:]
}
