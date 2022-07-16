//
//  ImageCell.swift
//  ImageUIKit
//
//  Created by Влад on 11.07.2022.
//

import Foundation
import UIKit
import SDWebImage


class ImageCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    
    var cellViewModel: ImageCellViewModel? {
        didSet {
            imageView.sd_setImage(with: URL(string: cellViewModel?.thumbnail ?? ""))
        }
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.sd_setImage(with: URL(string: cellViewModel?.thumbnail ?? ""))
    }
    
}
