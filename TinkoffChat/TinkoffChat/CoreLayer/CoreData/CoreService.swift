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
        mainContext?.perform {
            guard let appUser = self.findOrInsertAppUser() else {
                self.profileManagerDelegate?.recievedProfile(profile: nil)
                return
            }
            
            if let coreProfile =  appUser.profile {
                self.profileManagerDelegate?.recievedProfile(profile: coreProfile)
            }else{
                self.profileManagerDelegate?.recievedProfile(profile: nil)
            }
            
        }
        
    }
    
    func saveProfile() {
        doSave(completionHandler: nil)
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
    var masterContext : NSManagedObjectContext?{
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
    var mainContext : NSManagedObjectContext?{
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
    var saveContext : NSManagedObjectContext?{
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
    
    func findConversation(id:String) -> Conversation?{
        guard let context = self.mainContext else{
            assert(false)
            return nil
        }
        
        
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else{
            print("model ")
            assert(false)
            return nil
            
        }
        
        guard  let fetchRequest = Conversation.fetchRequestConversationByID(model:model,id:id) else {
            return nil
        }
        
        do{
            let results = try context.fetch(fetchRequest)
            assert(results.count < 2,"multip convs for 1 id")
            if let conversation = results.first{
                return conversation
            }
        }catch{
            print(error)
        }
        return nil
    }
    
    func findConversations() -> [Conversation]?{
        guard let context = self.mainContext else{
            assert(false)
            return nil
        }
        
        
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else{
            print("model ")
            assert(false)
            return nil
            
        }
        
        guard  let fetchRequest = Conversation.fetchRequestConversation(model:model) else {
            return nil
        }
        
        do{
            let results = try context.fetch(fetchRequest)
            return results
        }catch{
            print(error)
        }
        return nil
    }
    
    func findMessages() -> [Message]?{
        guard let context = self.mainContext else{
            assert(false)
            return nil
        }
        
        
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else{
            print("model ")
            assert(false)
            return nil
            
        }
        
        guard  let fetchRequest = Message.fetchRequestMessages(model: model) else {
            return nil
        }
        
        do{
            let results = try context.fetch(fetchRequest)
            return results
        }catch{
            print(error)
        }
        return nil
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

extension User {
    
    static func insertUser(in context:NSManagedObjectContext,conversation : Conversation, name: String, online: Bool) -> User?{
        if let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as? User{
            user.online = online
            user.name = name
            user.conversation = conversation
            return user
        }
        
        return nil
    }
}

extension Message {
    
    static func insertMessage(in context:NSManagedObjectContext,conversation : Conversation, text: String, income: Bool,id:String,date:Date,unread:Bool) -> Message?{
        if let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as? Message{
            message.id = id
            message.conversation = conversation
            message.text = text
            message.income = income
            message.unread = unread
            message.date = date
            return message
        }
        
        return nil
    }
    
    
    static func fetchRequestMessages(model:NSManagedObjectModel) -> NSFetchRequest<Message>?{
        
        let templateName = "Message"
        
        guard let fetchRequest = model.fetchRequestTemplate(forName: templateName) as? NSFetchRequest<Message> else {
            assert(false,"")
            return nil
        }
        return fetchRequest
    }
    
    static func fetchRequestMessages(context:NSManagedObjectContext,conversation:Conversation) -> NSFetchRequest<Message>?{
        
        let fetchRequest = NSFetchRequest<Message>(entityName: "Message")
        
        let predicate = NSPredicate(format: "conversation == %@", conversation)
        fetchRequest.predicate = predicate
        
        let descriptors = [NSSortDescriptor(key: "date",
                                            ascending: true)]
        fetchRequest.sortDescriptors = descriptors
        
        return fetchRequest
    }
}

extension Conversation{
    
    static func insertConversation(in context:NSManagedObjectContext,id:String,name:String,online:Bool)->Conversation?{
        if let conversation = NSEntityDescription.insertNewObject(forEntityName: "Conversation", into: context) as? Conversation{
            conversation.id = id
            
            if let user = User.insertUser(in: context, conversation: conversation, name: name, online: online){
                conversation.user = user
                conversation.hasUnread = false
            }else{
                assert(false)
            }
            
            return conversation
        }
        
        return nil
    }
    
    static func fetchRequestConversationByID(model:NSManagedObjectModel,id:String) -> NSFetchRequest<Conversation>?{
        
        let templateName = "Conversation"
        
        guard let fetchRequest = model.fetchRequestTemplate(forName: templateName) as? NSFetchRequest<Conversation> else {
            assert(false,"")
           return nil
        }
        let predicate = NSPredicate(format: "id == %@", id)
        fetchRequest.predicate = predicate
        return fetchRequest
    }
    
    static func fetchRequestConversation(model:NSManagedObjectModel) -> NSFetchRequest<Conversation>?{
        
        let templateName = "Conversation"
        
        guard let fetchRequest = model.fetchRequestTemplate(forName: templateName) as? NSFetchRequest<Conversation> else {
            assert(false,"")
            return nil
        }
        return fetchRequest
    }
    
}



