import Foundation
import CoreData

@objc(Sound)
public class Sound: NSManagedObject {

}


extension Sound {

    @NSManaged public var id: UUID?
    @NSManaged public var timestamp: Date?
    @NSManaged public var dbArray: NSObject?
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Sound> {
        return NSFetchRequest<Sound>(entityName: "Sound")
    }

}

extension Sound : Identifiable {

}
