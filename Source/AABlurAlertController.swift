//
//  AABlurAlertController.swift
//  AABlurAlertController
//
//  Created by Anas Ait Ali on 17/01/2017.
//
//

import UIKit

open class AABlurAlertController: UIViewController {

    open var blurEffectStyle: UIBlurEffectStyle = .light

    fileprivate var backgroundImage : UIImageView = UIImageView()
    fileprivate var alertView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    open var alertImage : UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    open let alertTitle : UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.boldSystemFont(ofSize: 17)
        lbl.textColor = UIColor(red:0.20, green:0.22, blue:0.26, alpha:1.00)
        lbl.textAlignment = .center
        return lbl
    }()
    open let alertSubtitle : UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.boldSystemFont(ofSize: 14)
        lbl.textColor = UIColor(red:0.51, green:0.54, blue:0.58, alpha:1.00)
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        return lbl
    }()

    fileprivate let buttonsStackView : UIStackView = {
        let tmp1 = UIView()
        tmp1.backgroundColor = UIColor.blue
        let tmp2 = UIView()
        tmp2.backgroundColor = UIColor.red
        let sv = UIStackView(arrangedSubviews: [tmp1, tmp2])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.distribution = .fillEqually
        sv.spacing = 22
        return sv
    }()

    public init(image: UIImage? = nil) {
        super.init(nibName: nil, bundle: nil)

        alertImage.image = image

        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func setup() {
        // Set up view
        self.view.frame = UIScreen.main.bounds
        self.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.view.backgroundColor = UIColor.blue.withAlphaComponent(0.5)
        // Set up background image
        self.backgroundImage.frame = self.view.bounds
        self.backgroundImage.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.view.addSubview(backgroundImage)
        // Set up background Tap
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnBackground))
        self.backgroundImage.isUserInteractionEnabled = true
        self.backgroundImage.addGestureRecognizer(tapGesture)
        // Set up the alert view
        alertView.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.00)
        alertView.layer.cornerRadius = 5
        alertView.layer.shadowColor = UIColor.black.cgColor
        alertView.layer.shadowOffset = CGSize(width: 0, height: 15)
        alertView.layer.shadowRadius = 12
        alertView.layer.shadowOpacity = 0.22
        self.view.addSubview(alertView)
        // Set up alertImage
        self.alertView.addSubview(alertImage)
        // Set up alertTitle
        self.alertView.addSubview(alertTitle)
        // Set up alertSubtitle
        self.alertView.addSubview(alertSubtitle)
        // Set up buttonsStackView
        self.alertView.addSubview(buttonsStackView)

        setupConstraints()
    }

    fileprivate func setupConstraints() {
        let viewsDict: [String: Any] = [
            "alertView": alertView,
            "alertImage": alertImage,
            "alertTitle": alertTitle,
            "alertSubtitle": alertSubtitle,
            "buttonsStackView": buttonsStackView
        ]
        let viewMetrics: [String: Any] = [
            "margin": 32,
            "spacing": 16,
            "alertViewWidth": 450,
            "alertImageHeight": (alertImage.image != nil) ? 175 : 0,
            "alertTitleHeight": 22,
            "buttonsStackViewHeight": (buttonsStackView.arrangedSubviews.count > 0) ? 40 : 0
        ]

        [NSLayoutConstraint(item: alertView, attribute: .centerX, relatedBy: .equal,
                            toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
         NSLayoutConstraint(item: alertView, attribute: .centerY, relatedBy: .equal,
                            toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
            ].forEach { self.view.addConstraint($0)}
        [NSLayoutConstraint.constraints(withVisualFormat: "V:|-spacing-[alertImage(alertImageHeight)]-spacing-[alertTitle(alertTitleHeight)]-spacing-[alertSubtitle]-margin-[buttonsStackView(buttonsStackViewHeight)]-margin-|",
                                        options: [], metrics: viewMetrics, views: viewsDict),
         NSLayoutConstraint.constraints(withVisualFormat: "H:[alertView(alertViewWidth)]",
                                        options: [], metrics: viewMetrics, views: viewsDict),
         NSLayoutConstraint.constraints(withVisualFormat: "H:|-margin-[alertImage]-margin-|",
                                        options: [], metrics: viewMetrics, views: viewsDict),
         NSLayoutConstraint.constraints(withVisualFormat: "H:|-margin-[alertTitle]-margin-|",
                                        options: [], metrics: viewMetrics, views: viewsDict),
         NSLayoutConstraint.constraints(withVisualFormat: "H:|-margin-[alertSubtitle]-margin-|",
                                        options: [], metrics: viewMetrics, views: viewsDict),
         NSLayoutConstraint.constraints(withVisualFormat: "H:|-margin-[buttonsStackView]-margin-|",
                                        options: [], metrics: viewMetrics, views: viewsDict)
            ].forEach { NSLayoutConstraint.activate($0) }
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")

        // Set up blur effect
        backgroundImage.image = snapshot()
        let blurEffect = UIBlurEffect(style: blurEffectStyle)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = backgroundImage.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyEffectView.frame = backgroundImage.bounds
        vibrancyEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        blurEffectView.contentView.addSubview(vibrancyEffectView)
        backgroundImage.addSubview(blurEffectView)
    }

    fileprivate func snapshot() -> UIImage? {
        guard let window = UIApplication.shared.keyWindow else { return nil }
        UIGraphicsBeginImageContextWithOptions(window.bounds.size, false, window.screen.scale)
        window.drawHierarchy(in: window.bounds, afterScreenUpdates: false)
        let snapshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapshotImage
    }

    func tapOnBackground(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
