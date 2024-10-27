//
//  AccountDetailViewController.swift
//  MoneyBox
//
//  Created by Mohammed Ali on 24/10/2024.
//

import UIKit

final class AccountDetailViewController: UIViewController {
    private var viewModel: AccountDetailViewModelProtocol
    
    // MARK: - UI Components
    private lazy var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: viewModel.account.colorCodeHex ?? "000000")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 0
        view.isAccessibilityElement = false
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var balanceHeaderLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.text = "TOTAL BALANCE"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isAccessibilityElement = true
        label.accessibilityTraits = .staticText
        label.alpha = 0
        return label
    }()
    
    private lazy var balanceAmountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.attributedText = viewModel.account.totalPlanValue?.formatAsCurrencyAttributedString(
            primaryFontSize: 48,
            secondaryFontSize: 24
        )
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isAccessibilityElement = true
        label.accessibilityTraits = .staticText
        label.alpha = 0
        return label
    }()
    
    private lazy var aprRateLabel: PillView = {
        let label = PillView()
        label.setText("Earning \(viewModel.account.earningsPercentage ?? 0.0)% APR")
        label.setColor(.black)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.alpha = 0
        return label
    }()
    
    private lazy var depositButton: UIButton = {
        let button = createMainButton(
            title: "Add Money",
            backgroundColor: UIColor(hex: viewModel.account.colorCodeHex ?? "000000") ?? .systemBlue,
            symbolName: "plus.circle.fill"
        )
        button.addTarget(self, action: #selector(handleDeposit), for: .touchUpInside)
        button.alpha = 0
        return button
    }()
    
    private lazy var withdrawButton: UIButton = {
        let button = createMainButton(
            title: "Withdraw",
            backgroundColor: .secondarySystemBackground,
            symbolName: "arrow.down.circle.fill",
            titleColor: .label
        )
        button.alpha = 0
        return button
    }()
    
    private lazy var moneyBoxView: CardView = {
        let card = CardView()
        card.backgroundColor = UIColor(hex: viewModel.account.colorCodeHex ?? "000000")?.withAlphaComponent(0.3)
        card.translatesAutoresizingMaskIntoConstraints = false
        card.alpha = 0
        return card
    }()
    
    private lazy var moneyBoxImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        loadMoneyBoxImage(into: imageView)
        return imageView
    }()
    
    // MARK: - Lifecycle
    init(viewModel: AccountDetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewHierarchy()
        registerCallbacks()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateContent()
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        view.backgroundColor = .systemBackground
        configureNavigationBar()
        setupMoneyBoxCard()
    }
    
    private func setupMoneyBoxCard() {
        moneyBoxView.configure(
            title: "MoneyBox",
            amount: viewModel.account.availableMoneyBox ?? 0,
            image: moneyBoxImageView
        )
    }
    
    private func createMainButton(
        title: String,
        backgroundColor: UIColor,
        symbolName: String,
        titleColor: UIColor = .white
    ) -> UIButton {
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .large
        config.baseBackgroundColor = backgroundColor
        config.baseForegroundColor = titleColor
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold)
        config.image = UIImage(systemName: symbolName, withConfiguration: imageConfig)
        
        config.imagePlacement = .leading
        config.imagePadding = 8
        
        let attributedString = AttributedString(title, attributes: AttributeContainer([
            .font: UIFont.systemFont(ofSize: 16, weight: .semibold)
        ]))
        config.attributedTitle = attributedString
        
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    private func loadMoneyBoxImage(into imageView: UIImageView) {
        Task {
            do {
                let image = try await AsyncImageFetcher().fetchImage(from: viewModel.account.productLogoURL)
                await MainActor.run {
                    UIView.transition(with: imageView,
                                      duration: 0.3,
                                      options: .transitionCrossDissolve) {
                        imageView.image = image
                    }
                }
            } catch {
                imageView.image = UIImage(systemName: "banknote.fill")
            }
        }
    }
    
    private func animateContent() {
        let views: [UIView] = [
            balanceHeaderLabel,
            balanceAmountLabel,
            aprRateLabel,
            moneyBoxView,
            depositButton,
            withdrawButton
        ]
        
        for (index, view) in views.enumerated() {
            UIView.animate(
                withDuration: 0.3,
                delay: Double(index) * 0.1,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0.5,
                options: .curveEaseOut
            ) {
                view.alpha = 1
                view.transform = .identity
            }
        }
    }
    
    private func setupViewHierarchy() {
        view.addSubview(headerView)
        headerView.addSubview(blurEffectView)
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        
        [balanceHeaderLabel, balanceAmountLabel, aprRateLabel,
         moneyBoxView, depositButton, withdrawButton].forEach {
            containerView.addSubview($0)
        }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 240),
            
            blurEffectView.topAnchor.constraint(equalTo: headerView.topAnchor),
            blurEffectView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            containerView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            balanceHeaderLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
            balanceHeaderLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            balanceAmountLabel.topAnchor.constraint(equalTo: balanceHeaderLabel.bottomAnchor, constant: 8),
            balanceAmountLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            aprRateLabel.topAnchor.constraint(equalTo: balanceAmountLabel.bottomAnchor),
            aprRateLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            moneyBoxView.topAnchor.constraint(equalTo: aprRateLabel.bottomAnchor, constant: 32),
            moneyBoxView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            moneyBoxView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            depositButton.topAnchor.constraint(equalTo: moneyBoxView.bottomAnchor, constant: 32),
            depositButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            depositButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            depositButton.heightAnchor.constraint(equalToConstant: 56),
            
            withdrawButton.topAnchor.constraint(equalTo: depositButton.bottomAnchor, constant: 12),
            withdrawButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            withdrawButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            withdrawButton.heightAnchor.constraint(equalToConstant: 56),
            withdrawButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -32)
        ])
    }
}

