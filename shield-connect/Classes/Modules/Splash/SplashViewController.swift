//
//  SplashViewController.swift
//  shield-connect
//
//  Created by Александр on 11.04.2025.
//

import UIKit
import SnapKit

class SplashViewController: UIViewController {

    var viewModel: SplashViewModel?
    
    private lazy var progressView: ProgressView = {
        var view = ProgressView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupBindings()
        // Do any additional setup after loading the view.
    }
    
    private func setupUI() {
        let backView = UIImageView(image: UIImage(asset: Asset.splashBackground))
        backView.contentMode = .scaleAspectFill
        view.addSubview(backView)
        backView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let vStack = ViewFactory.stack(.vertical, spacing: 24)
        view.addSubview(vStack)
        vStack.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(40)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(40)
        }
        
        let imageView = UIImageView(image: Asset.commonLogo.image)
        imageView.contentMode = .left
        
        let titleLabel = ViewFactory.label(
            font: UIFont.systemFont(ofSize: 64, weight: .black),
            color: Asset.mainGrey.color
        )
        titleLabel.numberOfLines = 0
        titleLabel.text = "Shield\nConnect"
        
        let subtitleLabel = ViewFactory.label(
            font: UIFont.systemFont(ofSize: 28, weight: .regular),
            color: .white.withAlphaComponent(0.85)
        )
        subtitleLabel.numberOfLines = 0
        subtitleLabel.text = "Advanced Privacy.\nTotal Control"
        
        vStack.addArrangedSubview(imageView)
        vStack.addArrangedSubview(titleLabel)
        vStack.addArrangedSubview(subtitleLabel)
        vStack.addArrangedSubview(progressView)
        
        progressView.snp.makeConstraints { make in
            make.height.equalTo(6)
        }
    }
    
    private func setupBindings() {
        self.progressView.didLoad = { [weak self] in
            self?.viewModel?.viewDidLoad()
        }
    }

}
