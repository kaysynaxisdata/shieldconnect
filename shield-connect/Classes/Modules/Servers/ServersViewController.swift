//
//  ServersViewController.swift
//  shield-connect
//
//  Created by Александр on 12.04.2025.
//

import UIKit

class NavigationView: UIView {
    
    var didBack: Completion?
    var title: String = "" {
        didSet {
            self.titleLabel.text = self.title
        }
    }
    
    private lazy var titleLabel: UILabel = {
        var label = ViewFactory.label(
            font: FontFamily.RedHatText.medium.font(size: 24),
            color: Asset.mainAdditional.color
        )
        label.textAlignment = .center
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
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(60)
            make.centerY.equalToSuperview()
        }
        
        let backButton = UIButton(type: .system)
        backButton.setImage(Asset.back.image, for: .normal)
        backButton.tintColor = Asset.navigationBack.color
        backButton.addAction(UIAction(handler: { action in
            self.didBack?()
        }), for: .touchUpInside)
        addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(72)
        }
    }
    
}

class ServersViewController: CommonViewController {

    var viewModel: ServersViewModel?
    
    private lazy var tableView: UITableView = {
        var view = UITableView(frame: .zero, style: .plain)
        view.register(ServerCell.self, forCellReuseIdentifier: ServerCell.identifier)
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .clear
        view.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        view.separatorColor = Asset.mainGrey.color
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        // Do any additional setup after loading the view.
    }

    private func setupUI() {
        let navigationView = NavigationView()
        navigationView.title = "Servers"
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

}

extension ServersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.servers.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = self.viewModel?.servers[indexPath.row] else {
            return UITableViewCell()
        }
        if let cell = tableView.dequeueReusableCell(withIdentifier: ServerCell.identifier) as? ServerCell {
            let isSelected = item.id == self.viewModel?.selectServer
            cell.configure(server: item, isSelected: isSelected)
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = self.viewModel?.servers[indexPath.row] else {
            return
        }
        
        self.viewModel?.didSelectServer(id: item.id)
        self.tableView.reloadData()
    }
    
}
