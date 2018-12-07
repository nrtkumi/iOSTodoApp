//
//  ViewController.swift
//  MyTodoList
//
//  Created by naratti on 2018/12/07.
//  Copyright © 2018年 naratti. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var todoList = [String]()
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userDefaults = UserDefaults.standard
        if let storedTodoList = userDefaults.array(forKey: "todoList") as? [String] {
            todoList.append(contentsOf: storedTodoList)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func tapAddButton(_ sender: Any) {
        let alertController = UIAlertController(title: "ToDo追加", message: "ToDoを入力してくだい", preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addTextField(configurationHandler: nil)
        let okAction = UIAlertAction(
            title: "OK",
            style: UIAlertActionStyle.default
        ) { (UIAlertAction) in
            if let textField = alertController.textFields?.first {
                self.todoList.insert(textField.text!, at: 0)
                self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: UITableViewRowAnimation.right)
                
                let userDefaults = UserDefaults.standard
                userDefaults.set(self.todoList, forKey: "todoList")
                userDefaults.synchronize()
            }
        }
        
        alertController.addAction(okAction)
        
        let cancelButton = UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.cancel, handler: nil)
        
        alertController.addAction(cancelButton)
        present(alertController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath)
        let todoTitle = todoList[indexPath.row]
        
        cell.textLabel?.text = todoTitle
        
        return cell
    }
    
}

