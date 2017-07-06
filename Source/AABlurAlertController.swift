//
//  AABlurAlertController.swift
//  AABlurAlertController
//
//  Created by Anas Ait Ali on 17/01/2017.
//
//

import UIKit

public enum AABlurActionStyle {
    case `default`, cancel, modern, modernCancel
}

public enum AABlurTopImageStyle {
    case `default`, fullWidth
}

public enum AABlurAlertStyle {
    case `default`, modern
}

open class AABlurAlertAction: UIButton {
    fileprivate var handler: ((AABlurAlertAction) -> Void)? = nil
    fileprivate var style: AABlurActionStyle = AABlurActionStyle.default
    fileprivate var parent: AABlurAlertController? = nil

    public init(title: String?, style: AABlurActionStyle, handler: ((AABlurAlertAction) -> Void)?) {
        super.init(frame: CGRect.zero)

        self.style = style
        self.handler = handler

        self.addTarget(self, action: #selector(buttonTapped), for: UIControlEvents.touchUpInside)
        self.setTitle(title, for: UIControlState.normal)

        switch self.style {
        case .cancel:
            self.setTitleColor(UIColor(red:0.47, green:0.50, blue:0.55, alpha:1.00), for: UIControlState.normal)
            self.backgroundColor = UIColor(red:0.93, green:0.94, blue:0.95, alpha:1.00)
            self.layer.borderColor = UIColor(red:0.74, green:0.77, blue:0.79, alpha:1.00).cgColor
            self.layer.borderWidth = 1
            self.layer.cornerRadius = 5
            self.layer.shadowOffset = CGSize(width: 0, height: 2)
            self.layer.shadowRadius = 4
            self.layer.shadowOpacity = 0.1
        case .modernCancel:
            self.setTitleColor(UIColor(red:0.47, green:0.50, blue:0.56, alpha:1.00), for: UIControlState.normal)
            self.backgroundColor = UIColor(red:0.93, green:0.94, blue:0.95, alpha:1.00)
            self.layer.cornerRadius = 5
        case .modern:
            self.setTitleColor(UIColor.white, for: UIControlState.normal)
            self.backgroundColor = UIColor(red:0.28, green:0.56, blue:0.90, alpha:1.00)
            self.layer.cornerRadius = 5
        default:
            self.setTitleColor(UIColor.white, for: UIControlState.normal)
            self.backgroundColor = UIColor(red:0.31, green:0.57, blue:0.87, alpha:1.00)
            self.layer.borderColor = UIColor(red:0.17, green:0.38, blue:0.64, alpha:1.00).cgColor
            self.layer.borderWidth = 1
            self.layer.cornerRadius = 5
            self.layer.shadowOffset = CGSize(width: 0, height: 2)
            self.layer.shadowRadius = 4
            self.layer.shadowOpacity = 0.1
        }
        self.setTitleColor(self.titleColor(for: UIControlState.normal)?.withAlphaComponent(0.5), for: UIControlState.highlighted)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    @objc fileprivate func buttonTapped(_ sender: AABlurAlertAction) {
        self.parent?.dismiss(animated: true, completion: {
            self.handler?(sender)
        })
    }
}

open class AABlurAlertController: UIViewController {

    open var alertStyle: AABlurAlertStyle = AABlurAlertStyle.default
    open var blurEffectStyle: UIBlurEffectStyle = .light
    open var imageHeight: Float = 175
    open var topImageStyle: AABlurTopImageStyle = AABlurTopImageStyle.default
    open var alertViewWidth: Float?
//
    /**
     Set the max alert view width
     If you don't want to have a max width set this to nil.
     It will take 70% of the superview width by default
     Default : 450
     */
    open var maxAlertViewWidth: CGFloat? = 450

    private var spacing: Int = 16
    private var titleSubtitleSpacing: Int = 16
    private var bottomSpacing: Int = 32

    fileprivate var backgroundImage : UIImageView = UIImageView()
    fileprivate var alertView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.00)
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
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.distribution = .fillEqually
        sv.spacing = 22
        return sv
    }()

