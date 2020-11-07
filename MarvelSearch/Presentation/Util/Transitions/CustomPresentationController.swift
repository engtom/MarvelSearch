//
//  CustomPresentationController.swift
//  MarvelSearch
//
//  Created by Everton Gonçalves on 03/11/20.
//

import Foundation
import UIKit

final class CustomPresentationController: UIPresentationController {
    
    private lazy var blurView = UIVisualEffectView(effect: nil)
    
    override var shouldRemovePresentersView: Bool {
        return false
    }
    
    override func presentationTransitionWillBegin() {
        let container = containerView!
        blurView.translatesAutoresizingMaskIntoConstraints = false
        //container.addSubview(blurView)
        //blurView.edges(to: container)
        //blurView.alpha = 0.0
        
        presentingViewController.beginAppearanceTransition(false, animated: false)
        presentedViewController.transitionCoordinator!.animate(alongsideTransition: { (context) in
            UIView.animate(withDuration: 0.5) {
                //self.blurView.effect = UIBlurEffect(style: .light)
                //self.blurView.alpha = 1.0
            }
            
        }, completion: nil)
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        presentingViewController.endAppearanceTransition()
    }
    
    override func dismissalTransitionWillBegin() {
        presentingViewController.beginAppearanceTransition(true, animated: true)
//        presentedViewController.transitionCoordinator!.animate(alongsideTransition: { (context) in
//            self.blurView.alpha = 0.0
//        }, completion: nil)

    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        presentingViewController.endAppearanceTransition()
        if completed {
            //blurView.removeFromSuperview()
        }
    }
    
}
