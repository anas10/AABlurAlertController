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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

//        showAction(self)
    }

    @IBAction func showAction(_ sender: Any) {
        let vc = AABlurAlertController()

        vc.addAction(action: AABlurAlertAction(title: "Cancel", style: AABlurActionStyle.cancel) { _ in
            print("cancel")
        })
        vc.addAction(action: AABlurAlertAction(title: "Start", style: AABlurActionStyle.default) { _ in
            print("start")
            let vc2 = AABlurAlertController()
            vc2.alertTitle.text = "view2"
            self.present(vc2, animated: true, completion: nil)
        })
        vc.blurEffectStyle = .light
        vc.alertImage.image = UIImage(named: "illustration_profile_avatar")
        vc.imageHeight = 110
        vc.alertImage.layer.masksToBounds = true
        vc.alertTitle.text = "Start a Job ?"
        vc.alertSubtitle.text = "Are you sure you would like to start the job?\nThis action cannot be undone."
        self.present(vc, animated: true, completion: nil)
    }
    
}

