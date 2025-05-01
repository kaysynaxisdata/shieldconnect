//
//  ConnectView.swift
//  shield-connect
//
//  Created by Александр on 01.05.2025.
//

import UIKit

enum ConnectViewState {
    case connect
    case connecting
    case disconnecting
    case disconnect
    
    var title: String {
        switch self {
        case .connect:
            "Connected"
        case .connecting:
            "Connecting..."
        case .disconnecting:
            "Disconnecting.."
        case .disconnect:
            "Not connect"
        }
    }
}

class ConnectView: UIView {

    var didTap: Completion?
    
    var state: ConnectViewState = .disconnect {
        didSet {
            self.updateUI()
        }
    }
    
    private lazy var backView: UIImageView = {
        var view = UIImageView()
        return view
    }()
    private lazy var connectionButton: UIButton = {
        var button = UIButton(type: .custom)
        button.isUserInteractionEnabled = false
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        common()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func common() {
        addSubview(backView)
        backView.contentMode = .center
        backView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        addSubview(connectionButton)
        connectionButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(152)
        }
    }
    
    private func updateUI() {
        switch self.state {
        case .connect:
            self.connectionButton.isUserInteractionEnabled = true
            self.connectionButton.setImage(Asset.mainConnectButton.image, for: .normal)
            self.backView.image = Asset.mainStartConnection.image
        case .disconnect:
            self.connectionButton.isUserInteractionEnabled = true
            self.connectionButton.setImage(Asset.mainDisconnectButton.image, for: .normal)
            self.backView.image = Asset.mainPowerConnection.image
        case .connecting:
            self.connectionButton.isUserInteractionEnabled = false
        case .disconnecting:
            self.connectionButton.isUserInteractionEnabled = false
        }
    }
    
}
