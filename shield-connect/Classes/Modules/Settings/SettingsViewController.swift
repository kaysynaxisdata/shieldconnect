//
//  SettingsViewController.swift
//  shield-connect
//
//  Created by Александр on 12.04.2025.
//

import UIKit

class SettingsViewController: CommonViewController {

    var viewModel: SettingsViewModel?
    
    private lazy var headerBanner: UIView = {
        var containerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 112))
        var view = BannerView()
        view.backgroundImage = Asset.settingBannerBg.image
        view.frontColor = UIColor.white
        view.configure(
            title: "Get unlimited access",
            subtitle: "Upgrade & unlock total protection",
            icon: Asset.settingCrown.image
        )
        containerView.addSubview(view)
        view.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(24)
            make.left.right.equalToSuperview().inset(24)
        }
        
        let tapRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(paywallDidTapped)
        )
        containerView.addGestureRecognizer(tapRecognizer)
        
        return containerView
    }()
    private lazy var tableView: UITableView = {
        var view = UITableView(frame: .zero, style: .grouped)
        view.register(SettingCell.self, forCellReuseIdentifier: SettingCell.identifier)
        view.register(FaceIdSettingCell.self, forCellReuseIdentifier: FaceIdSettingCell.identifier)
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .clear
        view.separatorStyle = .none
        view.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        view.separatorColor = Asset.mainGrey.color
        view.tableHeaderView = headerBanner
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        // Do any additional setup after loading the view.
    }

    private func setupUI() {
        let navigationView = NavigationView()
        navigationView.title = "Settings"
        navigationView.didBack = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        view.addSubview(navigationView)
        navigationView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(90)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(navigationView.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }
    
    @objc
    private func paywallDidTapped() {
        self.viewModel?.paywallBannerTapped()
    }

}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.groups.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let group = viewModel?.groups[section]
        return group?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let group = viewModel?.groups[indexPath.section]
        guard let item = group?.items[indexPath.row] else {
            return UITableViewCell()
        }
        
        switch item {
        case .faceId:
            if let cell = tableView.dequeueReusableCell(withIdentifier: FaceIdSettingCell.identifier) as? FaceIdSettingCell {
                cell.configure(item: item, isEnable: viewModel?.faceIdEnable ?? false)
                cell.didSwitch = { [weak self] in
                    self?.viewModel?.faceIdSwitched()
                }
                return cell
            }
        default:
            if let cell = tableView.dequeueReusableCell(withIdentifier: SettingCell.identifier) as? SettingCell {
                cell.configure(item: item)
                return cell
            }
        }

        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 14
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let group = viewModel?.groups[section]
        let view = UIView()
        let label = ViewFactory.label(
            font: FontFamily.RedHatText.medium.font(size: 10),
            color: Asset.mainAdditional.color
        )
        label.text = group?.title.uppercased()
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.bottom.right.equalToSuperview()
            make.left.equalToSuperview().inset(24)
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.didSelect(indexPath: indexPath)
    }
    
}
