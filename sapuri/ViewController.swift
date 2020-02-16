//
//  ViewController.swift
//  sapuri
//
//  Created by 二渡杏 on 2020/01/01.
//  Copyright © 2020 二渡杏. All rights reserved.
//

import UIKit
import SafariServices

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
        
@IBAction func tappedSafariButton(sender: AnyObject) {
        let qiitaUrl = NSURL(string: "https://sapurisupporter.netlify.com")

        if let qiitaUrl = qiitaUrl {
            let safariViewController = SFSafariViewController(url: qiitaUrl as URL)
            present(safariViewController, animated: false, completion: nil)
        }
    }
}
