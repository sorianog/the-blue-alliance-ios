import CoreData
import Foundation

extension NSPersistentContainer {

    func deleteAllEntities() {
        let entitesByName = managedObjectModel.entitiesByName
        for (name, _) in entitesByName {
            deleteAllObjects(entityName: name)
        }
    }

    func deleteAllObjects(entityName: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        deleteRequest.resultType = .resultTypeObjectIDs
        let result = try! persistentStoreCoordinator.execute(deleteRequest, with: viewContext) as? NSBatchDeleteResult
        let objectIDArray = result?.result as? [NSManagedObjectID] ?? []
        let changes = [NSDeletedObjectsKey: objectIDArray]
        NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [viewContext])
    }

}
