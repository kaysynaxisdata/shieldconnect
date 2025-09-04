//
//  PromoTwoViewController.swift
//  shield-connect
//
//  Created by Александр on 04.09.2025.
//

import UIKit

class CheckView: UIView {
    
    var didComplete: Completion?
    
    private lazy var iconView: UIImageView = {
        var view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    private lazy var label: UILabel = {
        var label = ViewFactory.label(
            font: UIFont.systemFont(ofSize: 16, weight: .light),
            color: .white
        )
        label.numberOfLines = 0
        return label
    }()
    
    var delay: TimeInterval
    var string: String
    var checkIcon: String
    var okIcon: String
    
    init(delay: TimeInterval, string: String, checkIcon: String, okIcon: String) {
        self.delay = delay
        self.string = string
        self.checkIcon = checkIcon
        self.okIcon = okIcon
        super.init(frame: .zero)
        common()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func common() {
        let hStack = ViewFactory.stack(.horizontal, spacing: 8)
        
        addSubview(hStack)
        hStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        iconView.snp.makeConstraints { make in
            make.width.equalTo(24)
        }
        
        hStack.addArrangedSubview(iconView)
        hStack.addArrangedSubview(label)
        
        self.iconView.sd_setImage(with: URL(string: self.checkIcon), completed: nil)
        self.label.text = self.string
    }
    
    func startChecking() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(Int(self.delay))) {
            self.iconView.sd_setImage(with: URL(string: self.okIcon), completed: nil)
            self.didComplete?()
        }
    }
    
}

class PromoTwoViewController: UIViewController, Loadable, Toastable {
    
    var viewModel: PromoTwoViewModel!
    
    private lazy var actionButton: UIButton = {
        var view = UIButton.init(type: .system)
        view.backgroundColor = UIColor.systemBlue
        view.setTitle("Continue", for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        view.setTitleColor(.white, for: .normal)
        return view
    }()
    private lazy var progressView: ProgressView = {
        var view = ProgressView()
        return view
    }()
    private lazy var progressStack: UIStackView = {
        let view = ViewFactory.stack(.vertical, spacing: 12)
        return view
    }()
    private lazy var iconView: UIImageView = {
        var view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    private lazy var statusLabel: UILabel = {
        var label = ViewFactory.label(
            font: UIFont.systemFont(ofSize: 16, weight: .light),
            color: .white
        )
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    private lazy var titleLabel: UILabel = {
        var label = ViewFactory.label(
            font: FontFamily.RedHatText.medium.font(size: 32),
            color: .white
        )
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    private lazy var stepLabel: UILabel = {
        var label = ViewFactory.label(
            font: FontFamily.RedHatText.regular.font(size: 24),
            color: Asset.mainLightgrey.color
        )
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    private lazy var subtitleLabel: UILabel = {
        var label = ViewFactory.label(
            font: FontFamily.RedHatText.regular.font(size: 20),
            color: .white
        )
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    private lazy var vStack: UIStackView = {
        var view = ViewFactory.stack(.vertical, spacing: 12)
        view.distribution = .equalSpacing
        return view
    }()
    private lazy var stepVStack: UIStackView = {
        var view = ViewFactory.stack(.vertical, spacing: 8)
        view.distribution = .equalSpacing
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupBindings()
        viewModel.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    private func setupUI() {
        let backView = UIImageView(image: UIImage(asset: Asset.splashBackground))
        backView.contentMode = .scaleAspectFill
        view.addSubview(backView)
        backView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let effect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: effect)
        view.addSubview(blurView)
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(vStack)
        vStack.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(32)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(32)
        }
        iconView.snp.makeConstraints { make in
            make.height.equalTo(140)
        }
        
        vStack.addArrangedSubview(titleLabel)
        vStack.addArrangedSubview(subtitleLabel)
        vStack.addArrangedSubview(iconView)
        vStack.addArrangedSubview(stepLabel)
        vStack.addArrangedSubview(stepVStack)
        vStack.addArrangedSubview(UIView())
        
        progressStack.addArrangedSubview(progressView)
        progressStack.addArrangedSubview(statusLabel)
        progressView.snp.makeConstraints { make in
            make.height.equalTo(6)
        }
        vStack.addArrangedSubview(progressStack)
        vStack.addArrangedSubview(actionButton)
        
        actionButton.snp.makeConstraints { make in
            make.height.equalTo(56)
        }
        actionButton.layoutIfNeeded()
        actionButton.layer.cornerRadius = actionButton.frame.height / 2
        actionButton.addAction(UIAction.init(handler: { action in
            self.viewModel?.actionButtonTapped()
        }), for: .touchUpInside)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250)) {
            self.nextStep()
        }
        
    }
    
    func setupBindings() {
        viewModel?.didLoading = { [weak self] isLoaded in
            isLoaded ? self?.startLoading() : self?.stopLoading()
        }
        viewModel?.didShowError = { [weak self] errorString in
            self?.showToast(message: errorString)
        }
    }
    
    func nextStep() {
        if self.viewModel.lines.isEmpty == false {
            let drop = self.viewModel.lines.removeFirst()
            self.setupLine(
                line: drop,
                 completion: { [weak self] in
                     self?.nextStep()
            })
        }
    }
    
    private func setupLine(line: SecurityCheckLine, completion: Completion?) {
        titleLabel.text = line.title
        subtitleLabel.text = line.subtitle
        stepLabel.text = line.stepName
        progressStack.isHidden = line.delay == nil
        self.statusLabel.text = "some seconds left..."
        self.iconView.sd_setImage(with: URL(string: line.icon))
        
        if let steps = line.steps {
            self.stepVStack.isHidden = false
            self.stepVStack.arrangedSubviews.forEach({ $0.removeFromSuperview() })
            let delay = line.delay ?? 3000
            let duration = delay / steps.count
            let v: TimeInterval = TimeInterval(duration) / 1000.0
            for (index, step) in steps.enumerated() {
                let checkView = CheckView(
                    delay: v,
                    string: step,
                    checkIcon: line.processIcon,
                    okIcon: line.checkIcon
                )
                stepVStack.addArrangedSubview(checkView)
                let d = duration * (index)
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(d)) {
                    checkView.startChecking()
                }
                
            }
            
        } else {
            self.stepVStack.isHidden = true
        }
        
        self.actionButton.isHidden = line.isPayment == false
        view.layoutIfNeeded()
        
        
//        self.progressView.didLoad = { [weak self] in
//            completion?()
//        }
        
        if let delay = line.delay {
            let seconds = Double(delay) / 1000.0
            self.progressView.start(duration: seconds)
            self.progressStack.isHidden = false
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Int(seconds))) {
                completion?()
            }
        } else {
            self.progressStack.isHidden = true
        }
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
