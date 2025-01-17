//
//  DatePickerFooterView.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/05/11.
//

import UIKit

import SnapKit

final class DatePickerFooterView: UICollectionReusableView {
    
    static let identifier = "identifier"

    var trainingTimeClosure: ((TrainingTime) -> Void)?
    
    // MARK: - Property
    
    let hoursArray = [("1", 0), ("2", 1), ("3", 2), ("4", 3), ("5", 4), ("6", 5), ("7", 6), ("8", 7), ("9", 8), ("10", 9), ("11", 10), ("12", 11)]
    let minuteArray = [("00", 0), ("30", 1)]
    let dayAndNightArray = [("AM", 0), ("PM", 1)]
    
    var selectedHours: String?
    var selectedMinute: String?
    var selectedDayAndNight: String?
    var totalText = ""
    
    var mypageData = (hours: "", minute: "", amAndPM: "") {
        didSet {
            setSettingTime()
        }
    }
    
    // MARK: - UI Property
    
    let alarmLabel: UILabel = {
        let label = UILabel()
        label.text = "알림 시간"
        label.font = .c2
        label.textColor = .point
        return label
    }()
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.text = "10:00 PM"
        textField.textColor = .point
        textField.font = .s2
        textField.tintColor = .clear
        textField.inputView = pickerView
        textField.inputAccessoryView = pickerToolBar
        return textField
    }()
    
    private let pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.backgroundColor = .clear
        return pickerView
    }()
    
    private let pickerToolBar: UIToolbar = {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35))
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.backgroundColor = .lightGray
        
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: nil, action: #selector(saveButtonDidTap))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancleButton = UIBarButtonItem(title: "Cancle", style: .plain, target: nil, action: #selector(cancleButtonDidTap))
        
        toolBar.setItems([cancleButton, space, saveButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        return toolBar
    }()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setBackgroundColor()
        setLayout()
        setPickerViewDelegate()
        setTextFieldDelgate()
        setSettingTime()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - @objc
    
    @objc func saveButtonDidTap() {
        let selectedHours = selectedHours ?? "10"
        let selectedMinute = selectedMinute ?? "00"
        let selectedDayAndNight = selectedDayAndNight ?? "PM"
        
        totalText = ""
        totalText += selectedHours
        totalText += ":" + selectedMinute
        totalText += " " + selectedDayAndNight
        inputTextField.text = totalText
        
        let trainingTime = TrainingTime(day: String(),
                                        hour: calculateTime(dayAndNight: selectedDayAndNight,
                                                            hours: selectedHours),
                                        minute: Int(selectedMinute)!)
        self.trainingTimeClosure?(trainingTime)
        
        self.inputTextField.resignFirstResponder()
    }
    
    @objc func cancleButtonDidTap() {
        self.inputTextField.resignFirstResponder()
    }
    
    // MARK: - Custom Method
    
    // 1 ~ 24
    func calculateTime(dayAndNight: String, hours: String) -> Int {
        if dayAndNight == "PM" {
            if hours == "12" {
                return 12 // 12 PM 그대로
            }
            return Int(hours)!+12 // 13~23시까지
        } else {
            if hours == "12" { // AM 00:00
                return 24
            } else {
                return Int(hours)!
            }
        }
    }
    
    func calculateMyPageTime(hour: Int, minute: Int) -> String {
        var dayAndNight = "" // 1 ~ 24
        var hourString = ""
        var minuteString = ""
        // 12부터 23
        if 12 <= hour && hour < 24 {
            dayAndNight = "PM"
            // 13부터
            if hour > 12 {
                hourString = String(hour-12)
                if minute == 0 {
                    minuteString = String(minute)+"0"
                } else {
                    minuteString = String(minute)
                }
            } else {
                hourString = String(hour)
                if minute == 0 {
                    minuteString = String(minute)+"0"
                } else {
                    minuteString = String(minute)
                }
            }
        } else {
            // 24, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 11
            dayAndNight = "AM"
            if hour == 24 {
                hourString = "12"
            } else {
                hourString = String(hour)
            }
            
            if minute == 0 {
                minuteString = String(minute)+"0"
            } else {
                minuteString = String(minute)
            }
        }
        return hourString + ":" + String(minuteString) + " " + dayAndNight
    }
    
    private func setPickerViewDelegate() {
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    private func setTextFieldDelgate() {
        inputTextField.delegate = self
    }
    
    private func setSettingTime() {
        var desiredHoursRow = 9 // 시작 시간으로 설정할 행 인덱스
        var desiredMinuteRow = 0 // 시작 분으로 설정할 행 인덱스
        var desiredDayAndNightRow = 1 // 시작 AM/PM으로 설정할 행 인덱스
        
        // 마이페이지 데이터라면
        if mypageData != ("", "", "") {
            for hour in hoursArray {
                if mypageData.hours == hour.0 {
                    desiredHoursRow = hour.1
                    break
                }
            }
            
            desiredMinuteRow = mypageData.minute == "00" ? 0 : 1
            desiredDayAndNightRow = mypageData.amAndPM == "AM" ? 0 : 1
        }
        
        pickerView.selectRow(desiredHoursRow, inComponent: 0, animated: false)
        pickerView.selectRow(desiredMinuteRow, inComponent: 1, animated: false)
        pickerView.selectRow(desiredDayAndNightRow, inComponent: 2, animated: false)
        
        // 선택한 값 업데이트
        selectedHours = hoursArray[desiredHoursRow].0
        selectedMinute = minuteArray[desiredMinuteRow].0
        selectedDayAndNight = dayAndNightArray[desiredDayAndNightRow].0
    }
    
    // MARK: - Layout
    
    private func setBackgroundColor() {
        backgroundColor = .clear
    }
    
    private func setLayout() {
        addSubviews(alarmLabel, inputTextField)
        
        alarmLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(convertByHeightRatio(20))
        }
        
        inputTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(alarmLabel.snp.bottom).offset(convertByHeightRatio(4))
        }
    }
}


// MARK: - UITextFieldDelegate

extension DatePickerFooterView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}

// MARK: - UIPickerViewDelegate

extension DatePickerFooterView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            selectedHours = hoursArray[row].0
        case 1:
            selectedMinute = minuteArray[row].0
        default:
            selectedDayAndNight = dayAndNightArray[row].0
        }
    }
}

// MARK: - UIPickerViewDataSource

extension DatePickerFooterView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return hoursArray.count
        case 1:
            return minuteArray.count
        default:
            return dayAndNightArray.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return hoursArray[row].0
        case 1:
            return minuteArray[row].0
        default:
            return dayAndNightArray[row].0
        }
    }
}
