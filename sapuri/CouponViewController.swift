//
//  CouponViewController.swift
//  sapuri
//
//  Created by 二渡杏 on 2019/12/25.
//  Copyright © 2019 二渡杏. All rights reserved.
//

import UIKit
import SafariServices

class CouponViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func tappedSafariButton(sender: AnyObject) {
        let qiitaUrl = NSURL(string: "https://sapuricoupon.netlify.com/")

        if let qiitaUrl = qiitaUrl {
            let safariViewController = SFSafariViewController(url: qiitaUrl as URL)
            present(safariViewController, animated: false, completion: nil)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
