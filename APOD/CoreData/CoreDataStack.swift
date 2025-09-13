import CoreData
import os.log

final class CoreDataStack {
    static let shared = CoreDataStack()
    private let logger = Logger(subsystem: "com.gustavoramalho.APOD", category: "CoreData")
    let container: NSPersistentContainer
    
    private init() {
        container = NSPersistentContainer(name: "NasaAPODModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Core Data store failed \(error)")
            }
        }
    }
    
    var context: NSManagedObjectContext { container.viewContext }
    
    func saveContext(context: NSManagedObjectContext? = nil) {
        let ctx = context ?? self.context
        if ctx.hasChanges {
            do {
                try ctx.save()
            } catch {
                logger.error("Error saving context: \(error)")
            }
        }
    }
}
