import UIKit
import SnapKit

class PageControlView: UIView {

    var pages: Int
    
    private lazy var hStack: UIStackView = {
        var view = UIStackView()
        view.spacing = 24
        view.distribution = .fillEqually
        view.axis = .horizontal
        return view
    }()
    
    init(numberOfPages: Int) {
        self.pages = numberOfPages
        super.init(frame: .zero)
        common()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func common() {
        self.addSubview(hStack)
        
        hStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        for _ in 0...pages {
            let progressView = PageProgressView()
            progressView.snp.makeConstraints { make in
                make.width.equalTo(10)
            }
            hStack.addArrangedSubview(progressView)
        }
    }
    
    func configure(numberOfPages: Int) {
        self.pages = numberOfPages
        self.hStack.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        
        for _ in 1...pages {
            let progressView = PageProgressView()
            progressView.backColor = Asset.mainGrey.color
            progressView.progressColor = Asset.mainPurple.color
            progressView.snp.makeConstraints { make in
                make.width.equalTo(10)
            }
            hStack.addArrangedSubview(progressView)
        }
    }
    
    func fill(page: Int) {
        if self.hStack.arrangedSubviews.count > page {
            if let subView = hStack.arrangedSubviews[page] as? PageProgressView {
                subView.fill()
            }
        }
    }
    
    func fillWithoutAnimate(page: Int) {
        if self.hStack.arrangedSubviews.count > page {
            for index in 0...page {
                if let subView = hStack.arrangedSubviews[index] as? PageProgressView {
                    subView.fill(animated: false)
                    subView.layoutIfNeeded()
                }
            }

        }
    }
    
    func unfill(page: Int) {
        if self.hStack.arrangedSubviews.count > page {
            if let subView = hStack.arrangedSubviews[page] as? PageProgressView {
                subView.unfill()
            }
        }
    }

}

class PageProgressView: UIView {
    
    private lazy var backView: UIView = {
        var view = UIView()
        return view
    }()
    private lazy var progressView: UIView = {
        var view = UIView()
        view.isHidden = true
        return view
    }()
    
    var backColor: UIColor = .gray {
        didSet {
            self.backView.backgroundColor = self.backColor
        }
    }
    var progressColor: UIColor = .blue {
        didSet {
            self.progressView.backgroundColor = self.progressColor
        }
    }
    
    init() {
        super.init(frame: .zero)
        common()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.backView.layoutIfNeeded()
        self.progressView.layoutIfNeeded()
        self.progressView.layer.cornerRadius = self.progressView.frame.height / 2
        self.backView.layer.cornerRadius = self.backView.frame.height / 2
    }
    
    
    private func common() {
        let containerView = UIView()
        
        self.addSubview(containerView)
        containerView.addSubview(backView)
        containerView.addSubview(progressView)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        backView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        progressView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}

extension PageProgressView {
    
    func fill(animated: Bool = true) {
        self.progressView.isHidden = false
    }
    
    func unfill() {
        self.progressView.isHidden = true
    }
    
}

