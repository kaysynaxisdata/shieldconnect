//
//  ProgressView.swift
//  shield-connect
//
//  Created by Александр on 12.04.2025.
//

import UIKit
import SnapKit

class ProgressView: UIView {

    var didLoad: Completion?
    
    private lazy var containerView: UIView = {
        var view = UIView()
        view.backgroundColor = Asset.mainGrey.color
        view.clipsToBounds = true
        return view
    }()
    private lazy var progressView: UIImageView = {
        var view = UIImageView()
        view.image = Asset.splashProgress.image
        return view
    }()
    private lazy var glowView: UIImageView = {
        var view = UIImageView()
        view.image = Asset.splashGlow.image
        return view
    }()
    private var progressWidthConstraint: Constraint?
    private var glowWidthConstraint: Constraint?
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.containerView.layer.cornerRadius = self.containerView.frame.height / 2
    }
    
    private func setupUI() {
        addSubview(glowView)
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        containerView.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.top.bottom.left.equalToSuperview()
            self.progressWidthConstraint = make.width.equalTo(0).constraint
        }
        glowView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(8)
            self.glowWidthConstraint = make.width.equalTo(0).constraint
        }

        start()
    }
    
    private func start() {
        self.progressView.layoutIfNeeded()
        progressView.snp.updateConstraints { make in
            self.progressWidthConstraint = make.width.equalTo(400).constraint
        }
        glowView.snp.updateConstraints { make in
            self.glowWidthConstraint = make.width.equalTo(400).constraint
        }
        UIView.animate(
            withDuration: 2,
            animations: { [weak self] in
                self?.layoutIfNeeded()
            },
            completion: { [weak self] complete in
                self?.didLoad?()
            }
        )
    }

}
