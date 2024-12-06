//
//  AccountDetailView.swift
//  MoneyBox
//
//  Created by Mohammed Ali on 24/10/2024.
//

import SwiftUI
import Combine

struct AccountDetailView: View {
    @ObservedObject private var viewModel: AccountDetailViewModel
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    // MARK: - Initializer
    init(viewModel: AccountDetailViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            headerView
                .edgesIgnoringSafeArea(.top)
                .frame(height: 180)
            
            ScrollView {
                VStack(alignment: .center, spacing: 0) {
                    moneyBoxCard
                        .padding(.top, 32)
                    
                    depositButton
                        .padding(.top, 32)
                        .padding(.horizontal, 16)
                        .frame(height: 56)

                    withdrawButton
                        .padding(.top, 40)
                        .padding(.horizontal, 16)
                        .frame(height: 56)
                        .padding(.bottom, 12)
                }
            }
            .background(Color(.systemBackground))
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(viewModel.account.displayName ?? "")
                    .foregroundColor(.white)
                    .font(.headline)
            }
        }
        .onReceive(viewModel.didAddMoney) { amount in
            withAnimation {
                _ = viewModel.increaseAmount(by: amount)
            }
            generateHapticFeedback()
        }
        .onReceive(viewModel.addMoneyFailure) { message in
            showAlert(message: message)
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Oops!"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    // MARK: - Header View
    private var headerView: some View {
        ZStack {
            Color(hex: viewModel.account.colorCodeHex ?? "000000")
            BlurView(style: .systemUltraThinMaterialDark)
            
            VStack(spacing: 8) {
                balanceSection
                aprRateLabel
            }
            .padding(.top, 72)
        }
    }

    // MARK: - Balance Section
    private var balanceSection: some View {
        VStack(spacing: 8) {
            Text("TOTAL BALANCE")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.secondary)
            
            Text(
                viewModel.account.totalPlanValue?.formatAsCurrencyAttributedStringSwiftUI(
                    primaryFontSize: 48,
                    secondaryFontSize: 24
                ) ?? "Unknown"
            )
            .font(.system(size: 48, weight: .bold))
            .foregroundColor(.primary)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(
            "Total Balance \(viewModel.account.totalPlanValue?.formatAsCurrencyAttributedStringSwiftUI(primaryFontSize: 48, secondaryFontSize: 24) ?? "Unknown")"
        )
    }

    // MARK: - APR Rate Label
    private var aprRateLabel: some View {
        Text("Earning \(viewModel.account.earningsPercentage ?? 0.0, specifier: "%.2f")% APR")
            .font(.caption)
            .padding(8)
            .background(Color.black)
            .foregroundColor(.white)
            .clipShape(Capsule())
    }

    // MARK: - MoneyBox Card with Blur Background
    private var moneyBoxCard: some View {
        ZStack(alignment: .topLeading) {
            Color(hex: viewModel.account.colorCodeHex ?? "000000")
                .opacity(0.3)
                .cornerRadius(16)
                .frame(height: 120)

            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("MoneyBox")
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(Color(hex: viewModel.account.colorCodeHex ?? "000000"))
                        .padding(.top, 16)
                    
                    Text(
                        (viewModel.account.availableMoneyBox ?? 0).formatAsCurrencyAttributedStringSwiftUI(
                            primaryFontSize: 32,
                            secondaryFontSize: 16
                        )
                    )
                    .frame(maxHeight: .infinity, alignment: .center)
                }
                .padding(.leading, 20)

                Spacer()

                if let url = URL(string: viewModel.account.productLogoURL ?? "") {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image.resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                        case .failure:
                            Image(systemName: "banknote.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                        }
                    }
                    .padding(.trailing, 20)
                } else {
                    Image(systemName: "banknote.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .padding(.trailing, 20)
                }
            }
            .frame(height: 120)
        }
        .padding(.horizontal, 16)
    }


    // MARK: - Action Buttons
    private var depositButton: some View {
        Button(action: handleDeposit) {
            Label("Add Money", systemImage: "plus.circle.fill")
                .font(.headline)
        }
        .buttonStyle(MainButtonStyle(backgroundColor: Color(hex: viewModel.account.colorCodeHex ?? "000000")))
    }

    private var withdrawButton: some View {
        Button(action: {
            // Handle withdraw action
        }) {
            Label("Withdraw", systemImage: "arrow.down.circle.fill")
                .font(.headline)
        }
        .buttonStyle(MainButtonStyle(backgroundColor: Color(.secondarySystemBackground), foregroundColor: .primary))
    }

    // MARK: - Helper Functions
    private func handleDeposit() {
        withAnimation {
            viewModel.addMoney(amount: 10)
        }
    }

    private func showAlert(message: String) {
        alertMessage = message
        showAlert = true
    }

    private func generateHapticFeedback() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}
