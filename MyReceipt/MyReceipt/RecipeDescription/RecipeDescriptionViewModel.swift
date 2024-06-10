//
//  RecipeDescriptionViewModel.swift
//  MyReceipt
//
//  Created by Artem Kutasevych on 6/10/24.
//

import Foundation
import Combine

class RecipeDescriptionViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private let receiptService: ReceiptServiceProtocol
    @Published var receipt: ReceiptDescription?
    @Published var viewState: ViewState = .loading
    init(receiptService: ReceiptServiceProtocol, id: String) {
        self.receiptService = receiptService
        self.fetchReceipt(with: id)
    }
    private func fetchReceipt(with id: String) {
        receiptService.getReceipt(with: id)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] response in
                guard let self else { return }
                self.viewState = .success
                self.receipt = response
            }).store(in: &cancellables)
    }
}
