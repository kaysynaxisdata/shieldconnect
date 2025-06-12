//
//  ProductView.swift
//  shield-connect
//
//  Created by Александр on 12.04.2025.
//

import UIKit

class SaleView: UIView {
    
    private lazy var label: UILabel = {
        var label = ViewFactory.label(
            font: FontFamily.RedHatDisplay.black.font(size: 12),
            color: .white
        )
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        common()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func common() {
        self.backgroundColor = Asset.mainText.color
        self.layer.cornerRadius = 8
        self.addSubview(label)
        self.label.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview().inset(8)
        }
    }
    
    func configure(text: String) {
        self.label.text = text
    }
    
}

class ProductView: UIView {

    var isSelected: Bool = false {
        didSet {
            self.updateUI()
        }
    }
    
    var product: ProductDTO
    private lazy var priceLabel: UILabel = {
        var label = ViewFactory.label(
            font: FontFamily.RedHatText.medium.font(size: 24),
            color: .white
        )
        label.text = "price"
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    private lazy var titleLabel: UILabel = {
        var label = ViewFactory.label(
            font: FontFamily.RedHatText.regular.font(size: 14),
            color: .white
        )
        label.numberOfLines = 2
        label.text = "ttielle\nprice"
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    private lazy var containerView: UIView = {
        var view = UIView()
        view.layer.cornerRadius = 24
        view.layer.borderWidth = 1
        view.layer.borderColor = Asset.mainPurple.color.cgColor
        return view
    }()
    private lazy var contentView: UIImageView = {
        var view = UIImageView()
        view.backgroundColor = .white
        view.image = Asset.settingBannerBg.image
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    init(product: ProductDTO) {
        self.product = product
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        containerView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        
        let vStack = ViewFactory.stack(.vertical, spacing: 8)
        contentView.addSubview(vStack)
        vStack.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.top.equalToSuperview().inset(20)
        }
        
        vStack.addArrangedSubview(UIView())
        vStack.addArrangedSubview(priceLabel)
        vStack.addArrangedSubview(titleLabel)
        
        self.configure(product: self.product)
    }
    
    private func configure(product: ProductDTO) {
        self.priceLabel.text = product.localizedPrice
        var description: String = product.name
        if let salePrice = product.salePrice {
            description = description + "\n" + salePrice
        } else {
            description = description + "\n" + product.localizedPrice
        }
        self.titleLabel.text = description
    }
    
    private func updateUI() {
        if self.isSelected {
            self.containerView.layer.borderWidth = 1
            self.contentView.image = Asset.settingBannerBg.image
            self.titleLabel.textColor = .white
            self.priceLabel.textColor = .white
        } else {
            self.containerView.layer.borderWidth = 0
            self.contentView.image = nil
            self.titleLabel.textColor = Asset.mainText.color
            self.priceLabel.textColor = Asset.mainText.color
        }
    }
    
}
