//
//  BadgePopupViewController.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/06/29.
//

import UIKit

import SnapKit

final class BadgePopupViewController: UIViewController {
    
    // MARK: - Property
    
    // MARK: - UI Property
    
    private let popupView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.makeRoundCorner(cornerRadius: 10)
        view.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        return view
    }()
    
    private let badgeImage = UIImageView()
    
    private let badgeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .s3
        label.textColor = .black
        return label
    }()
    
    private let badgeDetailLabel: UILabel = {
        let label = UILabel()
        label.font = .c3
        label.textColor = .gray600
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var cancleButton: SmeemButton = {
        let button = SmeemButton()
        button.smeemButtonType = .enabled
        button.backgroundColor = .gray100
        button.titleLabel?.font = .c2
        button.setTitleColor(.gray600, for: .normal)
        button.setTitle("닫기", for: .normal)
        button.addTarget(self, action: #selector(cancelButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var presentBadgeListButton: SmeemButton = {
        let button = SmeemButton()
        button.smeemButtonType = .enabled
        button.titleLabel?.font = .c2
        button.setTitle("배지 모두보기", for: .normal)
        button.addTarget(self, action: #selector(badgeButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundColor()
        setLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setPopupViewAnimate()
    }
    
    // MARK: - @objc
    
    @objc func cancelButtonDidTap() {
        self.dismiss(animated: true)
    }
    
    @objc func badgeButtonDidTap() {
        print("배지 목록 뷰로 이동")
    }
    
    // MARK: - Custom Method
    
    private func setPopupViewAnimate() {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseIn) { [weak self] in
            self?.popupView.transform = .identity
        }
    }
    
    // 배지가 두 개일 가능성 구현 예정
    func setData(_ popupData: [PopupBadge]) {
        for popup in popupData {
            let url = URL(string: popup.imageURL)
            badgeImage.kf.setImage(with: url)
            badgeTitleLabel.text = popup.name
            badgeDetailLabel.text = """
                                    축하해요!
                                    \(popup.name)를 획득했어요!
                                    """
        }
    }
    
    // MARK: - Layout
    
    private func setBackgroundColor() {
        view.backgroundColor = .popupBackground
    }
    
    private func setLayout() {
        view.addSubview(popupView)
        popupView.addSubviews(badgeImage, badgeTitleLabel, badgeDetailLabel, cancleButton, presentBadgeListButton)
        
        popupView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(convertByHeightRatio(201))
            $0.centerX.equalToSuperview()
            $0.width.equalTo(convertByWidthRatio(298))
            $0.height.equalTo(convertByHeightRatio(390))
        }
        
        badgeImage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(convertByHeightRatio(28))
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(convertByHeightRatio(164))
        }
        
        badgeTitleLabel.snp.makeConstraints {
            $0.top.equalTo(badgeImage.snp.bottom).offset(convertByHeightRatio(12))
            $0.centerX.equalToSuperview()
        }
        
        badgeDetailLabel.snp.makeConstraints {
            $0.top.equalTo(badgeTitleLabel.snp.bottom).offset(convertByHeightRatio(33))
            $0.centerX.equalToSuperview()
        }
        
        cancleButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(convertByHeightRatio(10))
            $0.trailing.equalTo(presentBadgeListButton.snp.leading).offset(convertByHeightRatio(-8))
            $0.bottom.equalToSuperview().inset(convertByHeightRatio(10))
            $0.width.equalTo(convertByWidthRatio(135))
            $0.height.equalTo(convertByHeightRatio(50))
        }
        
        presentBadgeListButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(convertByHeightRatio(10))
            $0.bottom.equalToSuperview().inset(convertByHeightRatio(10))
            $0.height.equalTo(convertByHeightRatio(50))
        }
    }

}
