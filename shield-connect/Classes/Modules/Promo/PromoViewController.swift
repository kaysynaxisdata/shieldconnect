//
//  PromoViewController.swift
//  shield-connect
//
//  Created by Александр on 22.08.2025.
//

import UIKit

class StepView: UIView {
    
    private lazy var hStack: UIStackView = {
        var stack = ViewFactory.stack(.vertical, spacing: 4)
        return stack
    }()
    private lazy var stepLabel: UILabel = {
        var label = ViewFactory.label(
            font: UIFont.systemFont(ofSize: 14, weight: .bold),
            color: Asset.promoDark.color
        )
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return label
    }()
    private lazy var contentLabel: UILabel = {
        var label = ViewFactory.label(
            font: UIFont.systemFont(ofSize: 14, weight: .regular),
            color: Asset.promoDark.color
        )
        label.numberOfLines = 0
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
        let containerView = UIView()
        
        addSubview(hStack)
        hStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        hStack.addArrangedSubview(stepLabel)
        hStack.addArrangedSubview(contentLabel)
    }
    
    func configure(step: String, content: String) {
        self.stepLabel.text = step
        self.contentLabel.text = content
    }
    
}

class PromoView: UIView {
    
    var didAction: Completion?
    
    private lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = Asset.promoDark.color
        var stack = ViewFactory.stack(.horizontal, spacing: 8)
        let iconView = UIImageView(image: Asset.promoLogo.image)
        let label = ViewFactory.label(font: UIFont.systemFont(ofSize: 17, weight: .semibold), color: .white)
        label.text = "Apple Security"
        stack.addArrangedSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.width.equalTo(16)
        }
        stack.addArrangedSubview(label)
        view.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(12)
            make.left.right.equalToSuperview().inset(16)
        }
        return view
    }()
    private lazy var titleLabel: UILabel = {
        var label = ViewFactory.label(
            font: UIFont.systemFont(ofSize: 17, weight: .semibold),
            color: Asset.promoDark.color
        )
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    private lazy var subtitleLabel: UILabel = {
        var label = ViewFactory.label(
            font: UIFont.systemFont(ofSize: 12, weight: .regular),
            color: Asset.promoDark.color
        )
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private lazy var descriptionLabel: UILabel = {
        var label = ViewFactory.label(
            font: UIFont.systemFont(ofSize: 14, weight: .regular),
            color: Asset.promoDark.color
        )
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private lazy var actionButton: UIButton = {
        var button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.didAction?()
        }), for: .touchUpInside)
        return button
    }()
    private lazy var stepsVStack: UIStackView = {
        var view = ViewFactory.stack(.vertical, spacing: 8)
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        common()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func common() {
        let containerView = UIView()
        containerView.backgroundColor = Asset.promoBackground.color.withAlphaComponent(0.94)
        containerView.layer.cornerRadius = 14
        containerView.layer.masksToBounds = true
        
        let vStack = ViewFactory.stack(.vertical, spacing: 20)
        
        vStack.addArrangedSubview(titleLabel)
        vStack.addArrangedSubview(subtitleLabel)
        vStack.addArrangedSubview(descriptionLabel)
        vStack.addArrangedSubview(stepsVStack)
        
        let spacerViewContainer = UIView()
        let spacerView = UIView()
        spacerView.backgroundColor = Asset.promoSpacer.color.withAlphaComponent(0.2)
        spacerViewContainer.addSubview(spacerView)
        spacerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
            make.top.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
        vStack.addArrangedSubview(spacerViewContainer)
        vStack.setCustomSpacing(0, after: spacerViewContainer)
        vStack.addArrangedSubview(actionButton)
        
        addSubview(containerView)
        containerView.addSubview(topView)
        containerView.addSubview(vStack)
        
        topView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
        }
        actionButton.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        vStack.snp.makeConstraints { make in
            make.top.equalTo(self.topView.snp.bottom).inset(-16)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
    }
    
    func configure(model: PromoResponse) {
        self.titleLabel.text = model.promo_struct.title
        self.subtitleLabel.text = model.promo_struct.subtitle
        self.descriptionLabel.text = model.promo_struct.bottomText
        self.actionButton.setTitle(model.callToAction, for: .normal)
        
        self.stepsVStack.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        model.promo_struct.steps.forEach { (key, step) in
            let stepView = StepView()
            stepView.configure(step: step.subStep1, content: step.subStep2)
            self.stepsVStack.addArrangedSubview(stepView)
        }
    }
    
}

class PromoViewController: UIViewController, Loadable, Toastable {

    var viewModel: PromoViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupBindings()
        viewModel.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    private func setupUI() {
        self.view.backgroundColor = Asset.promoShadow.color.withAlphaComponent(0.7)

        let promoView = PromoView()
        view.addSubview(promoView)
        promoView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        promoView.configure(model: self.viewModel.promo)
        promoView.didAction = { [weak self] in
            self?.viewModel.actionButtonTapped()
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

}
