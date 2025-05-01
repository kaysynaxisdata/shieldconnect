//
//  SpeedTestBannerView.swift
//  shield-connect
//
//  Created by Александр on 12.04.2025.
//

import Foundation
import UIKit

class BannerView: UIView {
    
    var frontColor: UIColor = Asset.mainText.color {
        didSet {
            self.titleLabel.textColor = self.frontColor
            self.subtitleLabel.textColor = self.frontColor
            self.arrowView.tintColor = self.frontColor
        }
    }
    var backgroundImage: UIImage? {
        didSet {
            self.backView.image = self.backgroundImage
        }
    }
    private lazy var containerView: UIView = {
        var view = UIView()
        view.clipsToBounds = true
        return view
    }()
    private lazy var backView: UIImageView = {
        let view = UIImageView(image: nil)
        view.contentMode = .scaleAspectFill
        return view
    }()
    private lazy var iconView: UIImageView = {
        let view = UIImageView(image: Asset.mainShield.image)
        view.contentMode = .scaleAspectFit
        view.snp.makeConstraints { make in
            make.width.equalTo(40)
        }
        return view
    }()
    private lazy var titleLabel: UILabel = {
        let label = ViewFactory.label(
            font: FontFamily.RedHatText.medium.font(size: 18),
            color: Asset.mainText.color
        )
        label.text = "Privacy Insights"
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    private lazy var subtitleLabel: UILabel = {
        let label = ViewFactory.label(
            font: FontFamily.RedHatDisplay.regular.font(size: 14),
            color: Asset.mainText.color.withAlphaComponent(0.6)
        )
        label.adjustsFontSizeToFitWidth = true
        label.text = "Check your current connection"
        return label
    }()
    private lazy var arrowView: UIImageView = {
        let view = UIImageView(image: Asset.mainChevronRight.image.withRenderingMode(.alwaysTemplate))
        view.contentMode = .scaleAspectFit
        view.snp.makeConstraints { make in
            make.width.equalTo(20)
        }
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(containerView)
        containerView.backgroundColor = Asset.mainLightblue.color
        containerView.layer.cornerRadius = 24
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        containerView.addSubview(backView)
        backView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
 
        let hStack = ViewFactory.stack(.horizontal, spacing: 18)
        containerView.addSubview(hStack)
        hStack.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
            make.top.bottom.equalToSuperview().inset(14)
        }
        
        let vStack = ViewFactory.stack(.vertical, spacing: 4)
        
        let cView = UIView()
        cView.addSubview(vStack)
        vStack.snp.makeConstraints { make in
            make.left.right.centerY.equalToSuperview()
        }
        
        vStack.addArrangedSubview(titleLabel)
        vStack.addArrangedSubview(subtitleLabel)
        
        hStack.addArrangedSubview(iconView)
        hStack.addArrangedSubview(cView)
        hStack.addArrangedSubview(arrowView)
        
    }
    
    func configure(title: String, subtitle: String, icon: UIImage) {
        self.titleLabel.text = title
        self.subtitleLabel.text = subtitle
        self.iconView.image = icon
    }
    
}
