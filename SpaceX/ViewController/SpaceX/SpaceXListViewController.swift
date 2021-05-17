//
//  SpaceXListViewController.swift
//  SpaceX
//
//  Created by Aurelien Cobb on 10/05/2021.
//

import UIKit

class SpaceXListViewController: UIViewController {
    
    let viewModel: SpaceXListViewModel
    
    var dataSource: UITableViewDiffableDataSource<String, SpaceXListItem>!
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    init(viewModel: SpaceXListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let filterButton = UIBarButtonItem(image: UIImage(systemName: "speaker.fill"), style: .plain, target: self, action: #selector(filterTapped))
        navigationItem.setRightBarButtonItems([filterButton], animated: false)
        
        setupView()
        setupDataSource()
        viewModel.fetchData()
    }
}

extension SpaceXListViewController: SpaceXListViewDelegate {
    
    func didReceive(viewState: SpaceXListViewModel.ViewState) {
        switch viewState {
        case .loading:
            print("Loading")
        case let .updated(listData):
            // setting animations to true gives autolayout errors in the console
            dataSource?.apply(listData.snapshot, animatingDifferences: false)
        case let .error(error):
            print("Error", error)
        }
    }
}

extension SpaceXListViewController {
    
    func setupDataSource() {
        dataSource = UITableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: { [weak self] tableView, indexPath, item in
                switch item {
                case let .info(text):
                    return self?.infoCell(tableView: tableView, indexPath: indexPath, text: text)
                case let .launch(launch):
                    return self?.launchCell(tableView: tableView, indexPath: indexPath, launch: launch)
                }
        })
        dataSource.defaultRowAnimation = .none
    }
    
    func setupView() {
        title = "title".localized
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.register(withClass: LaunchCell.self)
        tableView.register(withClass: CompanyInfoCell.self)
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func infoCell(tableView: UITableView, indexPath: IndexPath, text: String) -> CompanyInfoCell {
        tableView.dequeueReusableCell(for: indexPath) {
            $0.configure(with: text)
        }
    }
    
    func launchCell(tableView: UITableView, indexPath: IndexPath, launch: Launch) -> LaunchCell {
        tableView.dequeueReusableCell(for: indexPath) { [weak self] cell in
            guard let self = self else { return }
            cell.configure(with: launch,
                           dateProvider: self.viewModel.environment.date,
                           dateFormatter: self.viewModel.environment.dateFormater)
            guard let missionImageLink = launch.links.missionPatchSmall else { return }
            self.viewModel.fetchImage(from: missionImageLink) {
                cell.configure(withImage: $0)
            }
        }
    }
}

// MARK: - Target Action
extension SpaceXListViewController {
    
    @objc func filterTapped() {
        viewModel.showFilter()
    }
}

extension SpaceXListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.9)
        let label = UILabel()
        view.addSubview(label)
        label.frame = CGRect(x: 20, y: 3, width: UIScreen.main.bounds.width, height: 20)
        switch section {
        case 0:
            label.text = "Company".localized
        case 1:
            label.text = "Launches".localized
        default:
            break
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedItem = dataSource.itemIdentifier(for: indexPath) else { return }
        switch selectedItem {
        case let .launch(launch):
            viewModel.select(launch: launch)
        case .info:
            break
        }
    }
}

extension ListData {
    var snapshot: NSDiffableDataSourceSnapshot<String, SpaceXListItem> {
        var snapshot = NSDiffableDataSourceSnapshot<String, SpaceXListItem>()
        if let companyInfo = companyInfo {
            snapshot.appendSections([companyInfo.title])
            snapshot.appendItems(companyInfo.items, toSection: companyInfo.title)
        }
        if let launches = launches {
            snapshot.appendSections([launches.title])
            snapshot.appendItems(launches.items, toSection: launches.title)
        }
        return snapshot
    }
}
