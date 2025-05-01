//
//  SpeedCheckerViewController.swift
//  shield-connect
//
//  Created by Александр on 13.04.2025.
//

import UIKit

class SpeedCheckerViewController: CommonViewController {

    var viewModel: SpeedCheckerViewModel?
    
    private lazy var countryLabel: UILabel = {
        let label = ViewFactory.label(
            font: FontFamily.RedHatText.regular.font(size: 14),
            color: Asset.mainAdditional.color
        )
        label.textAlignment = .center
        label.text = ""
        return label
    }()
    private lazy var pingView: InfoView = {
        var view = InfoView()
        return view
    }()
    private lazy var ipView: InfoView = {
        var view = InfoView()
        return view
    }()
    private lazy var uploadView: InfoView = {
        var view = InfoView()
        view.configure(type: .upload, value: "-")
        return view
    }()
    private lazy var downloadView: InfoView = {
        var view = InfoView()
        view.configure(type: .download, value: "-")
        return view
    }()
    private lazy var speedCheckerView: SpeedCheckerView = {
        var view = SpeedCheckerView()
        return view
    }()
    private lazy var actionButton: UIButton = {
        var button = UIButton(type: .system)
        button.titleLabel?.font = FontFamily.RedHatText.semiBold.font(size: 20)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Asset.mainBgblack.color
        button.setTitle("Start speed test", for: .normal)
        let height = UIScreen.isSmall ? 56 : 56
        button.snp.makeConstraints { make in
            make.height.equalTo(height)
        }
        button.addAction(UIAction(handler: { [weak self] action in
            self?.viewModel?.startCheckerTapped()
        }), for: .touchUpInside)
        return button
    }()
    private lazy var descriptionLabel: UILabel = {
        var label = ViewFactory.label(font: FontFamily.RedHatText.regular.font(size: 14), color: Asset.mainAdditional.color)
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.text = "Note: The results may vary depending on your server and network conditions"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupBindings()
        viewModel?.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.actionButton.layoutIfNeeded()
        self.actionButton.layer.cornerRadius = self.actionButton.frame.height / 2
    }
    
    private func setupUI() {
        let navigationView = NavigationView()
        navigationView.title = "Speed Test"
        navigationView.didBack = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        view.addSubview(navigationView)
        navigationView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(90)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
        }
        
        view.addSubview(speedCheckerView)
        speedCheckerView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(speedCheckerView.snp.width)
            make.left.right.equalToSuperview().inset(32)
        }
        
        let bottomStack = ViewFactory.stack(.vertical, spacing: 8)
        view.addSubview(bottomStack)

        let infoView = UIView()
        view.addSubview(infoView)
        infoView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
            make.top.equalTo(speedCheckerView.snp.bottom).inset(40)
            make.bottom.equalTo(bottomStack.snp.top).inset(-12)
        }
        
        let infoStack = ViewFactory.stack(.horizontal, spacing: 12)
        infoStack.distribution = .fillEqually
        infoStack.snp.makeConstraints { make in
            make.height.equalTo(42)
        }
        infoStack.addArrangedSubview(pingView)
        infoStack.addArrangedSubview(ipView)
        
        let dStack = ViewFactory.stack(.horizontal, spacing: 12)
        dStack.distribution = .fillEqually
        dStack.snp.makeConstraints { make in
            make.height.equalTo(42)
        }
        dStack.addArrangedSubview(downloadView)
        dStack.addArrangedSubview(uploadView)
        
        let vStack = ViewFactory.stack(.vertical, spacing: 8)
        vStack.addArrangedSubview(infoStack)
        vStack.addArrangedSubview(dStack)
        infoView.addSubview(vStack)
        vStack.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        bottomStack.addArrangedSubview(actionButton)
        bottomStack.addArrangedSubview(descriptionLabel)
        bottomStack.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(8)
        }
        
        let topView: UIView = {
            let view = UIView()
            
            let vStack = ViewFactory.stack(.vertical, spacing: 4)
            let locationLabel = ViewFactory.label(
                font: FontFamily.RedHatText.regular.font(size: 12),
                color: Asset.mainAdditional.color.withAlphaComponent(0.6)
            )
            locationLabel.textAlignment = .center
            locationLabel.text = "Location"
            
            vStack.addArrangedSubview(countryLabel)
            vStack.addArrangedSubview(locationLabel)
            
            view.addSubview(vStack)
            vStack.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
            
            return view
        }()
        
        view.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(navigationView.snp.bottom)
            make.bottom.equalTo(speedCheckerView.snp.top)
        }
        
        
    }
    
    func setupBindings() {
        self.viewModel?.didStart = { [weak self] progress in
            DispatchQueue.main.async {
                self?.speedCheckerView.setProgress(0.0, animated: false)
                self?.speedCheckerView.setProgress(progress, animated: true)
                Timer.scheduledTimer(
                    withTimeInterval: 1.5,
                    repeats: false,
                    block: { [weak self] _ in
                        self?.viewModel?.state = .again
                    }
                )
            }
        }
        self.viewModel?.didUpdateUI = { [weak self] in
            DispatchQueue.main.async {
                self?.countryLabel.text = self?.viewModel?.location
                self?.pingView.configure(type: .ping, value: self?.viewModel?.ping ?? "")
                self?.ipView.configure(type: .ip, value: self?.viewModel?.ip ?? "")
            }
        }
        self.viewModel?.didChangeState = { [weak self] status in
            switch status {
            case .begin:
                self?.actionButton.setTitle("Run again", for: .normal)
                self?.actionButton.setTitleColor(.white, for: .normal)
                self?.actionButton.backgroundColor = Asset.mainText.color
                self?.actionButton.layer.borderWidth = 0
                self?.actionButton.isUserInteractionEnabled = true
                self?.descriptionLabel.text = "Note: The results may vary depending on your server and network conditions"
            case .checking:
                self?.actionButton.setTitle("Testing ...", for: .normal)
                self?.actionButton.setTitleColor(Asset.mainPurple.color, for: .normal)
                self?.actionButton.backgroundColor = .white
                self?.actionButton.layer.borderWidth = 1
                self?.actionButton.layer.borderColor = Asset.mainLightblue.color.cgColor
                self?.actionButton.isUserInteractionEnabled = false
                self?.descriptionLabel.text = "\nEstimated time: 7 sec"
            case .again:
                self?.actionButton.setTitle("Run again", for: .normal)
                self?.actionButton.setTitleColor(.white, for: .normal)
                self?.actionButton.backgroundColor = Asset.mainText.color
                self?.actionButton.layer.borderWidth = 0
                self?.actionButton.isUserInteractionEnabled = true
                self?.descriptionLabel.text = "Note: The results may vary depending on your server and network conditions"
                self?.downloadView.configure(type: .download, value: self?.viewModel?.downloadString ?? "-")
                self?.uploadView.configure(type: .upload, value: self?.viewModel?.uploadString ?? "-")
                self?.speedCheckerView.configure(result: self?.viewModel?.downloadString ?? "-")
            }
        }
    }

}
