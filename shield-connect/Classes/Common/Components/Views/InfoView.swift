//
//  InfoView.swift
//  shield-connect
//
//  Created by Александр on 30.04.2025.
//

import UIKit

enum Info {
    case ping
    case ip
    case upload
    case download
    
    var icon: UIImage? {
        switch self {
        case .ping:
            return Asset.speedcheckerPing.image
        case .ip:
            return Asset.speedcheckerIp.image
        case .upload:
            return Asset.speedcheckerUpload.image
        case .download:
            return Asset.speedcheckerDownload.image
        }
    }
    var title: String {
        switch self {
        case .ping:
            return "Ping"
        case .ip:
            return "IP address"
        case .upload:
            return "Upload"
        case .download:
            return "Download"
        }
    }
}

class InfoView: UIView {

    private lazy var iconView: UIImageView = {
        var view = UIImageView()
        view.contentMode = .center
        view.backgroundColor = Asset.mainPurple.color.withAlphaComponent(0.08)
        return view
    }()
    private lazy var titleLabel: UILabel = {
        var view = ViewFactory.label(
            font: FontFamily.RedHatText.regular.font(size: 12),
            color: Asset.mainAdditional.color.withAlphaComponent(0.6)
        )
        return view
    }()
    private lazy var valueLabel: UILabel = {
        var label = ViewFactory.label(
            font: FontFamily.RedHatText.regular.font(size: 14),
            color: Asset.mainText.color
        )
        label.text = "-"
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        common()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.iconView.layoutIfNeeded()
        self.iconView.layer.cornerRadius = self.iconView.frame.height / 2
    }
    
    private func common() {
        let containerView = UIView()
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let hStack = ViewFactory.stack(.horizontal, spacing: 12)
        let vStack = ViewFactory.stack(.vertical, spacing: 4)
        
        containerView.addSubview(hStack)
        hStack.addArrangedSubview(iconView)
        hStack.addArrangedSubview(vStack)
        hStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        iconView.snp.makeConstraints { make in
            make.width.equalTo(hStack.snp.height)
        }
        
        vStack.addArrangedSubview(valueLabel)
        vStack.addArrangedSubview(titleLabel)
    }
    
    func configure(type: Info, value: String) {
        self.iconView.image = type.icon
        self.iconView.tintColor = Asset.mainPurple.color
        self.valueLabel.text = value
        self.titleLabel.text = type.title
    }

}
