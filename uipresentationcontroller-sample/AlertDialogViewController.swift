//
//  AlertDialogViewController.swift
//  uipresentationcontroller-sample
//
//  Created by Shinya Kumagai on 2020/06/21.
//  Copyright © 2020 Shinya Kumagai. All rights reserved.
//

import UIKit

class AlertDialogViewController: UIViewController {
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    @IBOutlet private weak var bodyLabel: UILabel!
    
    @IBOutlet private weak var contentView: UIView!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        contentView.layer.cornerRadius = 8.0
    }
    
    @IBAction func onOkButtonTouch(_ sender: Any) {
        dismiss(animated: true)
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension AlertDialogViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return AlertDialogPresentationController(
            presentedViewController: presented,
            presenting: presenting
        )
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AlertDialogAnimationController(isPresentation: true)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AlertDialogAnimationController(isPresentation: false)
    }
}

// MARK: - PresentationController

class AlertDialogPresentationController: UIPresentationController {
    
    private let backgroundView: UIView = {
        let v = UIView()
        v.backgroundColor = .black
        return v
    }()
    
    override func presentationTransitionWillBegin() {
        print("#presentationTransitionWillBegin()")
        print("containerView.bounds=\(containerView!.frame)")
        
        backgroundView.alpha = 0.0
        containerView!.insertSubview(backgroundView, at: 0)

        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] _ in
            self?.backgroundView.alpha = 0.5
        })
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        print("#presentationTransitionDidEnd(\(completed))")
        
        if !completed {
            containerView!.removeFromSuperview()
        }
    }
    
    override func dismissalTransitionWillBegin() {
        print("#dismissalTransitionWillBegin()")
        
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] _ in
            self?.backgroundView.alpha = 0
        })
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        print("#dismissalTransitionDidEnd(\(completed)")
        
        if completed {
            backgroundView.removeFromSuperview()
        }
    }
    
    override var frameOfPresentedViewInContainerView : CGRect {
        return containerView!.bounds
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        print("#containerViewWillLayoutSubviews()")
        
        backgroundView.frame = containerView!.bounds
        presentedView!.frame = frameOfPresentedViewInContainerView
        print("presentedView.frame=\(containerView!.bounds)")
    }
}

// MARK: - AnimationController
class AlertDialogAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

    private let isPresentation: Bool
    
    init(isPresentation: Bool) {
        self.isPresentation = isPresentation
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard transitionContext.isAnimated else {
            return
        }
        
        if isPresentation {
            animatePresentedTransition(using: transitionContext)
        }
        else {
            animateDismissTransition(using: transitionContext)
        }
    }
    
    private func animatePresentedTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toView = transitionContext.view(forKey: .to)!
        let containerView = transitionContext.containerView
        containerView.addSubview(toView)
        
        toView.alpha = 0.0
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            toView.alpha = 1.0
        }) { completed in
            transitionContext.completeTransition(completed)
        }
    }
    
    private func animateDismissTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromView = transitionContext.view(forKey: .from)!
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            fromView.alpha = 0.0
        }) { completed in
            let transitionWasCancelled = transitionContext.transitionWasCancelled
            if transitionWasCancelled {
                fromView.removeFromSuperview()
            }
            transitionContext.completeTransition(!transitionWasCancelled)
        }
    }
}
