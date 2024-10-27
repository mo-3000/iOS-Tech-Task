//
//  UIViewController+LoadingIndicator.swift
//  MoneyBox
//
//  Created by Mohammed Ali on 24/10/2024.
//

import UIKit

private var loadingOverlay: UIView?

extension UIViewController {
    
    // MARK: - Public Methods
    
    func showLoadingIndicator(over view: UIView) {
        createLoadingOverlay(for: view)
    }
    
    func hideLoadingIndicator() {
        DispatchQueue.main.async {
            loadingOverlay?.removeFromSuperview()
            loadingOverlay = nil
        }
    }
    
    // MARK: - Private Methods
    
    private func createLoadingOverlay(for view: UIView) {
        let overlay = UIView(frame: view.bounds)
        overlay.backgroundColor = .white
        
        let activityIndicator = createActivityIndicator()
        let imageView = createImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .mutedBlue
        
        DispatchQueue.main.async {
            overlay.addSubview(imageView)
            overlay.addSubview(activityIndicator)
            
            NSLayoutConstraint.activate([
                imageView.centerXAnchor.constraint(equalTo: overlay.centerXAnchor),
                imageView.centerYAnchor.constraint(equalTo: overlay.centerYAnchor, constant: -50),
                imageView.widthAnchor.constraint(equalToConstant: 200),
                
                activityIndicator.centerXAnchor.constraint(equalTo: overlay.centerXAnchor),
                activityIndicator.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20)
            ])
            
            view.addSubview(overlay)
        }
        
        loadingOverlay = overlay
    }
    
    private func createActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.startAnimating()
        activityIndicator.color = .systemGray
        return activityIndicator
    }
    
    private func createImageView() -> UIImageView {
        let imageView = UIImageView(image: UIImage(named: "moneybox"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
}
