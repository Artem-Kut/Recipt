//
//  ReceiptsViewModel.swift
//  MyReceipt
//
//  Created by Artem Kutasevych on 6/10/24.
//

import Foundation
import Combine

enum ViewState {
    case loading
    case success
    case error
}

class ReceiptsViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private let receiptService: ReceiptServiceProtocol
    @Published var receipts: [Receipt] = []
    @Published var viewState: ViewState = .loading
    init(receiptService: ReceiptServiceProtocol) {
        self.receiptService = receiptService
        self.fetchReceipts()
    }
    private func fetchReceipts() {
        receiptService.getReceipts()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] response in
                guard let self else { return }
                self.viewState = .success
                self.receipts = response.meals
            }).store(in: &cancellables)
    }
}
