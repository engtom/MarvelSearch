//
//  CharacterListVC.swift
//  MarvelSearch
//
//  Created by Everton Gonçalves on 01/11/20.
//

import UIKit

enum SectionType: CaseIterable {
    case main
}

class CharactersListVC: UIViewController {

    var transition: CardToDetailTransition?
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        return searchController
    }()
    
    lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        
        return collectionView
    }()
    
    lazy var dataSource: UICollectionViewDiffableDataSource<SectionType, CharactersListViewModelItem> = {
        let dataSource = UICollectionViewDiffableDataSource<SectionType, CharactersListViewModelItem>(collectionView: self.collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CharacterCell
            
            cell.item = item
            
            return cell
            
        }
        
        return dataSource
    }()
    
    var safeArea: UILayoutGuide!
    
    var viewModel: CharactersListViewModel
    
    init(viewModel: CharactersListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupBindings()
        
        viewModel.search(name: "", clean: true)
    }
    
    func setupViews(){
        safeArea = view.layoutMarginsGuide
        
        title = viewModel.title
        view.backgroundColor = .systemBackground
        
        setupNavigationBar()
        setupCollectionView()
    }
    
    func setupNavigationBar(){
        title = viewModel.title
        navigationItem.searchController = searchController
        navigationController?.navigationBar.prefersLargeTitles = true
    
    }
    
    func setupCollectionView(){
        view.addSubview(collectionView)
        
        collectionView.register(CharacterCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = dataSource
        collectionView.backgroundColor = .systemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        let top = collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor)
        let leading = collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let trailing = collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let bottom = collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        NSLayoutConstraint.activate([top, leading, trailing, bottom])
    }
    
    func setupBindings(){
        viewModel.list.bind { (list) in
            self.charactersLoaded(list: list)
        }
        
        viewModel.error.bind { error in
            if !error.isEmpty {
                self.show(error: error)
            }
        }
    }
    
    func show(error: String){
        let alertControler = UIAlertController(title: "Oops!", message: error, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            alertControler.dismiss(animated: true, completion: nil)
        }
        
        alertControler.addAction(okAction)
        
        self.present(alertControler, animated: true, completion: nil)
    }
    
    func charactersLoaded(list: [CharactersListViewModelItem]) {
        
        var snapshot: NSDiffableDataSourceSnapshot<SectionType, CharactersListViewModelItem>
        
        if dataSource.snapshot().itemIdentifiers.count > 0 {
            snapshot = dataSource.snapshot()
            snapshot.deleteAllItems()
            dataSource.apply(snapshot, animatingDifferences: true)
        }else{
            snapshot = NSDiffableDataSourceSnapshot<SectionType, CharactersListViewModelItem>()
        }
        
        snapshot.appendSections(SectionType.allCases)
        
        snapshot.appendItems(list, toSection: .main)
        
        dataSource.apply(snapshot, animatingDifferences: true)
        
    }

}

extension CharactersListVC: UICollectionViewDelegate {
 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CharacterCell else { return }
        
        let currentCellFrame = cell.frame
        
        let cardPresentationOnScreen = collectionView.convert(currentCellFrame, to: nil)
        
        let cardFrameWithoutTransformation = { () -> CGRect in
            let size = cell.bounds.size
            let r = CGRect(
                x: cell.frame.minX,
                y: cell.frame.minY,
                width: size.width,
                height: size.height
            )
            return collectionView.convert(r, to: nil)
        }()
        
        transition = CardToDetailTransition(fromFrame: cardPresentationOnScreen, fromFrameWithoutTransformation: cardFrameWithoutTransformation, cell: cell)
        
        let detailsVC = getDetailsVC(with: item, transitionDelegate: transition)
        
        present(detailsVC, animated: true)
            
    }
    
    private func getDetailsVC(with item: CharactersListViewModelItem, transitionDelegate: CardToDetailTransition?) -> CharacterDetailsVC {
        let service = DefaultNetworkService()
        let repository = DefaultCharacterDetailsRepository(service: service)
        let viewModel = CharacterDetailsViewModel(character: item, repository: repository)
        let detailsVC = CharacterDetailsVC(viewModel: viewModel)
        detailsVC.transitioningDelegate = transitionDelegate
        detailsVC.modalPresentationCapturesStatusBarAppearance = true
        detailsVC.modalPresentationStyle = .custom
        
        return detailsVC
    }
    
}

extension CharactersListVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.size.width / 2
        
        return CGSize(width: width, height: width * 1.5)
    }
}

extension CharactersListVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text ?? ""
        viewModel.search(name: text, clean: true)
    }
}

extension CharactersListVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let threshold = CGFloat(100)
        
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height
        
        if bottomEdge + threshold >= scrollView.contentSize.height && !viewModel.isLoading {
            
            let text = searchController.searchBar.text ?? ""
            
            viewModel.search(name: text)
        }
    }
}
