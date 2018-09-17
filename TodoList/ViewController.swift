//
//  ViewController.swift
//  TodoList
//
//  Created by Celal on 2018-09-16.
//  Copyright © 2018 Celal. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "Cell")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 1
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Task")
        
        // 3
        do {
            taskList = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func save(name: String) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "Task",
                                       in: managedContext)!
        let task = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        // 3
        task.setValue(name, forKeyPath: "title")
        // 4
        do {
            try managedContext.save()
            taskList.append(task)
        } catch let error as NSError {
            print ("Could not save. \(error), \(error.userInfo)")
        }
    }

    @IBAction func addTask(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New Task",
                                      message: "Add a new task",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) {
                                        [unowned self] action in
                                        
                                        guard let textField = alert.textFields?.first,
                                            let nameToSave = textField.text else {
                                                return
                                        }
                                        
                                        self.save(name: nameToSave)
                                        self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    var taskList: [NSManagedObject] = []
    
    
  
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return taskList.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            let cell =
                tableView.dequeueReusableCell(withIdentifier: "Cell",
                                              for: indexPath)
            if indexPath.row < taskList.count
            {
                let task = taskList[indexPath.row]
            cell.textLabel?.text = task.value(forKeyPath: "title") as? String
                
//                let accessory: UITableViewCellAccessoryType = item.isCompleted ? .checkmark : .none
//                cell.accessoryType = accessory
            }
            return cell
    }
            func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
            {
                if indexPath.row < taskList.count
                {
//                    guard let appDelegate =
//                        UIApplication.shared.delegate as? AppDelegate else {
//                            return
//                    }
//                    let managedContext =
//                        appDelegate.persistentContainer.viewContext
                    
//                    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "title") /*as! NSManagedObject*/
//                    
//                    managedContext.delete(fetchRequest)
                    
                    taskList.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .top)
//                                do {
//                                    try managedContext.save()
//                                    tableView.deleteRows(at: [indexPath], with: .automatic)
//                                } catch let error as NSError {
//                                    print("Saving error: \(error), description: \(error.userInfo)")
//                                }
                    
                }
            }
            //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
            //    {
            //        tableView.deselectRow(at: indexPath, animated: true)
            //
            //        if indexPath.row < taskList.count
            //        {
            //            let item = taskList[indexPath.row]
            //            item.isCompleted = !item.isCompleted
            //
            //            tableView.reloadRows(at: [indexPath], with: .automatic)
            //        }
            //    }

}

