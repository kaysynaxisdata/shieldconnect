//
//  PasscodeNumberView.swift
//  shield-connect
//
//  Created by Александр on 11.04.2025.
//

import UIKit

enum KeyNumber {
    case one
    case two
    case free
    
    case four
    case five
    case six
    
    case seven
    case eight
    case nine
    
    case zero
    
    var name: String {
        switch self {
        case .one:
            return "1"
        case .two:
            return "2"
        case .free:
            return "3"
        case .four:
            return "4"
        case .five:
            return "5"
        case .six:
            return "6"
        case .seven:
            return "7"
        case .eight:
            return "8"
        case .nine:
            return "9"
        case .zero:
            return "0"
        }
    }
    
    var value: Int {
        switch self {
        case .one:
            return 1
        case .two:
            return 2
        case .free:
            return 3
        case .four:
            return 4
        case .five:
            return 5
        case .six:
            return 6
        case .seven:
            return 7
        case .eight:
            return 8
        case .nine:
            return 9
        case .zero:
            return 0
        }
    }
    
}

class PasscodeNumberView: UIView {

    private var buttons: [UIButton] = []
    var didTapKey: ((String) -> Void)?
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        buttons.forEach { view in
            view.layoutIfNeeded()
            view.layer.cornerRadius = view.frame.width / 2
        }
    }
    
    private func setupUI() {
        
        let contentView = UIView()
        self.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 14, left: 46, bottom: 14, right: 46))
        }
        
        let vStack = ViewFactory.stack(.vertical, spacing: 24)
        vStack.distribution = .fillEqually
        
        let firstStack = ViewFactory.stack(.horizontal, spacing: 24)
        firstStack.distribution = .fillEqually
        let secondStack = ViewFactory.stack(.horizontal, spacing: 24)
        secondStack.distribution = .fillEqually
        let thirdStack = ViewFactory.stack(.horizontal, spacing: 24)
        thirdStack.distribution = .fillEqually
        let fourthStack = ViewFactory.stack(.horizontal, spacing: 24)
        fourthStack.distribution = .fillEqually
        
        let oneButton = createKeyButton(key: .one)
        let twoButton = createKeyButton(key: .two)
        let freeButton = createKeyButton(key: .free)
        
        buttons.append(oneButton)
        buttons.append(twoButton)
        buttons.append(freeButton)
        
        firstStack.addArrangedSubview(oneButton)
        firstStack.addArrangedSubview(twoButton)
        firstStack.addArrangedSubview(freeButton)
        
        let fourButton = createKeyButton(key: .four)
        let fiveButton = createKeyButton(key: .five)
        let sixButton = createKeyButton(key: .six)
        
        secondStack.addArrangedSubview(fourButton)
        secondStack.addArrangedSubview(fiveButton)
        secondStack.addArrangedSubview(sixButton)
        
        buttons.append(fourButton)
        buttons.append(fiveButton)
        buttons.append(sixButton)
        
        let sevenButton = createKeyButton(key: .seven)
        let eightButton = createKeyButton(key: .eight)
        let nineButton = createKeyButton(key: .nine)
        
        thirdStack.addArrangedSubview(sevenButton)
        thirdStack.addArrangedSubview(eightButton)
        thirdStack.addArrangedSubview(nineButton)
        
        buttons.append(sevenButton)
        buttons.append(eightButton)
        buttons.append(nineButton)
        
        let zeroButton = createKeyButton(key: .zero)
        
        let backContainerView = UIView()
        let backContentView = UIImageView(image: Asset.passcodeBack.image)
        backContainerView.addSubview(backContentView)
        backContentView.snp.makeConstraints { make in
            make.size.equalTo(35)
            make.centerX.equalToSuperview().offset(-4)
            make.centerY.equalToSuperview()
        }
        backContentView.contentMode = .center
        let backButton = UIButton(type: .system)
        backButton.tintColor = Asset.mainAdditional.color
        backButton.setImage(Asset.passcodeX.image, for: .normal)
        backContainerView.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        buttons.append(zeroButton)
        
        fourthStack.addArrangedSubview(UIView())
        fourthStack.addArrangedSubview(zeroButton)
        fourthStack.addArrangedSubview(backContainerView)
        
        vStack.addArrangedSubview(firstStack)
        vStack.addArrangedSubview(secondStack)
        vStack.addArrangedSubview(thirdStack)
        vStack.addArrangedSubview(fourthStack)
        
        firstStack.snp.makeConstraints { make in
            make.height.equalTo(oneButton.snp.width)
        }
        oneButton.snp.makeConstraints { make in
            make.size.equalTo(75).priority(.high)
        }
        
        contentView.addSubview(vStack)
        vStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.layoutIfNeeded()
    }
    
    func createKeyButton(key: KeyNumber) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(key.name, for: .normal)
        button.layer.shadowColor = Asset.mainPurple.color.withAlphaComponent(0.3).cgColor
        button.layer.shadowOpacity = 0.6
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 5
        button.backgroundColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .medium)
        button.titleLabel?.textColor = Asset.mainAdditional.color
        button.tintColor = Asset.mainAdditional.color
        button.accessibilityLabel = key.name
        button.addAction(UIAction(handler: { [weak self] action in
            self?.didTapKey?(key.name)
        }), for: .touchUpInside)
        
        return button
    }

}
