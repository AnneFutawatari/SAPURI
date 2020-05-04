//
//  cityViewController.swift
//  sapuri
//
//  Created by 二渡杏 on 2020/05/03.
//  Copyright © 2020 二渡杏. All rights reserved.
//

import UIKit
import SafariServices

class cityViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func tappedSafariButton1(sender: AnyObject) {
        let takeoutUrl = NSURL(string: "https://www.premiumoutlets.co.jp/sano/")

        if let takeoutUrl = takeoutUrl {
            let safariViewController = SFSafariViewController(url: takeoutUrl as URL)
            present(safariViewController, animated: false, completion: nil)
        }
    }
    
    @IBAction func tappedSafariButton2(sender: AnyObject) {
        let takeoutUrl = NSURL(string: "http://sano-kankokk.jp/guide/169/")

        if let takeoutUrl = takeoutUrl {
            let safariViewController = SFSafariViewController(url: takeoutUrl as URL)
            present(safariViewController, animated: false, completion: nil)
        }
    }
    
    @IBAction func tappedSafariButton3(sender: AnyObject) {
           let takeoutUrl = NSURL(string: "https://sanoyakuyokedaishi.or.jp")

           if let takeoutUrl = takeoutUrl {
               let safariViewController = SFSafariViewController(url: takeoutUrl as URL)
               present(safariViewController, animated: false, completion: nil)
           }
       }
    
    @IBAction func tappedSafariButton4(sender: AnyObject) {
        let takeoutUrl = NSURL(string: "https://domannaka.co.jp")

        if let takeoutUrl = takeoutUrl {
            let safariViewController = SFSafariViewController(url: takeoutUrl as URL)
            present(safariViewController, animated: false, completion: nil)
        }
    }
    
    @IBAction func tappedSafariButton5(sender: AnyObject) {
        let takeoutUrl = NSURL(string: "https://www.google.com/search?client=safari&rls=en&q=カタクリの里&ie=UTF-8&oe=UTF-8")

        if let takeoutUrl = takeoutUrl {
            let safariViewController = SFSafariViewController(url: takeoutUrl as URL)
            present(safariViewController, animated: false, completion: nil)
        }
    }
    
    @IBAction func tappedSafariButton6(sender: AnyObject) {
        let takeoutUrl = NSURL(string: "https://www.city.sano.lg.jp/sp/yoshizawakinembijutsukan/")

        if let takeoutUrl = takeoutUrl {
            let safariViewController = SFSafariViewController(url: takeoutUrl as URL)
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
