//
//  ViewController.swift
//  MyTodoList
//
//  Created by naratti on 2018/12/07.
//  Copyright © 2018年 naratti. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // var todoList = [String]()
    var todoList = [MyTodo]()
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userDefaults = UserDefaults.standard
        /*if let storedTodoList = userDefaults.array(forKey: "todoList") as? [String] {
            todoList.append(contentsOf: storedTodoList)
        }*/
        
        if let storedTodoList = userDefaults.object(forKey: "todoList") as? Data {
            do {
                if let unarchiveTodoList = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, MyTodo.self], from: storedTodoList) as? [MyTodo] {
                    todoList.append(contentsOf: unarchiveTodoList)
                }
            } catch {
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func tapAddButton(_ sender: Any) {
        let alertController = UIAlertController(title: "ToDo追加", message: "ToDoを入力してくだい", preferredStyle: UIAlertController.Style.alert)
        
        alertController.addTextField(configurationHandler: nil)
        let okAction = UIAlertAction(
            title: "OK",
            style: UIAlertAction.Style.default
        ) { (UIAlertAction) in
            if let textField = alertController.textFields?.first {
                let myTodo = MyTodo()
                myTodo.todoTitle = textField.text!
                
                self.todoList.insert(myTodo, at: 0)
                self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: UITableView.RowAnimation.right)
                
                let userDefaults = UserDefaults.standard
                
                do {
                    let data = try NSKeyedArchiver.archivedData(withRootObject: self.todoList, requiringSecureCoding: true)
                    userDefaults.set(data, forKey: "todoList")
                    userDefaults.synchronize()
                } catch {
                    
                }
                
            }
        }
        
        alertController.addAction(okAction)
        
        let cancelButton = UIAlertAction(title: "CANCEL", style: UIAlertAction.Style.cancel, handler: nil)
        
        alertController.addAction(cancelButton)
        present(alertController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath)
        let myTodo = todoList[indexPath.row]
        
        cell.textLabel?.text = myTodo.todoTitle
        
        if myTodo.todoDone {
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
        } else {
            cell.accessoryType = UITableViewCell.AccessoryType.none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let myTodo = todoList[indexPath.row]
        
        if myTodo.todoDone {
            myTodo.todoDone = false
        } else {
            myTodo.todoDone = true
        }
        
        tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        
        do {
            let data: Data = try NSKeyedArchiver.archivedData(withRootObject: todoList, requiringSecureCoding: true)
            let userDefaults = UserDefaults.standard
            userDefaults.set(data, forKey: "todoList")
            userDefaults.synchronize()
        } catch {
            
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            todoList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            
            do {
                let data: Data = try NSKeyedArchiver.archivedData(withRootObject: todoList, requiringSecureCoding: true)
                let userDefaults = UserDefaults.standard
                
                userDefaults.set(data, forKey: "todoList")
                userDefaults.synchronize()
            } catch {
            }
        }
    }
    
}

class MyTodo: NSObject, NSSecureCoding {
    static var supportsSecureCoding: Bool {
        return true
    }
    
    var todoTitle: String?
    var todoDone: Bool = false
    
    override init() {
    }
    
    required init?(coder aDecoder: NSCoder) {
        todoTitle = aDecoder.decodeObject(forKey: "todoTitle") as? String
        todoDone = aDecoder.decodeBool(forKey: "todoDone")
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(todoTitle, forKey: "todoTitle")
        aCoder.encode(todoDone, forKey: "todoDone")
    }
}


