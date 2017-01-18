//
//  ViewController.swift
//  AABlurAlertController
//
//  Created by Anas Ait Ali on 17/01/2017.
//
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showAction(_ sender: Any) {
        let vc = AABlurAlertController(image: UIImage(named: "IMG_7342.JPG"))
        vc.alertTitle.text = "Start a Job ?"
        vc.alertSubtitle.text = "Are you sure you would like to start the job?\nThis action cannot be undone."
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
}

