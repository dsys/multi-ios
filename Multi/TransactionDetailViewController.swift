//
//  TransactionDetailViewController.swift
//  Multi
//
//  Created by Andrew Gold on 7/4/18.
//  Copyright © 2018 Distributed Systems, Inc. All rights reserved.
//

import UIKit

protocol TransactionDetailViewControllerDelegate: AnyObject {
    func willDismiss(transactionDetailViewController: TransactionDetailViewController)
}

class TransactionDetailViewController: UIViewController {
    
    public static let viewCornerRadius: CGFloat = 10;
    public static let viewSize: CGSize = {
        let screenSize = UIScreen.main.bounds.size
        let size = CGSize(width: screenSize.width * 0.9, height: screenSize.height * 0.8)
        return size
    }()
    
    weak public var delegate: TransactionDetailViewControllerDelegate?
    private let dimmingView: UIView = {
        let frame = UIScreen.main.bounds
        let view = UIView(frame: frame)
        view.backgroundColor = UIColor.black
        view.alpha = 0
        return view
    }()
    private var navigationBar: UINavigationBar?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.modalPresentationStyle = .custom
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let view = self.view else { return }

        let layer = view.layer
        layer.cornerRadius = TransactionDetailViewController.viewCornerRadius
        layer.masksToBounds = true
        view.backgroundColor = UIColor.white
    
        let navigationItem = UINavigationItem(title: "Transaction")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped(barButtonItem:)))
        
        navigationBar = UINavigationBar()
        navigationBar?.setItems([ navigationItem ], animated: false)
        view.addSubview(navigationBar!)
    }
    
    @objc func doneButtonTapped(barButtonItem: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
        self.delegate?.willDismiss(transactionDetailViewController: self)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let screenSize = UIScreen.main.bounds.size
        let size = TransactionDetailViewController.viewSize
        self.view.frame = CGRect(origin: CGPoint(x: (screenSize.width - size.width) / 2, y: (screenSize.height - size.height) / 2), size: size)
        
        navigationBar?.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: size.width, height: 50))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let transitionCoordinator = self.transitionCoordinator else { return }
        
        transitionCoordinator.animate(alongsideTransition: { (context) in
            guard let fromView = context.viewController(forKey: .from)?.view else {
                assertionFailure()
                return
            }
            
            fromView.addSubview(self.dimmingView)
            self.dimmingView.alpha = 0.4
        }, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard let transitionCoordinator = self.transitionCoordinator else { return }
        
        self.transitionCoordinator?.animate(alongsideTransition: { (context) in
            UIView.animate(withDuration: transitionCoordinator.transitionDuration, delay: 0, options: .curveEaseInOut, animations: {
                self.dimmingView.alpha = 0
            }, completion: nil)
        }, completion: { _ in
            self.dimmingView.removeFromSuperview()
        })
    }
}
