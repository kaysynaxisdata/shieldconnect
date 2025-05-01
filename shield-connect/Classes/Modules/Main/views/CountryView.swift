//
//  CountryView.swift
//  shield-connect
//
//  Created by Александр on 12.04.2025.
//

import Foundation
import UIKit

class CountryView: UIView {
    
    private lazy var containerView: UIView = {
        var view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = Asset.mainLightgrey.color.cgColor
        view.layer.cornerRadius = 24
        return view
    }()
    private lazy var iconView: UIImageView = {
        var view = UIImageView()
        view.layer.borderWidth = 1
        view.layer.borderColor = Asset.mainPurple.color.withAlphaComponent(0.4).cgColor
        return view
    }()
    private lazy var titleLabel: UILabel = {
        var label = ViewFactory.label(
            font: FontFamily.RedHatText.light.font(size: 16),
            color: Asset.mainCountry.color
        )
        label.text = "Select server"
        return label
    }()
    private lazy var pingLabel: UILabel = {
        var label = ViewFactory.label(
            font: FontFamily.RedHatText.regular.font(size: 14),
            color: Asset.mainAdditional.color
        )
        label.text = "145 ms"
        return label
    }()
    private lazy var pingStack: UIStackView = {
        var view = ViewFactory.stack(.horizontal, spacing: 8)
        var image = UIImageView(image: Asset.signalGood.image)
        image.contentMode = .scaleAspectFit
        view.addArrangedSubview(image)
        view.addArrangedSubview(pingLabel)
        view.isHidden = true
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.iconView.layoutIfNeeded()
        self.iconView.layer.cornerRadius = self.iconView.frame.height / 2
    }
    
    private func setupUI() {
        let hStack = ViewFactory.stack(.horizontal, spacing: 12)
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        containerView.addSubview(hStack)
        hStack.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(12)
        }
        
        iconView.snp.makeConstraints { make in
            make.width.equalTo(self.iconView.snp.height)
        }
        
        hStack.addArrangedSubview(iconView)
        hStack.addArrangedSubview(titleLabel)
        hStack.addArrangedSubview(pingStack)
        
        let iconView = UIImageView(image: Asset.mainArrowRight.image)
        iconView.contentMode = .scaleAspectFit
        iconView.snp.makeConstraints { make in
            make.width.equalTo(16)
        }
        
        hStack.addArrangedSubview(iconView)
        
    }
    
    func configure(cred: Country?) {
        if let cred = cred {
            self.iconView.sd_setImage(with: URL.init(string: "https://flagsapi.com/\(cred.flag)/flat/64.png"))
            self.pingStack.isHidden = false
            self.pingLabel.text = "\(Int.random(in: 35...150)) ms"
            self.titleLabel.text = cred.country
            self.iconView.layer.borderWidth = 0
        } else {
            self.titleLabel.text = "Select Server"
            self.iconView.image = nil
            self.pingStack.isHidden = false
            self.iconView.layer.borderWidth = 1
        }
    }
    
}
