//
//  ForeignDiaryViewController.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/06/05.
//

import UIKit

final class ForeignDiaryViewController: DiaryViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        handleRightNavitationButton()
    }
    
    private func handleRightNavitationButton() {
        rightNavigationButton.addTarget(self, action: #selector(rightNavigationButtonDidTap), for: .touchUpInside)
    }
    
    override func rightNavigationButtonDidTap() {
        if rightNavigationButton.titleLabel?.textColor == .point {
            //TODO: HomeView로 돌아가는 코드
        } else {
            regExToastView.show(duration: 0.7)
            
            view.addSubview(regExToastView)
            regExToastView.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.bottom.equalTo(bottomView.snp.top).offset(-20)
            }
        }
    }
}
