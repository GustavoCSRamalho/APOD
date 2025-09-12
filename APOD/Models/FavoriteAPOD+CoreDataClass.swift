import CoreData

@objc(FavoriteAPOD)
public class FavoriteAPOD: NSManagedObject {}

extension FavoriteAPOD {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteAPOD> {
        return NSFetchRequest<FavoriteAPOD>(entityName: "FavoriteAPOD")
    }

    @NSManaged public var date: String?
    @NSManaged public var title: String?
    @NSManaged public var explanation: String?
    @NSManaged public var url: String?
    @NSManaged public var hdurl: String?
    @NSManaged public var service_version: String?
    @NSManaged public var media_type: String?
}
