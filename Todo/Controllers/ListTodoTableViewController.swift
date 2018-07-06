//
//  ListNotesTableViewController.swift
//  MakeSchoolNotes
//
//  Created by Chris Orcutt on 1/10/16.
//  Copyright © 2016 MakeSchool. All rights reserved.
//

import UIKit

class ListTodoTableViewController: UITableViewController {
    
    var todos = [Todo]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var doneTodos = [Todo]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todos = CoreDataHelper.retrieveTodos(completed: false)
        doneTodos = CoreDataHelper.retrieveTodos(completed: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            switch indexPath.section {
            case 0:
                CoreDataHelper.deleteTodo(todos[indexPath.row])
                todos = CoreDataHelper.retrieveTodos(completed: false)
            case 1:
                CoreDataHelper.deleteTodo(doneTodos[indexPath.row])
                doneTodos = CoreDataHelper.retrieveTodos(completed: true)
            default:
                print("what?")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "still need to complete"
        case 1:
            return "completed"
        default:
            return ""
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return todos.count
        case 1:
            return doneTodos.count
        default:
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listTodoTableViewCell", for: indexPath) as! ListTodoTableViewCell
        
        switch indexPath.section {
        case 0:
            let todo = todos[indexPath.row]
        
            cell.onButtonTouched = {
                (cell) in guard let indexPath = tableView.indexPath(for: cell) else { return }
                let todo = self.todos[indexPath.row]
                if todo.completed == false {
                    todo.completed = true
                    self.doneTodos.append(todo)
                    self.todos.remove(at:indexPath.row)
                    CoreDataHelper.saveTodo()
                }
            }
        
            cell.todoDescriptionLabel.text = todo.content
            cell.todoTitleLabel.text = todo.title
            cell.todoTimeStampLabel.text = todo.modificationTime?.convertToString() ?? "unknown"
            return cell
            
        case 1:
            let completedTodo = doneTodos[indexPath.row]
            
            cell.todoDescriptionLabel.text = completedTodo.content
            cell.todoTitleLabel.text = completedTodo.title
            cell.todoTimeStampLabel.text = completedTodo.modificationTime?.convertToString() ?? "unknown"
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    @IBAction func unwindWithSegue(_ segue: UIStoryboardSegue) {
        todos = CoreDataHelper.retrieveTodos(completed: false)
        doneTodos = CoreDataHelper.retrieveTodos(completed: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        switch identifier {
        case "displayTodo":
            
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            switch indexPath.section {
            case 0:
                let todo = todos[indexPath.row]
                let destination = segue.destination as! DisplayTodoViewController
                destination.todo = todo
            
            case 1:
                let completedTodo = doneTodos[indexPath.row]
                let destination = segue.destination as! DisplayTodoViewController
                destination.todo = completedTodo
            default:
                break
            }
        case "addTodo":
            print("Add Todo")
        default:
            break
        }
    }
}
