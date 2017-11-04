//
//  Coordinator.swift
//  TinkoffChat
//
//  Created by Aleksander Evtuhov on 04/11/2017.
//  Copyright © 2017 Aleksander Evtuhov. All rights reserved.
//

import UIKit
import CoreData

class CoreDataService : ProfileManagerCoreServiceProtocol{
    
    func getProfile() {
        
    }
    
    func saveProfile() {
        <#code#>
    }
    
    
    var profileManagerDelegate:ProfileManagerCoreServiceProtocolDelegate?
    
    init() {
        //print(self.storeURL)
        //print(self.managedObjectModel)
        //print(self.persistentStoreCoordinator)
        //print(self.masterContext)
        //print(self.mainContext)
        //print(self.saveContext)
    }
    
//    public var contextSave : NSManagedObjectContext?{
//        get{
//            return saveContext
//        }
//    }
    
    private var storeURL : URL {
        get{
            let documentsDirURL : URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let url = documentsDirURL.appendingPathComponent("Store.sqlite")
            return url
        }
    }
    
    private let managedObjectModelName = "Storage"
    private var _managedObjectModel : NSManagedObjectModel?
    private var managedObjectModel : NSManagedObjectModel? {
        get{
            if _managedObjectModel == nil{
                guard let modelURL = Bundle.main.url(forResource: managedObjectModelName, withExtension : "momd") else{
                    return nil
                }
                
                
                _managedObjectModel = NSManagedObjectModel(contentsOf:modelURL)
            }
            
            return _managedObjectModel
        }
    }
    
    
    private var _persistentStoreCoordinator : NSPersistentStoreCoordinator?
    private var persistentStoreCoordinator : NSPersistentStoreCoordinator?{
        get {
            if _persistentStoreCoordinator == nil{
                guard let model = self.managedObjectModel else{
                    print("empty man obj model")
                    return nil
                }
                
                _persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
                
                do{
                    try _persistentStoreCoordinator?.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
                }catch{
                    assert(false, "er ad pers store to cord \(error)")
                }
            }
            
            return _persistentStoreCoordinator
        }
    }
    
    
    private var _masterContext : NSManagedObjectContext?
    private var masterContext : NSManagedObjectContext?{
        get{
            if _masterContext == nil{
                let context = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
                guard let persistedStoreCoordinator  = self.persistentStoreCoordinator else{
                    print("empty store coord")
                    return nil
                }
                
                context.persistentStoreCoordinator = persistedStoreCoordinator
                context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
                context.undoManager = nil
                _masterContext = context
            }
            
            return _masterContext
        }
    }
    
    private var _mainContext : NSManagedObjectContext?
    private var mainContext : NSManagedObjectContext?{
        get{
            if _mainContext == nil{
                let context = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
                guard let parentContext  = self.masterContext else{
                    print("no master cont")
                    return nil
                }
                
                context.parent = parentContext
                context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
                context.undoManager = nil
                _mainContext = context
            }
            
            return _mainContext
        }
    }
    
    private var _saveContext : NSManagedObjectContext?
    private var saveContext : NSManagedObjectContext?{
        get{
            if _saveContext == nil{
                let context = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
                guard let parentContext  = self.mainContext else{
                    print("no master cont")
                    return nil
                }
                
                context.parent = parentContext
                context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
                context.undoManager = nil
                _saveContext = context
            }
            
            return _saveContext
        }
    }
    
    
    public func performSave(context: NSManagedObjectContext,completionHandler : (()->Void)?){
        
        //if context.hasChanges {
        if true {
            context.perform { [weak self] in
                do{
                    try context.save()
                }catch{
                    print(error)
                }
                
                if let parent = context.parent {
                    self?.performSave(context: parent, completionHandler: completionHandler)
                }else{
                    completionHandler?()
                }
                
            }
        }else{
            completionHandler?()
        }
    }
    
    public func doSave(completionHandler : (()->Void)?){
        performSave(context: saveContext!, completionHandler: completionHandler)
    }
    
    static func findOrInsertAppUser(in context: NSManagedObjectContext) -> AppUser?{
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else{
            print("model ")
            assert(false)
            return nil
            
        }
        
        var appUser : AppUser?
        
        guard  let fetchRequest = AppUser.fetchRequestAppUser(model:model) else {
            return nil
        }
        
        do{
            let results = try context.fetch(fetchRequest)
            assert(results.count < 2,"multip appusers")
            if let foundUser = results.first{
                appUser = foundUser
            }
        }catch{
            print(error)
        }
        
        if appUser == nil {
            appUser = AppUser.insertAppUser(in: context)
        }
        
        return appUser
    }
    
    func findOrInsertAppUser() -> AppUser?{
        guard let context = self.mainContext else{
            assert(false)
            return nil
        }
        
        
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else{
            print("model ")
            assert(false)
            return nil
            
        }
        
        var appUser : AppUser?
        
        guard  let fetchRequest = AppUser.fetchRequestAppUser(model:model) else {
            return nil
        }
        
        do{
            let results = try context.fetch(fetchRequest)
            assert(results.count < 2,"multip appusers")
            if let foundUser = results.first{
                return foundUser
            }
        }catch{
            print(error)
        }
        
        if appUser == nil {
            appUser = AppUser.insertAppUser(in: context)
            self.doSave(completionHandler: nil)
        }
        
        return appUser
    }
    

}

extension AppUser{
    
    static func insertAppUser(in context:NSManagedObjectContext)->AppUser?{
        if let appUser = NSEntityDescription.insertNewObject(forEntityName: "AppUser", into: context) as? AppUser{
            if appUser.profile == nil {
                if let profile = NSEntityDescription.insertNewObject(forEntityName: "CoreProfile", into: context) as? CoreProfile{
                    profile.avatar = ImageEnCoder.imageToBase64ImageString(image: UIImage.init(named: "EmptyAvatar") ?? UIImage())
                    profile.name = "name"
                    profile.info = "info"
                    appUser.profile = profile
                }
            }
            return appUser
        }
        
        return nil
    }
    
    static func fetchRequestAppUser(model:NSManagedObjectModel) -> NSFetchRequest<AppUser>?{
        
        let templateName = "AppUser"
        
        guard let fetchRequest = model.fetchRequestTemplate(forName: templateName) as? NSFetchRequest<AppUser> else {
            assert(false,"")
            return nil
        }
        
        return fetchRequest
    }
}



