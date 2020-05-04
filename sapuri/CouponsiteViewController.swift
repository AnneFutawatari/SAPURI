//
//  CouponsiteViewController.swift
//  sapuri
//
//  Created by 二渡杏 on 2020/03/11.
//  Copyright © 2020 二渡杏. All rights reserved.
//

import UIKit
import SafariServices

class CouponsiteViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func tappedSafariButton1(sender: AnyObject) {
        let takeoutUrl = NSURL(string: "https://sano-takeout.netlify.app")

        if let takeoutUrl = takeoutUrl {
            let safariViewController = SFSafariViewController(url: takeoutUrl as URL)
            present(safariViewController, animated: false, completion: nil)
        }
    }
    
    @IBAction func tappedSafariButton2(sender: AnyObject) {
        let cafeUrl = NSURL(string: "https://sanofood.netlify.app")
        
        if let cafeUrl = cafeUrl {
            let safariViewController = SFSafariViewController(url: cafeUrl as URL)
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
