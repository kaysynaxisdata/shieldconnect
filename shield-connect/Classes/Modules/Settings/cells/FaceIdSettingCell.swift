//
//  FaceIdSettingCell.swift
//  shield-connect
//
//  Created by Александр on 18.04.2025.
//

import UIKit

class FaceIdSettingCell: UITableViewCell {

    var didSwitch: Completion?
    static let identifier = "FaceIdSettingCell"

    private lazy var iconView: UIImageView = {
        var view = UIImageView()
        return view
    }()
    private lazy var switchView: UISwitch = {
        var view = UISwitch()
        view.onTintColor = Asset.mainBgblack.color
        view.addTarget(self, action: #selector(switchValueDidChange), for: .valueChanged)
        return view
    }()
    private lazy var titleLabel: UILabel = {
        var label = ViewFactory.label(
            font: FontFamily.RedHatText.medium.font(size: 16),
            color: Asset.mainText.color
        )
        label.text = ""
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
            make.left.equalToSuperview().inset(24)
            make.right.equalToSuperview().inset(50)
            make.top.bottom.equalToSuperview().inset(24)
            make.height.equalTo(20)
        }
        
        hStack.addArrangedSubview(iconView)
        hStack.addArrangedSubview(titleLabel)
        
        containerView.addSubview(switchView)
        switchView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(24)
            make.centerY.equalToSuperview()
        }
        
        iconView.snp.makeConstraints { make in
            make.width.equalTo(iconView.snp.height)
        }
        
    }
    
    @objc
    private func switchValueDidChange() {
        self.didSwitch?()
    }
    
    func configure(item: Setting, isEnable: Bool) {
        self.titleLabel.text = item.title
        self.iconView.image = item.icon?.withRenderingMode(.alwaysTemplate)
        self.iconView.tintColor = item.color
        self.switchView.setOn(isEnable, animated: false)
    }


}
