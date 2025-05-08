//
//  PaywallViewController.swift
//  shield-connect
//
//  Created by Александр on 12.04.2025.
//

import UIKit

class PaywallOptionView: UIView {
    
    enum PaywallOption: CaseIterable {
        case faster
        case ghost
        case noThrottling
        case checkTool
        case support
        case encryption
        case noads
        
        var title: String {
            switch self {
            case .faster:
                return "Fastest servers without limits"
            case .ghost:
                return "GhostMode, SafeBrowsing & Encrypted Wi-Fi protection"
            case .noThrottling:
                return "No more throttling: unrestricted bandwidth, fast&secure browsing"
            case .checkTool:
                return "Built-in speed check tool"
            case .support:
                return "Dedicated support"
            case .encryption:
                return "Advanced encryption"
            case .noads:
                return "No ads"
            }
        }
        var prefix: String {
            switch self {
            case .faster:
                return "🚀"
            case .ghost:
                return "👑"
            case .noThrottling:
                return "⚡"
            case .checkTool:
                return "️⏱️"
            case .support:
                return "💌"
            case .encryption:
                return "🦄"
            case .noads:
                return "🚫"
            }
        }
    }
    
    private lazy var prefixLabel: UILabel = {
        var label = ViewFactory.label(
            font: FontFamily.RedHatText.semiBold.font(size: 20),
            color: .black
        )
        label.adjustsFontSizeToFitWidth = true
        label.snp.makeConstraints { make in
            make.width.equalTo(20)
        }
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        var label = ViewFactory.label(
            font: FontFamily.RedHatText.medium.font(size: 16),
            color: Asset.mainText.color
        )
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        label.numberOfLines = 2
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        let hStack = ViewFactory.stack(.horizontal, spacing: 16)
        addSubview(hStack)
        hStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        hStack.addArrangedSubview(prefixLabel)
        hStack.addArrangedSubview(titleLabel)
    }
    
    func configure(prefix: String, title: String) {
        self.prefixLabel.text = prefix
        self.titleLabel.text = title
    }
    
}

final class PaywallViewController: UIViewController, Loadable, Toastable {

    var viewModel: PaywallViewModel?
    
