//
//  DatePickerViewController.swift
//  NewsApp
//
//  Created by Alvin  on 03/10/2022.
//

import UIKit
import HorizonCalendar

class DatePickerViewController: UIViewController {
    
    private let dummyCalenderView:CalendarView = {
        let calender = Calendar.current
        let startingMonthOfTheCalender = calender.date(from: DateComponents(year:2022,month: 01,day:01))!
        let endingMonthOfTheCalender = calender.date(from: DateComponents(year:2022,month: 12,day: 31))!
        let calenderContent = CalendarViewContent(calendar: calender, visibleDateRange: startingMonthOfTheCalender...endingMonthOfTheCalender, monthsLayout: .vertical(options: VerticalMonthsLayoutOptions()))
       let customCalenderContent = calenderContent.dayItemProvider { day in
            return CalendarItemModel<DayLabel>(
                invariantViewProperties: .init(font:UIFont.systemFont(ofSize: 18),textColor:.white,backgroundColor:.blue), viewModel: .init(day:day)
            )
       }.interMonthSpacing(24).verticalDayMargin(8).horizontalDayMargin(8)
        
        let calenderView = CalendarView(initialContent: customCalenderContent)
        calenderView.translatesAutoresizingMaskIntoConstraints = false
        return calenderView
    }()
    
    private let datePicker:UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.addTarget(DatePickerViewController.self, action: #selector(onChangedValue(sender:)), for: .valueChanged)
        return datePicker
    }()
    
    private var dateTextField = UITextField()
    private var secondDatePicker = UIDatePicker()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(self.dummyCalenderView)
//        setUpADummyTextField()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        setUpConstaints()
        setUpConstraintsForDummyCalenderView()
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
    
    private func setUpConstraintsForDummyCalenderView()
    {
        self.dummyCalenderView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        self.dummyCalenderView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        self.dummyCalenderView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 35).isActive = true
        self.dummyCalenderView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 35).isActive = true
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

extension DatePickerViewController
{
    private func setUpADummyTextField()
    {
        self.dateTextField.translatesAutoresizingMaskIntoConstraints = false
        let calenderView = CalendarView(initialContent: self.makeContent())
        Utils.addShadowCorners(self.dateTextField)
        self.dateTextField.inputView = calenderView
    }
    
    
    
    private func makeContent() -> CalendarViewContent
    {
        let calendar = Calendar.current

          let startDate = calendar.date(from: DateComponents(year: 2021, month: 01, day: 01))!
          let endDate = calendar.date(from: DateComponents(year: 2022, month: 12, day: 31))!

          return CalendarViewContent(
            calendar: calendar,
            visibleDateRange: startDate...endDate,
            monthsLayout: .vertical(options: VerticalMonthsLayoutOptions())).dayItemProvider { day in
                CalendarItemModel<DayLabel>(
                    invariantViewProperties: .init(
                      font: UIFont.systemFont(ofSize: 18),
                      textColor: .darkGray,
                      backgroundColor: .blue),
                    viewModel: .init(day: day))
                
            }
            .interMonthSpacing(24)
                .verticalDayMargin(8)
                .horizontalDayMargin(8)
    }
}


