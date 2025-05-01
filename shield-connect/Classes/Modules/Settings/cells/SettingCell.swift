//
//  SettingCell.swift
//  shield-connect
//
//  Created by Александр on 12.04.2025.
//

import UIKit

class SettingCell: UITableViewCell {

    static let identifier = "SettingCell"

    private lazy var iconView: UIImageView = {
        var view = UIImageView()
        return view
    }()
    private lazy var arrowView: UIImageView = {
        var view = UIImageView()
        view.image = Asset.settingChevronLight.image
        view.contentMode = .scaleAspectFit
        return view
    }()
    private lazy var titleLabel: UILabel = {
        var label = ViewFactory.label(
            font: FontFamily.RedHatText.medium.font(size: 16),
            color: Asset.mainText.color
        )
        label.text = "Germany"
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.iconView.layoutIfNeeded()
        self.iconView.layer.cornerRadius = self.iconView.frame.height / 2
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.selectionStyle = .none
        let containerView = UIView()
        contentView.addSubview(containerView)
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let hStack = ViewFactory.stack(.horizontal, spacing: 20)
        containerView.addSubview(hStack)
        hStack.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
            make.top.bottom.equalToSuperview().inset(24)
            make.height.equalTo(20)
        }
        
        hStack.addArrangedSubview(iconView)
        hStack.addArrangedSubview(titleLabel)
        hStack.addArrangedSubview(arrowView)
        
        iconView.snp.makeConstraints { make in
            make.width.equalTo(iconView.snp.height)
        }
        arrowView.snp.makeConstraints { make in
            make.width.equalTo(24)
        }
        
    }
    
    func configure(item: Setting) {
        self.titleLabel.text = item.title
        self.iconView.image = item.icon?.withRenderingMode(.alwaysTemplate)
        self.iconView.tintColor = item.color
    }

}
