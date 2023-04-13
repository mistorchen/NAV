//
//  BasicInfoSetupVC.swift
//  NAV
//
//  Created by Alex Chen on 4/10/23.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore


class BasicInfoSetupVC: UIViewController{

    let db = Firestore.firestore()
    
    @IBOutlet weak var DOBDatePicker: UIDatePicker!
    @IBOutlet weak var unitTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    
    let units = ["lb", "kg"]
    
    var unitPickerView = UIPickerView()
    
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        unitTextField.inputView = unitPickerView
        
        
        unitPickerView.delegate = self
        unitPickerView.dataSource = self
        
        DOBDatePicker.datePickerMode = .date
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        
        
    }

    @IBAction func dobChanged(_ sender: UIDatePicker) {
        db.collection("users").document(Auth.auth().currentUser!.uid).setData(["dob" : sender.date], merge: true)
    }
    @IBAction func firstNameEntered(_ sender: UITextField) {
        if sender.text?.isEmpty == false{
            if let name = sender.text{
                db.collection("users").document(Auth.auth().currentUser!.uid).setData(["firstName" : name], merge: true)
            }
        }
    }
    @IBAction func LastNameEntered(_ sender: UITextField) {
        if sender.text?.isEmpty == false{
            if let name = sender.text{
                db.collection("users").document(Auth.auth().currentUser!.uid).setData(["lastName" : name], merge: true)
            }
        }
    }
    @IBAction func weightChanged(_ sender: UITextField) {
        if sender.text?.isEmpty == false{
            if let weight = sender.text{
                db.collection("users").document(Auth.auth().currentUser!.uid).setData(["weight" : Int(weight)!], merge: true)
            }
        }
    }
    @IBAction func unitChanged(_ sender: UITextField) {
        if let unit = sender.text{
            if unit == "lb"{
                db.collection("users").document(Auth.auth().currentUser!.uid).setData(["unit" : 0], merge: true)
            }else if unit == "kg"{
                db.collection("users").document(Auth.auth().currentUser!.uid).setData(["unit" : 1], merge: true)
            }
        }
    }
    
    @IBAction func completePressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToFTS", sender: self)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}




extension BasicInfoSetupVC:  UIPickerViewDataSource, UIPickerViewDelegate{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return units.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return units[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
        unitTextField.text = units[row]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.unitTextField.resignFirstResponder()
            
        }
    }
}


