//
//  paymentViewController.swift
//  Stor
//
//  Created by Jack Feldman on 5/29/18.
//  Copyright © 2018 David Ho. All rights reserved.
//

import UIKit

class paymentViewController: UIViewController {
    
    @IBOutlet var myPaymentView: UIView!
    
    @IBAction func ExitButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(backSwipe))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.right
        myPaymentView.addGestureRecognizer(swipeLeft)

        // Do any additional setup after loading the view.
    }
    
    @objc func backSwipe(){
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addPayment(_ sender: Any) {
        let vc:BrowseProductsViewController = BrowseProductsViewController()
        let navigationControllee = UINavigationController(rootViewController: vc)
        self.navigationController?.pushViewController(navigationControllee, animated: true)
        self.present(navigationControllee, animated: true) {
        }
    }
}
