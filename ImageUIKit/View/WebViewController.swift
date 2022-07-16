//
//  WebViewController.swift
//  ImageUIKit
//
//  Created by Влад on 13.07.2022.
//

import Foundation
import UIKit

class WebViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    class var identifier: String { return String(describing: self) }
    
    var url: String!
       
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request = URLRequest(url: URL(string: url)!)
        webView.delegate = self
        webView.scalesPageToFit = true
        webView.sizeToFit()
        webView.loadRequest(request)
        
    }
    
}

extension WebViewController: UIWebViewDelegate {

}