// MARK: - AccountDetailViewController Extensions
extension AccountDetailViewController {
    private func configureNavigationBar() {
        navigationItem.title = viewModel.account.displayName
        navigationItem.accessibilityLabel = viewModel.account.displayName
        navigationItem.accessibilityTraits = .header
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func registerCallbacks() {
        setupDepositSuccessHandler()
        setupDepositFailureHandler()
    }
    
    private func setupDepositSuccessHandler() {
        viewModel.didAddMoney = { [weak self] addAmount in
            if let amount = addAmount {
                self?.animateBalanceUpdate(amount: amount)
            }
        }
    }
    
    private func setupDepositFailureHandler() {
        viewModel.addMoneyFailure = { [weak self] error in
            self?.displayErrorAlert(message: error)
        }
    }
    
    private func displayErrorAlert(message: String?) {
        let alert = UIAlertController(
            title: "Oops!",
            message: message,
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        
        present(alert, animated: true)
    }
    
    @objc private func handleDeposit() {
        UIView.animate(
            withDuration: 0.1,
            animations: {
                self.depositButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            },
            completion: { _ in
                UIView.animate(withDuration: 0.1) {
                    self.depositButton.transform = .identity
                }
            }
        )
        
        viewModel.addMoney(amount: 10)
    }
    
    private func animateBalanceUpdate(amount: Double) {
        
        let updatedBalance = viewModel.increaseAmount(amount: amount)
        balanceAmountLabel.attributedText = updatedBalance.formatAsCurrencyAttributedString(
            primaryFontSize: 48,
            secondaryFontSize: 24
        )
        balanceAmountLabel.alpha = 0
        moneyBoxView.amountLabel.attributedText = amount.formatAsCurrencyAttributedString(
            primaryFontSize: 32,
            secondaryFontSize: 16
        )
        moneyBoxView.alpha = 0
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 1.0,
            options: .curveEaseInOut,
            animations: {
                self.balanceAmountLabel.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                self.balanceAmountLabel.alpha = 1
                
                self.moneyBoxView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                self.moneyBoxView.alpha = 1
            },
            completion: { _ in
                UIView.animate(
                    withDuration: 0.2,
                    delay: 0,
                    usingSpringWithDamping: 0.8,
                    initialSpringVelocity: 1.0,
                    options: .curveEaseOut,
                    animations: {
                        self.balanceAmountLabel.transform = .identity
                        self.moneyBoxView.transform = .identity
                    }
                )
            }
        )
        
        generateHapticFeedback()
    }
    
    
    private func generateHapticFeedback() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}
