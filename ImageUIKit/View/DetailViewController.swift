//
//  DetaileViewController.swift
//  ImageUIKit
//
//  Created by Влад on 11.07.2022.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    
    var currentIndex: IndexPath!
    
    class var identifier: String { return String(describing: self) }
    
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            updateImage()
        }
    }
    @IBOutlet weak var pullUpButton: UIButton!
    @IBOutlet weak var imageBriefView: UIView!
    @IBOutlet weak var buttonLast: UIButton!
    @IBOutlet weak var buttonNext: UIButton!
    @IBOutlet weak var imageBrief: UILabel! {
        didSet {
           updateBrief()
        }
    }
    
    
    var images = MainView.Images(imagesResults: [])
    
    @IBAction func nextImage(_ sender: Any) {
        if currentIndex.row != images.imagesResults.count - 1 {
            currentIndex.row += 1
            updateImage()
            updateBrief()
        }
    }
    @IBAction func lastImage(_ sender: Any) {
        if currentIndex.row != 0 {
            currentIndex.row -= 1
            updateImage()
            updateBrief()
        }
    }
    
    
    func updateImage() {
        let image = images.imagesResults[currentIndex.row].thumbnail
        imageView.sd_setImage(with: URL(string: image))
    }
    
    func updateBrief() {
        let text = images.imagesResults[currentIndex.row].title
        imageBrief.text = text
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    private func initView(){
        
        imageBriefView.layer.cornerRadius = 10
        buttonNext.sizeToFit()
        buttonLast.sizeToFit()
       
       
        let openOriginalImage = UIAction(title: "Открыть оригинал", image: UIImage(systemName: "globe")) { [self] _ in
            let webViewController = self.storyboard?.instantiateViewController(withIdentifier: WebViewController.identifier) as! WebViewController
            webViewController.url = images.imagesResults[self.currentIndex.row].original
            self.navigationController?.pushViewController(webViewController, animated: true)
        }
        let menu = UIMenu(title: "Действия", children: [openOriginalImage])
        pullUpButton.menu = menu
        pullUpButton.showsMenuAsPrimaryAction = true
       
    }
    
}
