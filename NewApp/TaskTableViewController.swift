//
//  TaskTableViewController.swift
//  NewApp
//
//  Created by Thomas on 03/01/2017.
//  Copyright © 2017 Thomas. All rights reserved.
//

import UIKit
import MapKit
import os.log

class TaskTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //Properties
    
    var tasks = [Task]()
    var sortingPickerData : [String] = [String]()
    
    @IBOutlet weak var sortingPicker: UIPickerView!
    
    
    @IBAction func unwindToTaskList(sender : UIStoryboardSegue){
        if let sourceViewController = sender.source as? TaskViewController, let task = sourceViewController.task {
            if let selectedIndex = tableView.indexPathForSelectedRow {
                tasks[selectedIndex.row] = task
                tableView.reloadRows(at: [selectedIndex], with: .none)
            }
            else{
            let newIndexPath = IndexPath(row: tasks.count, section: 0)
            tasks.append(task)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            saveTasks()
        }
        sortArray(by: "Sort by name")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        
        self.sortingPicker.delegate = self
        self.sortingPicker.dataSource = self
        
        sortingPickerData = ["Sort by name", "Sort by date", "Sort by importance", "Sort by location"]
        
        if let savedTasks = loadTasks() {
            tasks += savedTasks
        }
        else{
            loadSampleData()
        }

        sortArray(by: "Sort by name")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
            return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return tasks.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as! TaskTableViewCell
        let task =  tasks[indexPath.row]
        cell.contentView.layer.borderColor = UIColor.lightGray.cgColor
        cell.contentView.layer.borderWidth = 1
        cell.nameLabel.text = task.name.capitalized
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        let dateString = formatter.string(from: task.date)
        cell.dateLabel.text = dateString
        cell.importanceLabel.text = task.importance.description
        cell.locationLabel.text = HelperMethods.parseAddress(selectedItem: task.location!)
    
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
                return true
    }
 
    

    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            tasks.remove(at: indexPath.row)
            saveTasks()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
        }
    }
    

    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let movedObject = self.tasks[fromIndexPath.row]
        tasks.remove(at: fromIndexPath.row)
        tasks.insert(movedObject, at: to.row)
        
    }
    

    // MARK: - Navigation

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
            case "AddTask":
                os_log("Adding task", log: OSLog.default, type : .debug)
            case "ShowDetail":
            let taskDetailViewController = segue.destination as! TaskViewController
            let selectedTaskCell = sender as! TaskTableViewCell
            let indexPath = tableView.indexPath(for: selectedTaskCell)!
            let selectedTask = tasks[indexPath.row]
            taskDetailViewController.task = selectedTask
        default : fatalError("Wrong segue identifier")
        }
    }
    
    
    private func loadSampleData() {
        let task1 = Task(name : "Test1", date : NSDate() as Date, importance : 6, location : MKPlacemark.init(coordinate: CLLocationCoordinate2D.init(latitude: 13.04016, longitude: 80.243044)))!
        let task2 = Task(name : "Test2", date : NSDate() as Date, importance : 8, location : MKPlacemark.init(coordinate: CLLocationCoordinate2D.init(latitude: 13.04016, longitude: 80.243044)))!
        let task3 = Task(name : "Test3", date : NSDate() as Date, importance : 5, location : MKPlacemark.init(coordinate: CLLocationCoordinate2D.init(latitude: 13.04016, longitude: 80.243044)))!
        print("loading data")
        tasks += [task1, task2, task3]
    }
    
    private func saveTasks() {
        let isSuccess = NSKeyedArchiver.archiveRootObject(tasks, toFile: Task.ArchiveURL.path)
        if isSuccess {
            os_log("Save successful", log: OSLog.default, type : .debug)
        }
        else{
            os_log("Save failed", log : OSLog.default, type : .error)
        }
    }
    
    private func loadTasks() -> [Task]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile : Task.ArchiveURL.path) as? [Task]
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sortingPickerData[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sortingPickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        sortArray(by: sortingPickerData[row])
        
        
    }
    
    private func sortArray(by : String) {
        switch by {
        case "Sort by name":
            tasks = tasks.sorted(by: { (task1, task2) -> Bool in
                return task1.name.localizedStandardCompare(task2.name) == .orderedAscending
            })
            self.tableView.reloadData()
        case "Sort by date":
            tasks.sort(by: { (task1, task2) -> Bool in
                return task1.date < task2.date
            })
            self.tableView.reloadData()
        case "Sort by importance" :
            tasks.sort(by: { (task1, task2) -> Bool in
                return task1.importance > task2.importance
            })
            self.tableView.reloadData()
        case "Sort by location" :
            tasks.sort(by: { (task1, task2) -> Bool in
                return HelperMethods.parseAddress(selectedItem: task1.location!).localizedStandardCompare(HelperMethods.parseAddress(selectedItem: task2.location!)) == .orderedAscending})
            self.tableView.reloadData()
        default:
            tasks.sort(by: { (task1, task2) -> Bool in
                return task1.name < task2.name
            })
            self.tableView.reloadData()
        }
    }
    
}
