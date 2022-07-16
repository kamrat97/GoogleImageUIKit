//
//  ImagesViewModel.swift
//  ImageUIKit
//
//  Created by Влад on 11.07.2022.
//

import Foundation
import UIKit


protocol MainViewModelProtocol {
    var updateMainView: ((MainView)->())? { get set }
}

class MainViewModel:NSObject, MainViewModelProtocol {
    
    public var updateMainView: ((MainView) -> ())?
    
    private var googleImageAPIService: GoogleImageAPISerciceProtocol
    
    var reloadCellView:(() -> Void)?
    
    var reloadButton:((SizeButton) -> Void)?
    
    var images = MainView.Images(imagesResults: [])
    
    var imageCellViewModels = [ImageCellViewModel]() {
        didSet{
            reloadCellView?()
        }
    }
    
    public func updateSize(_ size: SizeButton) {
        reloadButton?(size)
        selectedImageSize = size
    }
    
    var selectedImageSize: SizeButton = .NoSelection
    var selectImageCountry: String = "No Selection"
    var selectImageLanguage: String = "No Selection"
    
    init(googleImageAPIService: GoogleImageAPISerciceProtocol = GoogleImageAPIService()){
        self.googleImageAPIService = googleImageAPIService
        updateMainView?(.initial)
    }
    
    func getImages(searchString: String) {
        updateMainView?(.load)
        googleImageAPIService.getImages(searchString: searchString, sizeParameter: selectedImageSize, languageParameter: selectImageLanguage, countryParameter: selectImageCountry){ [weak self] success, model, error in
            if success, let images = model {
                self?.updateMainView?(.success)
                self?.fetchData(images: images)
            }
        }
    }
    
    func fetchData(images: MainView.Images) {
        self.images = images
        var vms = [ImageCellViewModel]()
        for image in images.imagesResults {
            vms.append(createCellModel(image: image))
        }
        imageCellViewModels = vms
    }
    
    func createCellModel(image: MainView.ImagesResult) -> ImageCellViewModel {
        let position = image.position
        let thumbnail = image.thumbnail
        let source = image.source
        let title = image.title
        let link = image.link
        let original = image.original
        let isProduct = image.isProduct
        
        return ImageCellViewModel(position: position, thumbnail: thumbnail, source: source, title: title, link: link, original: original, isProduct: isProduct)
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> ImageCellViewModel {
        return imageCellViewModels[indexPath.row]
    }
}
