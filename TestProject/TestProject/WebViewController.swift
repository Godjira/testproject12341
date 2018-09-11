//
//  WebViewController.swift
//  TestProject
//
//  Created by Godjira on 9/11/18.
//  Copyright © 2018 Godjira. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class WebViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    var link: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = URL(string: link!) else {
            dismiss(animated: true)
            return }
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true)
    }
}
