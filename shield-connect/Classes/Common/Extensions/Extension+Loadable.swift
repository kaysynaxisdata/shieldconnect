import Foundation
import UIKit
import NVActivityIndicatorView
import NVActivityIndicatorViewExtended
import SnapKit

class LoaderView: UIView {
    
    init() {
        super.init(frame: .zero)
        common()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func common() {
        let backView = UIView()
        backView.backgroundColor = .black.withAlphaComponent(0.5)
        self.addSubview(backView)
        backView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        let activityIndicatorView = NVActivityIndicatorView(
            frame: CGRect(x: 0, y: 0, width: 50, height: 50),
            type: .circleStrokeSpin,
            color: .white
        )
        activityIndicatorView.startAnimating()
        self.addSubview(activityIndicatorView)
        activityIndicatorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
}

protocol Loadable {
    func startLoading()
    func stopLoading()
    
    func startLocalLoading()
    func stopLocalLoading()
    
    func showActivity()
    func hideActivity()
}

extension Loadable where Self: UIViewController {
    
    func startLoading() {
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData(type: .ballScaleMultiple), NVActivityIndicatorView.DEFAULT_FADE_IN_ANIMATION)
    }
    
    func stopLoading() {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(NVActivityIndicatorView.DEFAULT_FADE_OUT_ANIMATION)
    }
    
    func startLocalLoading() {
        var activityIndicatorView = LoaderView()
        activityIndicatorView.tag = 900
        view.addSubview(activityIndicatorView)
        activityIndicatorView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

    }
    
    func stopLocalLoading() {
        for subview in self.view.subviews {
            if subview.tag == 900 {
                subview.removeFromSuperview()
            }
        }
    }
    
    
    func showActivity() {
        let activityView = UIActivityIndicatorView()
        activityView.startAnimating()
        activityView.tag = 999
        activityView.style = .medium
        self.view.addSubview(activityView)
        activityView.snp.makeConstraints({ make in
            make.center.equalToSuperview()
        })
    }
    
    func hideActivity() {
        for subview in self.view.subviews {
            if subview.tag == 999 {
                subview.removeFromSuperview()
            }
        }
    }
}
