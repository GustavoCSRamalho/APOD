import CoreData

final class CoreDataStack {
    static let shared = CoreDataStack()
    
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
    
    func saveContext() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Core Data save failed: \(error)")
            }
        }
    }
}
