//
//  ReactiveBicingViewController.swift
//  goingReactive
//
//  Created by Juanjo García Villaescusa on 28/2/18.
//  Copyright © 2018 Juanjo García Villaescusa. All rights reserved.
//

import RxSwift
import RxCocoa

final class ReactiveBicingViewController: UIViewController {
    
    var viewModel: ReactiveBicingViewModel!
    
    private let refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
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
    
    private let searchController: UISearchController = {
        let searchVC = UISearchController(searchResultsController: nil)
        searchVC.obscuresBackgroundDuringPresentation = false
        searchVC.searchBar.placeholder = "Search Stations"
        return searchVC
    }()
    
    private lazy var stationsTable: UITableView = {
        let table = UITableView()
        table.refreshControl = refreshControl
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.insertSubview(table, belowSubview: spinner)
        table.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        return table
    }()
    
    private let disposeBag = DisposeBag()
    
    init(allResource: URLResource<[BicingStation]>, gateway: ReactiveGateway) {
        let refreshDriver = refreshControl.rx.controlEvent(.valueChanged).asDriver()
        let searchDriver = searchController.searchBar.rx.text.orEmpty.asDriver()
        self.viewModel = ReactiveBicingViewModel(allResource: allResource, gateway: gateway, refreshDriver: refreshDriver, searchDriver: searchDriver)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setObservers()
    }
    
    private func configureUI() {
        title = "Bicing Stations"
        navigationItem.searchController = searchController
    }
    
    private func setObservers() {
        // table
        viewModel.stations
            .drive(stationsTable.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) {
                index, station, cell in
                cell.textLabel?.text  = station.address
            }
            .disposed(by: disposeBag)
        // spiner
        viewModel.isLoading
            .drive(spinner.rx.isAnimating)
            .disposed(by: disposeBag)
        // errors
        viewModel.error
            .asObservable()
            .subscribe(onNext: { [unowned self] error in
                self.display(error: error)
            })
            .disposed(by: disposeBag)
    }
}
