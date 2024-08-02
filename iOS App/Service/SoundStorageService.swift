import Foundation
import CoreData

final class SoundStorageService {
    
    static let shared = SoundStorageService()
    
    private let context = PersistenceController.shared.container.viewContext
    
    public func createNewData(model: SoundModel, completion: @escaping (Bool) -> ()) {
        let newArray = Sound(context: context)
        
        newArray.id = model.id
        newArray.timestamp = model.date
        newArray.dbArray = model.dbArray as NSObject
        
        do {
            try context.save()
            completion(true)
        } catch {
            print(error.localizedDescription)
            completion(false)
        }
    }
    
    public func fetchData(completion: @escaping (([SoundModel]) -> ())) {
        let fetchRequest: NSFetchRequest<Sound> = Sound.fetchRequest()
        
        var result: [SoundModel] = []
        
        do {
           let fetchedData = try context.fetch(fetchRequest)
            
            fetchedData.forEach({ data in
                let array = (data.dbArray as? [Int] ?? [])
                let newData: SoundModel = .init(
                    id: data.id!,
                    date: data.timestamp!,
                    dbArray: array)
                result.append(newData)
            })
            completion(result)
        } catch {
            print(error.localizedDescription)
            completion(result)
        }

    }
    
    public func clearAllData(completion: @escaping (Bool) -> ()) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Sound.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
            completion(true)
        } catch {
            print(error.localizedDescription)
            completion(false)
        }
    }
    
}

