//
//  ViewController.swift
//  ImageUIKit
//
//  Created by Влад on 11.07.2022.
//

import UIKit
import MapKit

class MainViewController: UIViewController{
    
    var mainViewState: MainView = .initial {
        didSet {
            updateViewConstraints()
        }
    }
    
    var buttonState: SizeButton = .NoSelection {
        didSet {
            updateViewConstraints()
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var viewModel = {
        MainViewModel()
    }()
    
    @IBOutlet var searchBar: UISearchBar!
    
    lazy var loadIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initViewModel()
    }
    
    let selectParameterView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let selectSizeTitle: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "Size"
        return title
    }()
    
    var largeSizeButton: UIButton!
    var mediumSizeButton: UIButton!
    var iconSizeButton: UIButton!
    
    let selectCountryTitle: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "Country"
        return title
    }()
    var countryMenuButton: UIButton!
    let selectLanguageTitle: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "Language"
        return title
    }()
    var languageMenuButton: UIButton!
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        switch mainViewState {
        case .initial:
            loadIndicator.stopAnimating()
        case .load:
            loadIndicator.startAnimating()
        case .success:
            loadIndicator.stopAnimating()
        case .error:
            loadIndicator.stopAnimating()
        }
        
        switch buttonState {
        case .Large:
            mediumSizeButton.isSelected = false
            iconSizeButton.isSelected = false
        case .Medium:
            largeSizeButton.isSelected = false
            iconSizeButton.isSelected = false
        case .Icon:
            largeSizeButton.isSelected = false
            mediumSizeButton.isSelected = false
        case .NoSelection:
            largeSizeButton.isSelected = false
            mediumSizeButton.isSelected = false
            iconSizeButton.isSelected = false
        }
    }
    
    private func initView(){
        view.addSubview(selectParameterView)
        
        createSelectParameterSearch()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.keyboardDismissMode = .onDrag
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ImageCell.nib, forCellWithReuseIdentifier: ImageCell.identifier)
        collectionView.topAnchor.constraint(equalTo: selectParameterView.bottomAnchor, constant: 10).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        let cellLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        cellLayout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        cellLayout.itemSize = CGSize(width: view.bounds.size.width / 3, height: view.bounds.size.width / 3)
        cellLayout.minimumInteritemSpacing = 0
        cellLayout.minimumLineSpacing = 2
        collectionView!.collectionViewLayout = cellLayout
        
        
        self.view.addSubview(loadIndicator)
        loadIndicator.hidesWhenStopped = true
        loadIndicator.center = self.view.center
        
        navigationItem.titleView = searchBar
        
        searchBar.searchBarStyle = UISearchBar.Style.prominent
        searchBar.placeholder = "Search"
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.delegate = self
        
    }
    
    private func initViewModel() {
        viewModel.reloadCellView = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        
        viewModel.updateMainView = { [weak self] viewState in
            DispatchQueue.main.async {
                self?.mainViewState = viewState
            }
        }
        
        viewModel.reloadButton = { [weak self] stateSize in
            DispatchQueue.main.async {
                self?.buttonState = stateSize
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            if text != "" {
                viewModel.getImages(searchString: text)
                searchBar.endEditing(true)
            }
        }
    }
    
    private func createSelectParameterSearch(){
        
        largeSizeButton = configLargeSizeButton()
        mediumSizeButton = configMediumSizeButton()
        iconSizeButton = configIconSizeButton()
        
        countryMenuButton = createCountryMenuButton()
        languageMenuButton = createLanguageMenuButton()
        
        selectParameterView.addSubview(selectSizeTitle)
        selectParameterView.addSubview(largeSizeButton)
        selectParameterView.addSubview(mediumSizeButton)
        selectParameterView.addSubview(iconSizeButton)
        
        selectParameterView.addSubview(selectCountryTitle)
        selectParameterView.addSubview(countryMenuButton)
        selectParameterView.addSubview(selectLanguageTitle)
        selectParameterView.addSubview(languageMenuButton)
        
        
        selectParameterView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        selectParameterView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        selectParameterView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        selectSizeTitle.topAnchor.constraint(equalTo: selectParameterView.topAnchor, constant: 10).isActive = true
        selectSizeTitle.leftAnchor.constraint(equalTo: selectParameterView.leftAnchor, constant: 20).isActive = true
        selectSizeTitle.bottomAnchor.constraint(equalTo: selectCountryTitle.topAnchor, constant: -10).isActive = true
        
        
        largeSizeButton.topAnchor.constraint(equalTo: selectParameterView.topAnchor, constant: 10).isActive = true
        largeSizeButton.leftAnchor.constraint(equalTo: selectSizeTitle.rightAnchor, constant: 10).isActive = true
        largeSizeButton.bottomAnchor.constraint(equalTo:  selectSizeTitle.bottomAnchor).isActive = true
        
        mediumSizeButton.topAnchor.constraint(equalTo: selectParameterView.topAnchor, constant: 10).isActive = true
        mediumSizeButton.leftAnchor.constraint(equalTo: largeSizeButton.rightAnchor, constant: 10).isActive = true
        mediumSizeButton.bottomAnchor.constraint(equalTo: selectSizeTitle.bottomAnchor).isActive = true
        
        iconSizeButton.topAnchor.constraint(equalTo: selectParameterView.topAnchor, constant: 10).isActive = true
        iconSizeButton.leftAnchor.constraint(equalTo: mediumSizeButton  .rightAnchor, constant: 10).isActive = true
        iconSizeButton.bottomAnchor.constraint(equalTo: selectSizeTitle.bottomAnchor).isActive = true
        
        selectCountryTitle.topAnchor.constraint(equalTo: selectSizeTitle.bottomAnchor, constant: 10).isActive = true
        selectCountryTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        selectCountryTitle.bottomAnchor.constraint(equalTo: countryMenuButton.topAnchor, constant: -5).isActive = true
        
        countryMenuButton.topAnchor.constraint(equalTo: selectCountryTitle.bottomAnchor, constant: 5).isActive = true
        countryMenuButton.leftAnchor.constraint(equalTo: selectCountryTitle.leftAnchor).isActive = true
        countryMenuButton.bottomAnchor.constraint(equalTo: selectParameterView.bottomAnchor, constant: -10).isActive = true
        
        selectLanguageTitle.topAnchor.constraint(equalTo: selectCountryTitle.topAnchor).isActive = true
        selectLanguageTitle.leftAnchor.constraint(equalTo: countryMenuButton.rightAnchor, constant: 10).isActive = true
        selectLanguageTitle.bottomAnchor.constraint(equalTo: languageMenuButton.topAnchor, constant: -5).isActive = true
        
        languageMenuButton.topAnchor.constraint(equalTo: selectLanguageTitle.bottomAnchor, constant: 5).isActive = true
        languageMenuButton.leftAnchor.constraint(equalTo: selectLanguageTitle.leftAnchor).isActive = true
        languageMenuButton.bottomAnchor.constraint(equalTo: selectParameterView.bottomAnchor, constant: -10).isActive = true
        //languageMenuButton.rightAnchor.constraint(equalTo: selectParameterView.rightAnchor, constant: -20).isActive = true
        
    }
    
    func createCountryMenuButton() -> UIButton {
        var config = UIButton.Configuration.borderedProminent()
        config.buttonSize = .small
        let menuButton = UIButton(configuration: config)
        let sizeClosure = { [weak self] (action: UIAction) in
            self!.viewModel.selectImageCountry = action.title
        }
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        menuButton.menu = UIMenu(children: [
            UIAction(title: "No Selection", handler: sizeClosure),
            UIAction(title: "Germany", handler: sizeClosure),
            UIAction(title: "Russia", handler: sizeClosure),
            UIAction(title: "Japan", handler: sizeClosure),
            UIAction(title: "Indonesia", handler: sizeClosure),
            UIAction(title: "Mexico", handler: sizeClosure),
            UIAction(title: "United States", handler: sizeClosure),
            UIAction(title: "Brazil", handler: sizeClosure)
        ])
        menuButton.showsMenuAsPrimaryAction = true
        menuButton.changesSelectionAsPrimaryAction = true
        return menuButton
    }
    
    func createLanguageMenuButton() -> UIButton {
        var config = UIButton.Configuration.borderedProminent()
        config.buttonSize = .small
        let menuButton = UIButton(configuration: config)
        let sizeClosure = { [weak self] (action: UIAction) in
            self!.viewModel.selectImageLanguage = action.title
        }
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        menuButton.menu = UIMenu(children: [
            UIAction(title: "No Selection", handler: sizeClosure),
            UIAction(title: "Russian", handler: sizeClosure),
            UIAction(title: "Portuguese", handler: sizeClosure),
            UIAction(title: "German", handler: sizeClosure),
            UIAction(title: "Indonesian", handler: sizeClosure),
            UIAction(title: "Japanese", handler: sizeClosure),
            UIAction(title: "Spanish", handler: sizeClosure),
            UIAction(title: "English", handler: sizeClosure)
        ])
        menuButton.showsMenuAsPrimaryAction = true
        menuButton.changesSelectionAsPrimaryAction = true
        return menuButton
    }
    
    func configLargeSizeButton() -> UIButton {
        let sizeClosure = { [weak self] (action: UIAction) in
            if self!.largeSizeButton.isSelected {
                self!.viewModel.updateSize(.Large)
            } else {
                self!.viewModel.updateSize(.NoSelection)
            }
        }
        var config = UIButton.Configuration.borderless()
        config.buttonSize = .small
        config.title = "Large"
        let action = UIAction(title: "Large",handler: sizeClosure)
        let button = UIButton(configuration: config, primaryAction: action)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.changesSelectionAsPrimaryAction = true
        return button
    }
    
    func configMediumSizeButton() -> UIButton {
        let sizeClosure = { [weak self] (action: UIAction) in
            if self!.mediumSizeButton.isSelected {
                self!.viewModel.updateSize(.Medium)
            } else {
                self!.viewModel.updateSize(.NoSelection)
            }
        }
        var config = UIButton.Configuration.borderless()
        config.buttonSize = .small
        config.title = "Medium"
        let action = UIAction(title: "Medium",handler: sizeClosure)
        let button = UIButton(configuration: config, primaryAction: action)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.changesSelectionAsPrimaryAction = true
        return button
    }
    
    func configIconSizeButton() -> UIButton {
        let sizeClosure = { [weak self] (action: UIAction) in
            if self!.iconSizeButton.isSelected {
                self!.viewModel.updateSize(.Icon)
            } else {
                self!.viewModel.updateSize(.NoSelection)
            }
        }
        var config = UIButton.Configuration.borderless()
        config.buttonSize = .small
        config.title = "Icon"
        let action = UIAction(title: "Icon",handler: sizeClosure)
        let button = UIButton(configuration: config, primaryAction: action)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.changesSelectionAsPrimaryAction = true
        return button
    }
    
    //    func updateSize(_ size: String){
    //        switch size {
    //        case "Large" :
    //            largeSizeButton.isSelected.toggle()
    //            largeSizeButton.isSelected.toggle()
    //            mediumSizeButton.isSelected = false
    //            iconSizeButton.isSelected = false
    //        case "Medium" :
    //            largeSizeButton.isSelected = false
    //            mediumSizeButton.isSelected.toggle()
    //            mediumSizeButton.isSelected.toggle()
    //            iconSizeButton.isSelected = false
    //        case "Icon" :
    //            largeSizeButton.isSelected = false
    //            mediumSizeButton.isSelected = false
    //            iconSizeButton.isSelected.toggle()
    //            iconSizeButton.isSelected.toggle()
    //        default:
    //            largeSizeButton.isSelected = false
    //            mediumSizeButton.isSelected = false
    //            iconSizeButton.isSelected = false
    //        }
    //    }
    
    
    
    
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UISearchBarDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.imageCellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath) as? ImageCell else { fatalError("xib error") }
        let cellVM = viewModel.getCellViewModel(at: indexPath)
        cell.cellViewModel = cellVM
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = storyboard?.instantiateViewController(withIdentifier: DetailViewController.identifier) as! DetailViewController
        detailViewController.currentIndex = indexPath
        detailViewController.images = viewModel.images
        self.navigationController?.pushViewController(detailViewController, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2, height: collectionView.frame.width / 2)
    }
    
}
