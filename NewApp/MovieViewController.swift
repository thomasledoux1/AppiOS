//
//  MovieViewController.swift
//  NewApp
//
//  Created by Thomas on 06/01/2017.
//  Copyright © 2017 Thomas. All rights reserved.
//

import UIKit
import os.log

class MovieViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //MARK: properties
    @IBOutlet weak var movieNameTxf: UITextField!
    @IBOutlet weak var photoImgView: UIImageView!
    var movie : Movie?
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    
    @IBOutlet weak var ratingSlider: UISlider!
    
    @IBOutlet weak var ratingLbl: UILabel!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        movieNameTxf.delegate = self
        if let movie = movie {
            navigationItem.title = movie.name
            movieNameTxf.text = movie.name
            photoImgView.image = movie.photo
            ratingSlider.value = Float(movie.rating)
            ratingLbl.text = String(format : "%d", movie.rating)

        }
        updateSaveBtn()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let btn = sender as? UIBarButtonItem, btn === saveBtn else{
            return
        }
        let name = movieNameTxf.text ?? ""
        let photo = photoImgView.image
        let rating = Int(ratingSlider.value)
        movie = Movie(name: name, photo: photo, rating : rating)
    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        let roundedValue = round(sender.value)
        sender.value = roundedValue
        self.ratingLbl.text = String(format : "%.0f", sender.value)
    }
    
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        if let owningNavigationCntrl = navigationController {
            owningNavigationCntrl.popViewController(animated: true)
        }
        else {
            self.dismiss(animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        movieNameTxf.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveBtn()
        navigationItem.title = textField.text
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedPhoto = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        photoImgView.image = selectedPhoto
        dismiss(animated: true, completion: nil)
    }
    
    private func updateSaveBtn() {
        let text = movieNameTxf.text ?? ""
        saveBtn.isEnabled = !text.isEmpty
    }
    
    @IBAction func selectImg(_ sender: UITapGestureRecognizer) {
        movieNameTxf.resignFirstResponder()
        os_log("selecting image", log: OSLog.default, type: .debug)
        let imgPickController = UIImagePickerController()
        imgPickController.sourceType = .photoLibrary
        imgPickController.delegate = self
        present(imgPickController, animated: true, completion: nil)
        
    }
    
}
