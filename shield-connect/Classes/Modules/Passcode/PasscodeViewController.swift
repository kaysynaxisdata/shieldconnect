//
//  PasscodeViewController.swift
//  shield-connect
//
//  Created by Александр on 11.04.2025.
//

import UIKit

class CommonViewController: UIViewController, Toastable {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        let backView = UIImageView(image: Asset.backgroundEffects.image)
        backView.contentMode = .scaleAspectFill
        self.view.addSubview(backView)
        backView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}

class PasscodeViewController: CommonViewController {

    var viewModel: PasscodeViewModel?
    
    private lazy var pageControl: PageControlView = {
        var control = PageControlView(numberOfPages: PasscodeViewModel.numberOfPins)
        control.configure(numberOfPages: PasscodeViewModel.numberOfPins)
        return control
    }()
    private lazy var titleLabel: UILabel = {
        let label = ViewFactory.label(
            font: FontFamily.RedHatDisplay.semiBold.font(size: 24),
            color: .black
        )
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupBindings()
        viewModel?.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    private func setupUI() {
        let passcodeKeyboardView = PasscodeNumberView()
        passcodeKeyboardView.didTapKey = { [weak self] key in
            self?.viewModel?.keyButtonTapped(key: key)
        }
        view.addSubview(passcodeKeyboardView)
        passcodeKeyboardView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
        if self.viewModel?.state == .enter {
            let faceIdButton = UIButton(type: .system)
            faceIdButton.addAction(UIAction(handler: { [weak self] action in
                self?.viewModel?.faceIDDidTap()
            }), for: .touchUpInside)
            faceIdButton.setTitle("Use Face ID", for: .normal)
            faceIdButton.titleLabel?.font = FontFamily.RedHatDisplay.semiBold.font(size: 16)
            faceIdButton.setTitleColor(Asset.mainAdditional.color, for: .normal)
            view.addSubview(faceIdButton)
            faceIdButton.snp.makeConstraints { make in
                make.top.equalTo(passcodeKeyboardView.snp.bottom).inset(-24)
                make.centerX.equalToSuperview()
            }
        }
        
        view.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.bottom.equalTo(passcodeKeyboardView.snp.top).inset(-44)
            make.centerX.equalToSuperview()
            make.height.equalTo(10)
        }
        
        view.addSubview(titleLabel)
        titleLabel.text = "Enter code"
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(pageControl.snp.bottom).inset(40)
            make.centerX.equalToSuperview()
        }
        
    }
    
    private func setupBindings() {
        self.viewModel?.didUpdateUI = { [weak self] in
            self?.titleLabel.text = self?.viewModel?.state.title
            if let inputNumberCount = self?.viewModel?.inputNumberCount {
                self?.pageControl.fill(page: inputNumberCount - 1)
            } else {
                self?.pageControl.unfill(page: 0)
                self?.pageControl.unfill(page: 1)
                self?.pageControl.unfill(page: 2)
                self?.pageControl.unfill(page: 3)
            }
        }
        self.viewModel?.didShowAlert = { [weak self] message in
            self?.showToast(message: message)
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
