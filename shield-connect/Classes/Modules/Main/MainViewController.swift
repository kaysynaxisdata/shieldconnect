//
//  MainViewController.swift
//  shield-connect
//
//  Created by Александр on 11.04.2025.
//

import UIKit

class MainViewController: CommonViewController {

    var viewModel: MainViewModel?
    
    private lazy var downloadView: InfoView = {
        var view = InfoView()
        view.configure(type: .download, value: "-")
        return view
    }()
    private lazy var uploadView: InfoView = {
        var view = InfoView()
        view.configure(type: .upload, value: "-")
        return view
    }()
    private lazy var connectButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Secure My Connection", for: .normal)
        button.titleLabel?.font = FontFamily.RedHatDisplay.semiBold.font(size: 20)
        button.setTitleColor(.white, for: .normal)
        button.setBackgroundImage(Asset.splashProgress.image, for: .normal)
        button.layer.masksToBounds = true
        button.layer.borderColor = Asset.mainPurple.color.cgColor

        button.snp.makeConstraints { make in
            make.height.equalTo(56)
        }
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.viewModel?.connectTapped()
        }), for: .touchUpInside)
        return button
    }()
    private lazy var speedCheckerView: UIStackView = {
        var view = ViewFactory.stack(.horizontal, spacing: 8)
        view.distribution = .fillEqually
        view.addArrangedSubview(uploadView)
        view.addArrangedSubview(downloadView)
        view.snp.makeConstraints { make in
            make.height.equalTo(42)
        }
        return view
    }()
    private lazy var settingsButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.setImage(Asset.mainSettings.image, for: .normal)
        button.tintColor = Asset.mainText.color
        button.addAction(UIAction(handler: { [weak self] action in
            self?.viewModel?.settingsButtonTapped()
        }), for: .touchUpInside)
        return button
    }()
    private lazy var statusLabel: UILabel = {
        var label = ViewFactory.label(
            font: FontFamily.RedHatText.regular.font(size: 18),
            color: Asset.mainAdditional.color
        )
        label.text = "Not Connected"
        label.textAlignment = .center
        return label
    }()
    private lazy var countryView: CountryView = {
        var view = CountryView()
        let tapRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(onDidCountryTapped)
        )
        view.addGestureRecognizer(tapRecognizer)
        return view
    }()
    private lazy var connectView: ConnectView = {
        var view = ConnectView()
        view.state = .disconnect
        return view
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        settingsButton.layoutIfNeeded()
        connectButton.layoutIfNeeded()
        settingsButton.layer.cornerRadius = settingsButton.frame.height / 2
        connectButton.layer.cornerRadius = connectButton.frame.height / 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupBindings()
        viewModel?.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    private func setupUI() {
        
        let vStack = ViewFactory.stack(.vertical, spacing: 20)
        view.addSubview(vStack)
        vStack.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(36)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(8)
        }
        
        let bannerView = BannerView()
        bannerView.frontColor = Asset.mainText.color
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onDidBannerTapped))
        bannerView.addGestureRecognizer(tapRecognizer)
        view.addSubview(bannerView)
        bannerView.snp.makeConstraints { make in
            make.height.equalTo(80)
        }
        
        let contentView = UIView()
        let contentViewVStack = ViewFactory.stack(.vertical, spacing: 12)

        contentViewVStack.addArrangedSubview(connectView)
        connectView.snp.makeConstraints { make in
            make.height.equalTo(connectView.snp.width)
        }
        
        countryView.snp.makeConstraints { make in
            make.height.equalTo(56)
        }
        
        contentViewVStack.addArrangedSubview(countryView)
        contentViewVStack.addArrangedSubview(connectButton)
        contentView.addSubview(contentViewVStack)
        contentViewVStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let checkView = ViewFactory.stack(.vertical, spacing: 12)
        checkView.snp.makeConstraints { make in
            make.height.equalTo(86)
        }
        checkView.addArrangedSubview(speedCheckerView)
        checkView.addArrangedSubview(UIView())
        
        vStack.addArrangedSubview(UIView())
        vStack.addArrangedSubview(contentView)
        vStack.addArrangedSubview(checkView)
        vStack.addArrangedSubview(bannerView)
        
        view.addSubview(settingsButton)
        settingsButton.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(24)
            make.right.equalToSuperview().inset(24)
            make.size.equalTo(42)
        }
        view.addSubview(statusLabel)
        statusLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(settingsButton.snp.centerY)
        }
    }
    
    private func setupBindings() {
        self.viewModel?.didUpdate = { [weak self] cred in
            DispatchQueue.main.async {
                self?.countryView.configure(cred: cred)
            }
        }
        self.viewModel?.didChangeStatus = { [weak self] status in
            self?.statusLabel.text = status.title
            self?.connectView.state = status
            
            switch status {
            case .connect:
                self?.connectButton.setTitle("Disconnect", for: .normal)
                self?.connectButton.setTitleColor(Asset.mainPurple.color, for: .normal)
                self?.connectButton.setBackgroundImage(nil, for: .normal)
                self?.connectButton.backgroundColor = .clear
                self?.connectButton.layer.borderWidth = 1
                self?.connectButton.layer.borderColor = Asset.mainPurple.color.cgColor
                self?.connectButton.setTitleColor(Asset.mainPurple.color, for: .normal)
            case .disconnect:
                self?.connectButton.setTitle("Secure My Connection", for: .normal)
                self?.connectButton.setTitleColor(.white, for: .normal)
                self?.connectButton.setBackgroundImage(Asset.splashProgress.image, for: .normal)
                self?.connectButton.backgroundColor = .clear
                self?.connectButton.layer.borderWidth = 0
            case .connecting:
                self?.connectButton.setTitle("Connecting...", for: .normal)
                self?.connectButton.setTitleColor(Asset.mainPurple.color, for: .normal)
                self?.connectButton.setBackgroundImage(nil, for: .normal)
                self?.connectButton.backgroundColor = .white
                self?.connectButton.layer.borderWidth = 1
                self?.connectButton.layer.borderColor = Asset.mainLightblue.color.cgColor
                self?.connectButton.setTitleColor(Asset.mainPurple.color, for: .normal)
            case .disconnecting:
                self?.connectButton.setTitle("Disconnecting...", for: .normal)
                self?.connectButton.setTitleColor(Asset.mainPurple.color, for: .normal)
                self?.connectButton.setBackgroundImage(nil, for: .normal)
                self?.connectButton.backgroundColor = .white
                self?.connectButton.layer.borderWidth = 1
                self?.connectButton.layer.borderColor = Asset.mainLightblue.color.cgColor
                self?.connectButton.setTitleColor(Asset.mainPurple.color, for: .normal)
            }
        }
        self.viewModel?.didShowError = { [weak self] errorString in
            self?.showToast(message: errorString)
        }
        self.viewModel?.didCheckSpeed = { [weak self] (download, upload) in
            DispatchQueue.main.async {
                self?.downloadView.configure(type: .download, value: download)
                self?.uploadView.configure(type: .upload, value: upload)
            }
        }
    }
    
    @objc
    private func onDidCountryTapped() {
        self.viewModel?.countryButtonTapped()
    }
    
    @objc
    private func onDidBannerTapped() {
        self.viewModel?.bannerButtonTapped()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
