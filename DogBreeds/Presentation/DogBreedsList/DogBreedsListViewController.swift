//
//  DogBreedsListViewController.swift
//  DogBreeds
//
//  Created by Denis Zhukoborskiy on 02.03.2022.
//

import UIKit

enum DogBreedsViewControllerSection {
    case main
}

final class DogBreedsListViewController: UITableViewController {
    
    private typealias DataSource = UITableViewDiffableDataSource<DogBreedsViewControllerSection, String>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<DogBreedsViewControllerSection, String>
    
    private static let cellIdentifier = BreedNameViewCell.reuseIdentifier
    private lazy var dataSource = makeDataSource()
    private var breedNames = [String]()
    
    private let breedsService: BreedsService
    
    static func make(breedsService: BreedsService) -> UIViewController {
        let navigationController = UINavigationController(rootViewController: Self(breedsService: breedsService))
        navigationController.navigationBar.prefersLargeTitles = true
        return navigationController
    }
    
    private init(breedsService: BreedsService) {
        self.breedsService = breedsService
        super.init(nibName: nil, bundle: nil)
        tabBarItem.image = .init(systemName: "list.dash")
        title = "Breeds List"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var navigationItem: UINavigationItem {
        let item = super.navigationItem
        item.largeTitleDisplayMode = .always
        return item
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        getBreedsList()
        view.backgroundColor = .black
    }
    
    private func getBreedsList() {
        breedsService.breedsList { [weak self] result in
            switch result {
            case .success(let breedsList):
                self?.applySnapshot(breedNames: breedsList.breeds)
            default:
                break
            }
        }
    }
    
    private func getBreedImages(breedName: String) {
        
        breedsService.breedImages(breed: breedName) { [weak self] result in
            
            switch result {
            case .success(let breedImages):
                self?.pushImagesVc(breed: breedName, breedImages: breedImages)
            default:
                break
            }
        }
    }
    
    private func pushImagesVc(breed: String, breedImages: BreedImagesEndpointResponse) {
        let vc = BreedImagesContainerViewController(breed: breed, breedImages: breedImages)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - TableView related code
extension DogBreedsListViewController {
    private func setupTableView() {
        applySnapshot(breedNames: breedNames)
        tableView.register(BreedNameViewCell.self, forCellReuseIdentifier: Self.cellIdentifier)
    }
    
    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(tableView: tableView) { (tableView, indexPath, breed) in
            let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellIdentifier, for: indexPath)
            (cell as? BreedNameViewCell)?.configure(breedName: breed)
            return cell
        }
        
        return dataSource
    }
    
    func applySnapshot(breedNames: [String], animatingDifferences: Bool = true) {
        self.breedNames = breedNames
        var snapshot = Snapshot()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(breedNames)
        
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

// MARK: - UITableViewDelegate
extension DogBreedsListViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        getBreedImages(breedName: breedNames[indexPath.row])
    }
}
