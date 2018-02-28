//
//  ViewController.swift
//  goingReactive
//
//  Created by Juanjo García Villaescusa on 24/2/18.
//  Copyright © 2018 Juanjo García Villaescusa. All rights reserved.
//

import RxSwift
import UIKit
import SnapKit

class BicingStationsViiewController: UIViewController {
    
    let viewModel: BicingStationsViewModel
    
    // MARK: UI
    
    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(didRefresh), for: UIControlEvents.valueChanged)
        return control
    }()
    
    private lazy var spinner: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        view.addSubview(indicator)
        indicator.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
        }
        return indicator
    }()
    
    private lazy var searchController: UISearchController = {
        let searchVC = UISearchController(searchResultsController: nil)
        searchVC.searchResultsUpdater = self
        searchVC.obscuresBackgroundDuringPresentation = false
        searchVC.searchBar.placeholder = "Search Stations"
        return searchVC
    }()
    
    private lazy var stationsTable: UITableView = {
       let table = UITableView()
        table.refreshControl = refreshControl
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.insertSubview(table, belowSubview: spinner)
        table.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        return table
    }()
    
    let disposeBag = DisposeBag()
    
    // MARK: Lifecycle
    
    init(viewModel: BicingStationsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK
    
    @objc func didRefresh(sender: UIRefreshControl) {
        viewModel.loadAllStations()
        sender.endRefreshing()
    }
    
    // MARK: UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setObservers()
        viewModel.loadAllStations()
        spinner.startAnimating()
    }
    
    // MARK: Private

    private func configureUI() {
        title = "Bicing Stations"
        navigationItem.searchController = searchController
    }
    
    private func setObservers() {
        viewModel.stations
            .asObservable()
            .subscribe(onNext: { [unowned self] stations in
                guard let _ = stations else { return }
                self.spinner.stopAnimating()
                self.stationsTable.reloadData()
            })
            .disposed(by: disposeBag)
        viewModel.error
            .asObservable()
            .subscribe(onNext: { [unowned self] error in
                guard let error = error else { return }
                self.spinner.stopAnimating()
                self.display(error: error)
            })
            .disposed(by: disposeBag)
    }
}

extension BicingStationsViiewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.stations.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let station = viewModel.stations.value![indexPath.row]
        cell.textLabel?.text = station.address
        return cell
    }
}

extension BicingStationsViiewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.findStations(token: searchController.searchBar.text ?? "")
        spinner.startAnimating()
    }
}
