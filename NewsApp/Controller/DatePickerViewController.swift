//
//  DatePickerViewController.swift
//  NewsApp
//
//  Created by Alvin  on 03/10/2022.
//

import UIKit

class DatePickerViewController: UIViewController {
    
    private let datePicker:UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.addTarget(self, action: #selector(onChangedValue(sender:)), for: .valueChanged)
        return datePicker
    }()
    
    private var dateTextField = UITextField()
    private var secondDatePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(self.datePicker)
        view.addSubview(self.dateTextField)
        setUpDateTextField()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setUpConstaints()
    }
    
    @objc func onChangedValue(sender:UIDatePicker)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        debugPrint(dateFormatter.string(from: sender.date))
    }
    
}

extension DatePickerViewController
{
    
    private func setUpConstaints()
    {
        self.datePicker.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.datePicker.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        self.dateTextField.topAnchor.constraint(equalTo: self.datePicker.bottomAnchor, constant: 25).isActive = true
        self.dateTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.dateTextField.widthAnchor.constraint(equalToConstant: 150).isActive = true
        self.dateTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
}

extension DatePickerViewController
{
    private func setUpDateTextField()
    {
        self.dateTextField.translatesAutoresizingMaskIntoConstraints = false
        self.secondDatePicker.preferredDatePickerStyle = .compact
        
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: nil)
        toolbar.setItems([doneItem], animated: true)
        
        dateTextField.inputAccessoryView = toolbar
        dateTextField.inputView = self.secondDatePicker
        Utils.addShadowCorners(dateTextField)

    }
}
