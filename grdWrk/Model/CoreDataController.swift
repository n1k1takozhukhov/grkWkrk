import Foundation
import CoreData

class CoreDataController: ObservableObject{
    let container = NSPersistentContainer(name: "grdWrk")
    
    init(){
        container.loadPersistentStores{ description, error in
            if let error = error {
                print("Core Data failed to create container: \(error.localizedDescription)")
            }
        }
    }
}