    private var productButtons: [ProductView] = []
    private lazy var titleLabel: UILabel = {
        var label = ViewFactory.label(
            font: FontFamily.RedHatDisplay.bold.font(size: 40),
            color: Asset.mainText.color
        )
        label.text = "Unlock\nFull Protection"
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    private lazy var subtitleLabel: UILabel = {
        var label = ViewFactory.label(
            font: FontFamily.RedHatDisplay.light.font(size: 16),
            color: Asset.mainAdditional.color
        )
        label.text = "Get unlimited access to all premium features and secure your online presence with ease"
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = Asset.mainBgblack.color
        button.setTitle("Get Premium", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = FontFamily.RedHatText.semiBold.font(size: 20)
        button.snp.makeConstraints { make in
            make.height.equalTo(56)
        }
        button.addAction(UIAction(handler: { action in
            self.viewModel?.payTapped()
        }), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.actionButton.layoutIfNeeded()
        self.actionButton.layer.cornerRadius = self.actionButton.frame.height / 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupBindings()
        viewModel?.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    private func setupUI() {
        let backView = UIImageView(image: Asset.paywallBg.image)
        view.addSubview(backView)
        backView.contentMode = .scaleAspectFill
        backView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let vStack = ViewFactory.stack(.vertical, spacing: 8)
        view.addSubview(vStack)
        vStack.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(32)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(4)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(12)
        }
        
        let bottomView = ViewFactory.stack(.vertical, spacing: 6)
        let descriptionLabel = ViewFactory.label(
            font: FontFamily.RedHatText.regular.font(size: 14),
            color: Asset.mainAdditional.color
        )
        descriptionLabel.text = "No commitment. Cancel anytime"
        descriptionLabel.textAlignment = .center
        
        let containerControls = UIView()
        let bottomControls = ViewFactory.stack(.horizontal, spacing: 8)
        containerControls.addSubview(bottomControls)
        bottomControls.snp.makeConstraints { make in
            make.height.equalTo(12)
        }
        bottomControls.snp.makeConstraints { make in
            make.top.bottom.centerX.equalToSuperview()
        }
        
        bottomView.addArrangedSubview(descriptionLabel)
        bottomView.addArrangedSubview(containerControls)
        
        let privacy = UIButton(type: .system)
        privacy.titleLabel?.font = FontFamily.RedHatText.regular.font(size: 12)
        privacy.setTitleColor(Asset.mainAdditional.color, for: .normal)
        privacy.addAction(UIAction(handler: { _ in
            if let url = URL(string: Constants.URLs.privacy) {
                UIApplication.shared.open(url)
            }
        }), for: .touchUpInside)
        privacy.setTitle("Privacy policy", for: .normal)
        
        let restore = UIButton(type: .system)
        restore.titleLabel?.font = FontFamily.RedHatText.regular.font(size: 12)
        restore.setTitleColor(Asset.mainAdditional.color, for: .normal)
        restore.addAction(UIAction(handler: { [weak self] _ in
            self?.viewModel?.restore()
        }), for: .touchUpInside)
        restore.setTitle("Restore purchase", for: .normal)
        
        let terms = UIButton(type: .system)
        terms.titleLabel?.font = FontFamily.RedHatText.regular.font(size: 12)
        terms.setTitleColor(Asset.mainAdditional.color, for: .normal)
        terms.addAction(UIAction(handler: { _ in
            if let url = URL(string: Constants.URLs.terms) {
                UIApplication.shared.open(url)
            }
        }), for: .touchUpInside)
        terms.setTitle("Terms of use", for: .normal)
        
        let divider = UIView()
        divider.backgroundColor = Asset.mainAdditional.color
        divider.snp.makeConstraints { make in
            make.width.equalTo(1)
        }
        
        let divider2 = UIView()
        divider2.backgroundColor = Asset.mainAdditional.color
        divider2.snp.makeConstraints { make in
            make.width.equalTo(1)
        }
        
        bottomControls.addArrangedSubview(privacy)
        bottomControls.addArrangedSubview(divider)
        bottomControls.addArrangedSubview(restore)
        bottomControls.addArrangedSubview(divider2)
        bottomControls.addArrangedSubview(terms)
        
        let productContainerView = ViewFactory.stack(.horizontal, spacing: 20)
        productContainerView.distribution = .fillEqually
        
        if let dipslayProducts = self.viewModel?.dipslayProducts {
            dipslayProducts.forEach { product in
                let productView = ProductView(product: product)
                let tapRecognizer = UITapGestureRecognizer(
                    target: self,
                    action: #selector(onDidProductTapped(recognizer:))
                )
                productView.addGestureRecognizer(tapRecognizer)
                productButtons.append(productView)
                if let sPrice = product.salePrice {
                    let saleView = SaleView()
                    productView.addSubview(saleView)
                    saleView.snp.makeConstraints { make in
                        make.centerX.equalToSuperview()
                        make.centerY.equalTo(productView.snp.top).offset(10)
                    }
                    saleView.configure(text: "SAVE 50%")
                }
                productContainerView.addArrangedSubview(productView)
            }
        }
        
//        let product1 = ProductView()
//        product1.isSelected = false
//        let product2 = ProductView()
//        product2.isSelected = true

        
        productContainerView.snp.makeConstraints { make in
            make.height.equalTo(140)
        }
        
        let optionScrollView = UIScrollView()
        optionScrollView.showsVerticalScrollIndicator = false
        let optionStackView = ViewFactory.stack(.vertical, spacing: 16)
        PaywallOptionView.PaywallOption.allCases.forEach { option in
            let view = PaywallOptionView()
            view.configure(prefix: option.prefix, title: option.title)
            optionStackView.addArrangedSubview(view)
        }
        optionScrollView.addSubview(optionStackView)
        optionStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(optionScrollView.snp.width)
        }
        
        vStack.addArrangedSubview(titleLabel)
        vStack.addArrangedSubview(subtitleLabel)
        vStack.setCustomSpacing(24, after: subtitleLabel)
        vStack.addArrangedSubview(optionScrollView)
        vStack.addArrangedSubview(UIView())
        if let dipslayProducts = self.viewModel?.dipslayProducts, dipslayProducts.count > 0 {
            vStack.addArrangedSubview(productContainerView)
        }
        vStack.addArrangedSubview(actionButton)
        vStack.addArrangedSubview(bottomView)
        
        let dismissButton = UIButton(type: .custom)
        dismissButton.setImage(Asset.paywallClose.image, for: .normal)
        view.addSubview(dismissButton)
        dismissButton.addAction(UIAction(handler: { [weak self] action in
            self?.dismiss(animated: true)
        }), for: .touchUpInside)
        dismissButton.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.size.equalTo(72)
        }
    }
    
    func setupBindings() {
        viewModel?.didUpdateUI = {  [weak self] in
            self?.productButtons.forEach({ pView in
                pView.isSelected = pView.product.id == self?.viewModel?.currentProduct?.id
            })
        }
        viewModel?.didLoading = { [weak self] isLoaded in
            isLoaded ? self?.startLoading() : self?.stopLoading()
        }
        viewModel?.didShowError = { [weak self] errorString in
            self?.showToast(message: errorString)
        }
        viewModel?.didDismiss = { [weak self] in
            DispatchQueue.main.async {
                self?.dismiss(animated: true)
            }
        }
    }
    
    @objc
    private func onDidProductTapped(recognizer: UITapGestureRecognizer) {
        guard let view = recognizer.view as? ProductView else {
            return
        }
        
        self.viewModel?.selectProductTapped(productId: view.product.id)
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
