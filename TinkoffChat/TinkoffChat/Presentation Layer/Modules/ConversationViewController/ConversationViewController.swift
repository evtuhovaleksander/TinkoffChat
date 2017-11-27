//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Aleksander Evtuhov on 30/10/2017.
//  Copyright © 2017 Aleksander Evtuhov. All rights reserved.
//

import UIKit
import CoreData

class ConversationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, ConversationViewControllerModelDelegate{

    var model:IConversationViewControllerModel?
    
    @IBOutlet weak var table: UITableView!
    
    @IBOutlet weak var sendButton: UIButton!
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var label:UILabel?
    
    @IBOutlet weak var messageText: UITextField!
    
    
    
    var longTapRecognizer:UILongPressGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.title = model?.userName
        self.table.register(UINib.init(nibName: "IncomeMessageCell", bundle: nil), forCellReuseIdentifier: "IncomeMessageCell")
        self.table.register(UINib.init(nibName: "OutcomeMessageCell", bundle: nil), forCellReuseIdentifier: "OutcomeMessageCell")
        self.table.delegate = self
        self.table.dataSource = self
        
        label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
        label?.text = model?.conversation.user?.name
        label?.textAlignment = .center
        self.navigationItem.titleView = label
        
        longTapRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(anim))
        longTapRecognizer?.minimumPressDuration = 0.37
        self.view.addGestureRecognizer(longTapRecognizer!)
        
        updateOnline()
    }
    
    var animations = [Animator]()
    
    @objc func anim(){
        
        let w = self.view.frame.size.width
        let h = self.view.frame.size.height
        
        let ani = Animator((longTapRecognizer?.location(in: self.view))!, self.view,Int(w),Int(h))
        ani.start()
        sleep(0.5)
        //animations.append(ani)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        model?.startSync()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        model?.updateUnRead()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.numberOfRowsInSection(section: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let message = model?.messageForIndexPath(indexPath: indexPath){
        
        if(message.income){
            let cell = table.dequeueReusableCell(withIdentifier: "IncomeMessageCell", for: indexPath) as! MessageCell
            cell.messageText = message.text
            return cell
            
        }else{
            let cell = table.dequeueReusableCell(withIdentifier: "OutcomeMessageCell", for: indexPath) as! MessageCell
            cell.messageText = message.text
            return cell
            }
            
        }else{
            let cell = table.dequeueReusableCell(withIdentifier: "IncomeMessageCell", for: indexPath) as! MessageCell
            return cell
        }
        
    }
    
    @IBAction func send(_ sender: Any) {
        model?.sendMessage(string: messageText.text ?? "")
    }
    
    var i = 0
    @IBAction func add(_ sender: Any) {
        let cont = rootAssembly.coreDataService.saveContext
        i+=1
        let str = String(i)
        
        var income = false
        
        if(Int(arc4random_uniform(10))>5){
            income = true
        }
        
        let _ = Message.insertMessage(in: cont!, conversation: (model?.conversation)!, text: str, income: income, id: jsonManager.generateMessageID(), date: Date(),unread: true)
        
        rootAssembly.coreDataService.doSave(completionHandler: nil)
    }
    
    
    @IBAction func del(_ sender: Any) {
        let convs = rootAssembly.coreDataService.findMessages()
        for i in convs!{
            rootAssembly.coreDataService.mainContext?.delete(i)
        }
        
        rootAssembly.coreDataService.doSave(completionHandler: nil)
        
        
    }
    
    
    
    
    
    @IBAction func on(_ sender: Any) {
        if oldOnline == nil{
            oldOnline = false
        }
        let online = !oldOnline!
        DispatchQueue.main.async {
            
            if self.oldOnline == nil{
                self.oldOnline = online
            } else{
                if(self.oldOnline == online) {return}
            }
            self.setButtonOnline(online)
            self.setLabelOnline(online)
            self.oldOnline = online
        }
    }
    
    
    func updateOnline(){
       //sendButton.isEnabled = model?.conversation.user?.online ?? false
        
        DispatchQueue.main.async {
            let online = self.model?.conversation.user?.online ?? false
            if self.oldOnline == nil{
                self.oldOnline = online
            } else{
                if(self.oldOnline == online) {return}
            }
            self.setButtonOnline(online)
            self.setLabelOnline(online)
            self.oldOnline = online
        }
        
    }
    
    var oldOnline:Bool? = nil
    
    func setButtonOnline(_ online:Bool){
        
//        if oldOnline == nil{
//            oldOnline = online
//        } else{
//            if(oldOnline == online) {return}
//        }
//
//
        var color = UIColor.green
        var duration = 0.5
        if(online){
            color = .green
        }else{
            color = .gray
        }
        
        let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        scaleAnimation.values = [1,1.15,1]
        scaleAnimation.duration = duration
        
        let colorAnimation = CABasicAnimation(keyPath: "backgroundColor")
        colorAnimation.fromValue = sendButton.backgroundColor
        colorAnimation.toValue = color
        colorAnimation.duration = duration
        
        
        var group = CAAnimationGroup()
        group.animations = [scaleAnimation,colorAnimation]
        group.duration = duration
        
        sendButton.layer.add(group, forKey: "groupAnimation")
        sendButton.backgroundColor = color
        sendButton.isEnabled = online
//        oldOnline = online
    }
    
    func setLabelOnline(_ online:Bool){
        var color = UIColor.green
        var targetscale = 1.0
        var basescale = 1.0
        
        
        var duration = 1.0
        if(online){
            color = .green
            targetscale = 1.5
            basescale = 1.0
        }else{
            color = .black
            targetscale = 1.0
            basescale = 1.5
        }
        
        
        UIView.transition(with: label!, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.label?.textColor = color
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5) {
            self.label?.transform = CGAffineTransform(scaleX: CGFloat(targetscale), y: CGFloat(targetscale))
        }
    }
        
        
        
        //        UIView.transition(with: self.l, duration: duration, options: .transitionCrossDissolve, animations: {
        //            self.l.textColor = color
        //            //self.l.transform = CGAffineTransform(scaleX: CGFloat(targetscale), y: CGFloat(targetscale))
        //        }, completion: nil)
        
        
        
