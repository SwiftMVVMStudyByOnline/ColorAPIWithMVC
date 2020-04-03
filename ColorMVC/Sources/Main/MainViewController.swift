//
//  ViewController.swift
//  Remove
//
//  Created by Seokho on 2020/03/09.
//  Copyright © 2020 Seokho. All rights reserved.
//

import UIKit


enum Cell {
    static let colorCell = String(describing: ColorCell.self)
}

class MainViewController: UIViewController {
    
    weak var tableView: UITableView?
    weak var indicator: UIActivityIndicatorView?
    weak var toolBar: MainToolBar!
    
    var data = [Color]()
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = ColorLists.background
        self.view = view
        
        let toolbar = MainToolBar()
        self.toolBar = toolbar
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toolbar)
        NSLayoutConstraint.activate([
            toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolbar.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        toolbar.favoriteButton?.addTarget(self, action: #selector(self.filterFavorite), for: .touchUpInside)
        toolbar.refreshButton?.addTarget(self, action: #selector(self.reloadData), for: .touchUpInside)
        
        let topAnchor = toolbar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -44)
        topAnchor.priority = .defaultHigh
        topAnchor.isActive = true
        
        let tableView = UITableView()
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView = tableView
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: toolbar.topAnchor),
            tableView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            tableView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
        tableView.register(ColorCell.self, forCellReuseIdentifier: Cell.colorCell)
        tableView.dataSource = self
        tableView.delegate = self
        
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.color = .white
        indicator.backgroundColor = UIColor(white: 0.3, alpha: 0.8)
        indicator.layer.cornerRadius = 10
        indicator.clipsToBounds = true
        self.indicator = indicator
        view.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            indicator.widthAnchor.constraint(equalToConstant: 60),
            indicator.heightAnchor.constraint(equalToConstant: 60),
            indicator.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    override func viewDidLoad() {
        self.navigationItem.title  = "색상 목록"
        self.indicator?.startAnimating()
        self.fetchColor()
    }
    
    private func fetchColor(_ isFavorite: Bool = false) {
        let networkService = NetworkService()
        networkService.fetchColors { [weak self] result in
            DispatchQueue.main.async {
                 self?.indicator?.stopAnimating()
            }
            switch result {
            case .success(let data):
                if isFavorite {
                    self?.data = data.filter { $0.isFavorite }
                } else {
                    self?.data = data
                }
              
                DispatchQueue.main.async {
                    self?.toolBar.favoriteButton?.isSelected = isFavorite
                    self?.tableView?.reloadData()
                }
            case .failure(let error):
                let alertViewController = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
                alertViewController.addAction(UIAlertAction(title: "확인", style: .default))
                self?.present(alertViewController, animated: true)
            }
        }
    }
    
    @objc
    private func filterFavorite() {
        DispatchQueue.main.async {
             self.indicator?.startAnimating()
        }
        self.fetchColor(!self.toolBar.favoriteButton!.isSelected)
    }
    
    @objc
    private func reloadData() {
        DispatchQueue.main.async {
             self.indicator?.startAnimating()
        }
        self.fetchColor()
    }
}
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.colorCell, for: indexPath) as? ColorCell else  {
            fatalError()
         }
        cell.inputData(self.data[indexPath.row])
        return cell
    }
    
    
}
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath) as? ColorCell {
            print(cell.previewColor?.backgroundColor ?? "")
            print(cell.titleLabel?.text ?? "")
            print(cell.hexCodeLabel?.text ?? "")
        }
    }
}

