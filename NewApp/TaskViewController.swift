//
//  ViewController.swift
//  NewApp
//
//  Created by Thomas on 02/01/2017.
//  Copyright © 2017 Thomas. All rights reserved.
//

import UIKit
import MapKit
import os.log

class TaskViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate{
    
    //Properties
    @IBOutlet weak var nameTxf: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var importanceLabel: UILabel!
    @IBOutlet weak var importanceSlider: UISlider!
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    
    @IBOutlet weak var locationLabel: UILabel!
    var task : Task?
    var locationTask : MKPlacemark? = MKPlacemark.init(coordinate: CLLocationCoordinate2D.init(latitude: 13.04016, longitude: 80.243044))
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        let isAddingTask = presentingViewController is UINavigationController
        if isAddingTask {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        }
        else{
            fatalError("Controller not inside nav controller")
        }
    }
    
    @IBAction func unwindToTaskView(sender : UIStoryboardSegue){
        if let sourceViewController = sender.source as? LocationViewController, let locationForTask = sourceViewController.selectedPlace{
            locationTask = locationForTask
            locationLabel.text = "Current location = " + HelperMethods.parseAddress(selectedItem: locationTask!)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let button = sender as? UIBarButtonItem, button===saveBtn else{
                                    return
        }
        let name = nameTxf.text ?? ""
        let date = datePicker.date
        let importance = importanceSlider.value
        
        if locationLabel.text == "No location specified" {
            task = Task(name: name, date: date, importance: Int(importance), location : MKPlacemark.init(coordinate: CLLocationCoordinate2D.init(latitude: 13.04016, longitude: 80.243044)))
        }
        task = Task(name: name, date: date, importance: Int(importance), location : locationTask!)
    }
    
    //Actions
    @IBAction func sliderChanged(_ sender: UISlider) {
        let roundedValue = round(sender.value)
        sender.value = roundedValue
        self.importanceLabel.text = String(format : "%.0f", sender.value)
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
                nameTxf.delegate = self
        if let task = task {
            navigationItem.title = task.name
            nameTxf.text = task.name
            datePicker.date = task.date
            importanceSlider.value = Float(task.importance)
            importanceLabel.text = task.importance.description
            locationLabel.text = (task.location != nil) ? "Current location = " + HelperMethods.parseAddress(selectedItem: task.location!) : "No location specified"
        }
        updateSaveBtn()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveBtn()
        navigationItem.title = textField.text
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveBtn.isEnabled = false
    }
    
    private func updateSaveBtn() {
        let text = nameTxf.text ?? ""
        saveBtn.isEnabled = !text.isEmpty
    }

}