    public init() {
        super.init(nibName: nil, bundle: nil)
        self.modalTransitionStyle = .crossDissolve
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func setup() {
        // Clean the views
        self.view.subviews.forEach{ $0.removeFromSuperview() }
        self.backgroundImage.subviews.forEach{ $0.removeFromSuperview() }
        // Set up view
        self.view.frame = UIScreen.main.bounds
        self.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.view.backgroundColor = UIColor.blue.withAlphaComponent(0.5)
        // Set up background image
        self.backgroundImage.frame = self.view.bounds
        self.backgroundImage.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.view.addSubview(backgroundImage)
        // Set up the alert view
        self.alertView.clipsToBounds = true
        switch self.alertStyle {
        case .modern:
            self.alertView.layer.cornerRadius = 13
            self.titleSubtitleSpacing = 32
            self.bottomSpacing = 24
        default:
            self.alertView.layer.cornerRadius = 5
            self.alertView.layer.shadowColor = UIColor.black.cgColor
            self.alertView.layer.shadowOffset = CGSize(width: 0, height: 15)
            self.alertView.layer.shadowRadius = 12
            self.alertView.layer.shadowOpacity = 0.22
        }
        self.view.addSubview(alertView)
        // Set up alertImage
        self.alertView.addSubview(alertImage)
        // Set up alertTitle
        self.alertView.addSubview(alertTitle)
        // Set up alertSubtitle
        self.alertView.addSubview(alertSubtitle)
        // Set up buttonsStackView
        self.alertView.addSubview(buttonsStackView)

        // Set up background Tap
        if buttonsStackView.arrangedSubviews.count <= 0 {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnBackground))
            self.backgroundImage.isUserInteractionEnabled = true
            self.backgroundImage.addGestureRecognizer(tapGesture)
        }

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
            "margin": spacing * 2,
            "spacing": spacing,
            "titleSubtitleSpacing": titleSubtitleSpacing,
            "bottomSpacing": bottomSpacing,
            "alertViewWidth": 450,
            "alertImageHeight": (alertImage.image != nil) ? imageHeight : 0,
            "alertTitleHeight": 22,
            "buttonsStackViewHeight": (buttonsStackView.arrangedSubviews.count > 0) ? 44 : 0
        ]

        if let alertViewWidth = alertViewWidth {
            self.view.addConstraints(NSLayoutConstraint.constraints(
                withVisualFormat: "H:[alertView(alertViewWidth)]", options: [],
                metrics: ["alertViewWidth":alertViewWidth], views: viewsDict))
        } else {
            let widthConstraints = NSLayoutConstraint(item: alertView,
                               attribute: NSLayoutAttribute.width,
                               relatedBy: NSLayoutRelation.equal,
                               toItem: self.view,
                               attribute: NSLayoutAttribute.width,
                               multiplier: 0.7, constant: 0)
            if let maxAlertViewWidth = maxAlertViewWidth {
                widthConstraints.priority = 999
                self.view.addConstraint(NSLayoutConstraint(
                    item: alertView,
                    attribute: NSLayoutAttribute.width,
                    relatedBy: NSLayoutRelation.lessThanOrEqual,
                    toItem: nil,
                    attribute: NSLayoutAttribute.width,
                    multiplier: 1,
                    constant: maxAlertViewWidth))
            }
            self.view.addConstraint(widthConstraints)
        }

        let alertSubtitleVconstraint = (alertSubtitle.text != nil) ? "titleSubtitleSpacing-[alertSubtitle]-" : ""
        [NSLayoutConstraint(item: alertView, attribute: .centerX, relatedBy: .equal,
                            toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
         NSLayoutConstraint(item: alertView, attribute: .centerY, relatedBy: .equal,
                            toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
            ].forEach { self.view.addConstraint($0)}
        let imageStyleMargin = self.topImageStyle == .fullWidth ? "0" : "margin"
        [NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-\(imageStyleMargin)-[alertImage(alertImageHeight)]-spacing-[alertTitle(alertTitleHeight)]-\(alertSubtitleVconstraint)margin-[buttonsStackView(buttonsStackViewHeight)]-bottomSpacing-|",
            options: [], metrics: viewMetrics, views: viewsDict),
         NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(imageStyleMargin)-[alertImage]-\(imageStyleMargin)-|",
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

        setup()

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

    open func addAction(action: AABlurAlertAction) {
        action.parent = self
        buttonsStackView.addArrangedSubview(action)
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
