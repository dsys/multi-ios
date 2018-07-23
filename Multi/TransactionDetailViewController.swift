//
//  TransactionDetailViewController.swift
//  Multi
//
//  Created by Andrew Gold on 7/4/18.
//  Copyright © 2018 Distributed Systems, Inc. All rights reserved.
//

import UIKit

enum TransactionDetailInformationIndex: Int {
    case header = 0
    case from = 1
    case to = 2
    case description = 3
    case lineItems = 4
    case approve = 5
}

extension UITableViewCell {
    fileprivate func addSeparatorWithInset(_ inset: CGFloat) {
        let separatorView = UIView()
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = UIColor.lightGray
        contentView.addSubview(separatorView)
        
        separatorView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: inset).isActive = true
        separatorView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        separatorView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1.0 / UIScreen.main.scale).isActive = true
    }
}

protocol TransactionDetailViewControllerDelegate: AnyObject {
    func willDismiss(transactionDetailViewController: TransactionDetailViewController)
}

class TransactionDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let headerCellReuseIdentifier = "HeaderCellReuseIdentifier"
    private let informationCellReuseIdentifier = "InformationCellReuseIdentifier"
    private let lineItemCellReuseIdentifier = "LineItemCellReuseIdentifier"
    private let approveCellReuseIdentifier = "ApproveCellReuseIdentifier"
    private let verticalPadding = 15
    public static let viewCornerRadius: CGFloat = 10;
    public let displayInformation: TransactionDetailDisplayInformation
    weak public var delegate: TransactionDetailViewControllerDelegate?
    private let dimmingView: UIView = {
        let frame = UIScreen.main.bounds
        let view = UIView(frame: frame)
        view.backgroundColor = UIColor.black
        view.alpha = 0
        return view
    }()
    private let blurView: UIVisualEffectView = {
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
        blurView.translatesAutoresizingMaskIntoConstraints = false
        return blurView
    }()
    private let tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    private var tableViewHeightAnchor: NSLayoutConstraint?
    private var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Done", for: .normal)
        button.addTarget(self, action: #selector(doneButtonTapped(button:)), for: .primaryActionTriggered)
        button.sizeToFit()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(displayInformation: TransactionDetailDisplayInformation) {
        self.displayInformation = displayInformation
        super.init(nibName: nil, bundle: nil)

        self.modalPresentationStyle = .custom
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.clear

        tableView.backgroundColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 75
        tableView.isScrollEnabled = false
        tableView.alwaysBounceVertical = false
        tableView.allowsSelection = false
        tableView.register(TransactionDetailHeaderTableViewCell.self, forCellReuseIdentifier: headerCellReuseIdentifier)
        tableView.register(TransactionDetailInformationTableViewCell.self, forCellReuseIdentifier: informationCellReuseIdentifier)
        tableView.register(TransactionLineItemTableViewCell.self, forCellReuseIdentifier: lineItemCellReuseIdentifier)
        tableView.register(TransactionApproveTableViewCell.self, forCellReuseIdentifier: approveCellReuseIdentifier)
        
        view.addSubview(blurView)
        blurView.contentView.addSubview(tableView)
        
        let layer = blurView.layer
        layer.cornerRadius = TransactionDetailViewController.viewCornerRadius
        layer.masksToBounds = true
        
        initializeConstraints()
    }
    
    private func initializeConstraints() {
        let layoutGuide = view.safeAreaLayoutGuide
        
        blurView.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor).isActive = true
        blurView.centerYAnchor.constraint(equalTo: layoutGuide.centerYAnchor).isActive = true
        blurView.widthAnchor.constraint(equalTo: layoutGuide.widthAnchor, multiplier: 0.9).isActive = true
        blurView.heightAnchor.constraint(equalTo: tableView.heightAnchor).isActive = true
        
        tableView.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor).isActive = true
        tableView.centerYAnchor.constraint(equalTo: layoutGuide.centerYAnchor).isActive = true
        tableView.widthAnchor.constraint(equalTo: blurView.widthAnchor).isActive = true
        tableViewHeightAnchor = tableView.heightAnchor.constraint(equalToConstant: tableView.contentSize.height)
        tableViewHeightAnchor?.isActive = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableViewHeightAnchor?.constant = tableView.contentSize.height
    }
    
    @objc func doneButtonTapped(button: UIButton) {
        self.dismiss(animated: true, completion: nil)
        self.delegate?.willDismiss(transactionDetailViewController: self)
    }
    
    @objc func approveButtonTapped(button: UIButton) {
        
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayInformation.requiresApproval ? 6 : 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == TransactionDetailInformationIndex.lineItems.rawValue {
            let height = CGFloat(((displayInformation.lineItems.count - 1) * 20) + 25 + 30)
            return height
        }
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let index = TransactionDetailInformationIndex(rawValue: indexPath.row) else {
            assertionFailure()
            return UITableViewCell()
        }
        
        switch index {
        case .header:
            let cell = tableView.dequeueReusableCell(withIdentifier: headerCellReuseIdentifier) as! TransactionDetailHeaderTableViewCell
            cell.doneButton.setTitle(displayInformation.requiresApproval ? "Cancel" : "Done", for: .normal)
            cell.doneButton.addTarget(self, action: #selector(doneButtonTapped(button:)), for: .primaryActionTriggered)
            cell.addSeparatorWithInset(0)
            return cell
        case .to:
            let cell = tableView.dequeueReusableCell(withIdentifier: informationCellReuseIdentifier) as! TransactionDetailInformationTableViewCell
            cell.titleLabel.text = "WALLET"
            cell.label1.text = displayInformation.walletName
            cell.label2.text = displayInformation.walletBalanance
            cell.addSeparatorWithInset(15)
            return cell
        case .from:
            let cell = tableView.dequeueReusableCell(withIdentifier: informationCellReuseIdentifier) as! TransactionDetailInformationTableViewCell
            cell.titleLabel.text = "TO"
            cell.label1.text = displayInformation.recipientName
            cell.label2.text = displayInformation.recipientDetail
            cell.addSeparatorWithInset(15)
            return cell
        case .description:
            let cell = tableView.dequeueReusableCell(withIdentifier: informationCellReuseIdentifier) as! TransactionDetailInformationTableViewCell
            cell.titleLabel.text = displayInformation.messageTitle
            cell.label1.text = displayInformation.messageText
            cell.addSeparatorWithInset(15)
            return cell
        case .lineItems:
            let cell = tableView.dequeueReusableCell(withIdentifier: lineItemCellReuseIdentifier) as! TransactionLineItemTableViewCell
            cell.lineItems = displayInformation.lineItems
            if displayInformation.requiresApproval {
                cell.addSeparatorWithInset(0)
            }
            return cell
        case .approve:
            let cell = tableView.dequeueReusableCell(withIdentifier: approveCellReuseIdentifier) as! TransactionApproveTableViewCell
            cell.approveButton.addTarget(self, action: #selector(approveButtonTapped(button:)), for: .primaryActionTriggered)
            return cell
        }
    }
}
