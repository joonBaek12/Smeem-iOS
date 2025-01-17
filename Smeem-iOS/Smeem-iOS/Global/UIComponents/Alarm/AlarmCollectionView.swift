//
//  AlarmCollectionView.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/05/10.
//

/**
 1. 사용할 VC에서 AlarmCollectionView 프로퍼티 생성
 private lazy var alarm = AlarmCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
 
 2. view에 addSubView 하고 넓이, 높이값 포함한 레이아웃 설정
 */

import UIKit

final class AlarmCollectionView: UICollectionView {
    
    // MARK: - Property
    
    var dayArray = ["월", "화", "수", "목", "금", "토", "일"]
    var selectedIndexPath = [IndexPath(item: 0, section: 0), IndexPath(item: 1, section: 0), IndexPath(item: 2, section: 0), IndexPath(item: 3, section: 0), IndexPath(item: 4, section: 0)]
    var dayDicrionary: [String:String] = ["월": "MON", "화": "TUE", "수": "WED", "목": "THU", "금": "FRI", "토": "SAT", "일": "SUN"]
    
    var selectedDayArray: Set<String> = ["MON", "TUE", "WED", "THU", "FRI"] {
        didSet {
            selectedDayArray.isEmpty ?
            trainingDayClosure?((day: Array(selectedDayArray).joined(separator: ","), .notEnabled)) :
            trainingDayClosure?((Array(selectedDayArray).joined(separator: ","), .enabled))
        }
    }
    
    var trainingDayClosure: (((day: String, type: SmeemButtonType)) -> Void)?
    var trainingTimeClosure: (((hour: Int, minute: Int)) -> Void)?
    
    var myPageTime = (time: 100, minute: 100)
    var hasAlarm = true {
        didSet {
            self.reloadData()
        }
    }
    
    // MARK: - UI Property
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        setBackgroundColor()
        setProperty()
        setDelegate()
        setCellRegister()
        setViewRegister()
        setLayerUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - @objc
    
    // MARK: - Custom Method
    
    private func setBackgroundColor() {
        backgroundColor = .clear
    }
    
    private func setLayerUI() {
        makeRoundCorner(cornerRadius: 6)
        layer.borderWidth = 1.5
        layer.borderColor = UIColor.gray100.cgColor
    }
    
    private func setProperty() {
        showsHorizontalScrollIndicator = false
        allowsMultipleSelection = true
    }
    
    private func setDelegate() {
        self.delegate = self
        self.dataSource = self
    }
    
    private func setCellRegister() {
        self.register(AlarmCollectionViewCell.self, forCellWithReuseIdentifier: AlarmCollectionViewCell.identifier)
    }
    
    private func setViewRegister() {
        self.register(DatePickerFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: DatePickerFooterView.identifier)
    }
    
    // MARK: - Layout
}

// MARK: - UICollectionViewDelegate

extension AlarmCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? AlarmCollectionViewCell else { return }
        cell.selctedCell(hasAlarm: hasAlarm)
        
        selectedDayArray.insert(dayDicrionary[dayArray[indexPath.item]] ?? "")
        print(selectedDayArray)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? AlarmCollectionViewCell else { return }
        cell.desecltedCell()
        
        selectedDayArray.remove(dayDicrionary[dayArray[indexPath.item]] ?? "")
        print(selectedDayArray)
    }
}

// MARK: - UICollectionViewDataSource

extension AlarmCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dayArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  AlarmCollectionViewCell.identifier, for: indexPath) as? AlarmCollectionViewCell else { return UICollectionViewCell() }
        
        let initalSelectedIndexPaths = selectedIndexPath.contains(indexPath)
        
        if initalSelectedIndexPaths {
            cell.selctedCell(hasAlarm: hasAlarm)
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
        } else {
            cell.desecltedCell()
        }
        
        cell.setData(dayArray[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension AlarmCollectionView: UICollectionViewDelegateFlowLayout {
    // (cell size, itemSpacing)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width-46)/7
        let cellSize = CGSize(width: width, height: 49)
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // footer
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let footerSize = CGSize(width: collectionView.frame.width, height: convertByHeightRatio(84))
        return footerSize
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: DatePickerFooterView.identifier, for: indexPath) as? DatePickerFooterView else { return UICollectionReusableView() }
        
        if myPageTime != (100, 100) {
            let str = footerView.calculateMyPageTime(hour: myPageTime.time, minute: myPageTime.minute)
            let splitStrOne = str.split(separator: ":")
            let splitStrTwo = splitStrOne[1].split(separator: " ")
            
            let hour = String(splitStrOne[0])
            let time = String(splitStrTwo[0])
            let amAndPm = String(splitStrTwo[1])
            
            footerView.inputTextField.text = str
            footerView.mypageData = (hour, time, amAndPm)
            
            if !hasAlarm {
                footerView.inputTextField.textColor = .gray300
                footerView.alarmLabel.textColor = .gray300
            } else {
                footerView.inputTextField.textColor = .point
                footerView.alarmLabel.textColor = .point
            }
        } else {
            // 온보딩
            print("온보딩")
        }
        
        footerView.trainingTimeClosure = { data in
            let hoursData = data.hour
            let minuteData = data.minute
            let traingData: (Int, Int) = (hoursData, minuteData)
            
            self.trainingTimeClosure?(traingData)
        }
        return footerView
    }
}
