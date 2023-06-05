//
//  DiaryViewController.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/06/04.
//

import UIKit

import SnapKit

protocol DiaryStrategy {
    func configureLanguageLabel(_ label: UILabel)
    func configureRightNavigationButton(_ button: UIButton)
    func configureStepLabel(_ label: UILabel)
    func configureRandomSubjectButton(_ button: UIButton)
}

class DiaryViewController: UIViewController {
    
    // MARK: - Property
    
    var diaryStrategy: DiaryStrategy?
    
    private weak var delegate: UITextViewDelegate?
    
    private var randomTopicEnabled: Bool = false {
        didSet {
            updateRandomTopicView()
            updateInputTextViewConstraints()
            view.layoutIfNeeded()
        }
    }
    
    // MARK: - UI Property
    
    let navigationView = UIView()
    private lazy var randomSubjectView = RandomSubjectView()
    
    private let navibarContentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        // FIXME: 기기대응시 문제가 생길수도..?
        stackView.spacing = 110
        return stackView
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .b4
        button.setTitleColor(.black, for: .normal)
        button.setTitle("취소", for: .normal)
        button.addTarget(self, action: #selector(naviButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private let languageLabel: UILabel = {
        let label = UILabel()
        label.font = .s2
        label.textColor = .smeemBlack
        label.text = "English"
        return label
    }()
    
    private let stepLabel: UILabel = {
        let label = UILabel()
        label.font = .c4
        label.textColor = .gray500
        return label
    }()
    
    private lazy var rightNavigationButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .b1
        button.setTitleColor(.gray300, for: .normal)
        button.setTitle("완료", for: .normal)
        button.isEnabled = false
        button.addTarget(self, action: #selector(rightNavigationButtonTapped) , for: .touchUpInside)
        return button
    }()
    
    lazy var inputTextView: UITextView = {
        let textView = UITextView()
        textView.textContainerInset = .init(top: 20, left: 18, bottom: 0, right: 18)
        textView.textColor = .smeemBlack
        textView.font = .b4
        textView.tintColor = .point
        textView.delegate = self
        return textView
    }()
    
    let placeHolderLabel: UILabel = {
        let label = UILabel()
        label.text = "일기를 작성해주세요."
        label.textColor = .gray400
        label.font = .b4
        label.setTextWithLineHeight(lineHeight: 21)
        return label
    }()
    
    let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        return view
    }()
    
    private let thinLine = SeparationLine(height: .thin)
    
    lazy var randomSubjectButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(randomTopicButtonDidTap), for: .touchUpInside)
        button.backgroundColor = .point
        return button
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showKeyboard(textView: inputTextView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDiaryStrategy()
        configureUI()
        setupUI()
    }
    
    deinit {
        randomSubjectView.removeFromSuperview()
    }
    
    // MARK: - @objc
    
    @objc func randomTopicButtonDidTap() {
        setRandomTopicButtonToggle()
    }
    
    @objc func naviButtonDidTap() {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func rightNavigationButtonTapped() {
        //        guard let diaryText = inputTextView.text else { return }
    }
    
    // MARK: - Custom Method
    
    private func setupUI() {
        hiddenNavigationBar()
        setBackgroundColor()
        setLayout()
    }
    
    private func configureDiaryStrategy() {
        if self is ForeignDiaryViewController {
            diaryStrategy = ForeignDiaryStrategy()
        } else if self is StepOneKoreanDiaryViewController {
            diaryStrategy = StepOneKoreanDiaryStrategy()
        } else if self is StepTwoKoreanDiaryViewController {
            diaryStrategy = StepTwoKoreanDiaryStrategy()
        }
    }
    
    private func configureUI() {
        diaryStrategy?.configureLanguageLabel(languageLabel)
        diaryStrategy?.configureRightNavigationButton(rightNavigationButton)
        diaryStrategy?.configureStepLabel(stepLabel)
        diaryStrategy?.configureRandomSubjectButton(randomSubjectButton)
    }
    
    private func setBackgroundColor() {
        view.backgroundColor = .smeemWhite
    }
    
    private func setRandomTopicButtonToggle() {
        randomTopicEnabled.toggle()
    }
    
    private func updateRandomTopicView() {
        if randomTopicEnabled {
            view.addSubview(randomSubjectView)
            randomSubjectView.snp.makeConstraints {
                $0.top.equalTo(navigationView.snp.bottom).offset(convertByHeightRatio(16))
                $0.leading.equalToSuperview()
            }
        } else {
            randomSubjectView.removeFromSuperview()
        }
    }
    
    private func updateInputTextViewConstraints() {
        inputTextView.snp.remakeConstraints {
            $0.top.equalTo(randomTopicEnabled ? randomSubjectView.snp.bottom : navigationView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(bottomView.snp.top)
        }
    }
    
    //MARK: - Layout
    
    private func setLayout() {
        view.addSubviews(navigationView, inputTextView, bottomView)
        navigationView.addSubviews(navibarContentStackView, stepLabel)
        navibarContentStackView.addArrangedSubviews(cancelButton, languageLabel, rightNavigationButton)
        inputTextView.addSubview(placeHolderLabel)
        bottomView.addSubviews(thinLine, randomSubjectButton)
        
        navigationView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(convertByHeightRatio(66))
        }
        
        navibarContentStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.equalToSuperview().offset(convertByWidthRatio(18))
        }
        
        stepLabel.snp.makeConstraints {
            $0.top.equalTo(languageLabel.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }
        
        inputTextView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.centerX.leading.equalToSuperview()
            $0.bottom.equalTo(bottomView.snp.top)
        }
        
        placeHolderLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(convertByHeightRatio(18))
            $0.leading.equalToSuperview().offset(convertByWidthRatio(20))
        }
        
        bottomView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(constraintByNotch(87, 53))
        }
        
        thinLine.snp.makeConstraints {
            $0.bottom.equalTo(bottomView.snp.top)
            $0.centerX.equalToSuperview()
        }
        
        randomSubjectButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(convertByHeightRatio(17))
            $0.trailing.equalToSuperview().offset(convertByWidthRatio(-18))
            $0.width.equalTo(convertByWidthRatio(78))
            $0.height.equalTo(convertByHeightRatio(19))
        }
    }
}

// MARK: - UITextViewDelegate

extension DiaryViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let isTextEmpty = textView.text.isEmpty
        placeHolderLabel.isHidden = !isTextEmpty
        rightNavigationButton.isEnabled = characterValidation()
        rightNavigationButton.setTitleColor(rightNavigationButton.isEnabled ? .point : .gray400, for: .normal)
    }
    
    private func characterValidation() -> Bool {
        return inputTextView.text.getArrayAfterRegex(regex: "[a-zA-z]").count > 9
    }
}

// MARK: - Network