//        let scaleAnimation = CABasicAnimation( keyPath: "transform.scale" )
//        scaleAnimation.fromValue = basescale
//        scaleAnimation.toValue = targetscale
//        scaleAnimation.duration = duration
//        self.label?.layer.transform.scale = targetscale
//
//        let colorAnimation = CABasicAnimation(keyPath: "foregroundColor")
//        //colorAnimation.fromValue = self.textLaye
//        colorAnimation.toValue = color
//        colorAnimation.duration = duration
//        colorAnimation.fillMode = kCAFillModeForwards;
//        colorAnimation.isRemovedOnCompletion = false;
//        colorAnimation.fromValue = UIColor.gray
//        colorAnimation.toValue = color
//
//
//        var group = CAAnimationGroup()
//        group.animations = [scaleAnimation,colorAnimation]
//        group.duration = duration
//
//        label?.layer.add(group, forKey: "groupAnimation")
        //self.label?.layer.transform = //CATransform3D(scaleX: CGFloat(targetscale), y: CGFloat(targetscale))
        
        
    }
    


extension ConversationViewController:NSFetchedResultsControllerDelegate{
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        table.endUpdates()
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        table.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch (type) {
        case .insert:
            table.insertSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .fade)
            break
        case .delete:
            table.deleteSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .fade)
            break
        default:
            break
        }
    }
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            if let indexPath = indexPath {
                table.deleteRows(at: [indexPath], with: .automatic)
            }
        case .insert:
            if let newIndexPath = newIndexPath {
                table.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .move:
            if let indexPath = indexPath {
                table.deleteRows(at: [indexPath], with: .automatic)
            }
            
            if let newIndexPath = newIndexPath {
                table.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                table.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    
}





