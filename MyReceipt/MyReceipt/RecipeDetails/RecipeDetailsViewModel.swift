//
//  RecipeDetailsViewModel.swift
//  MyReceipt
//
//  Created by Artem Kutasevych on 6/10/24.
//

import Foundation
import Combine

class RecipeDetailsViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private let receiptService: ReceiptServiceProtocol
    var receipt: ReceiptDescription?
    @Published var viewState: ViewState = .loading
    init(receiptService: ReceiptServiceProtocol) {
        self.receiptService = receiptService
    }
    func fetchReceipt(with id: String) {
        receiptService.getReceipt(with: id)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] response in
                guard let self else { return }
                self.viewState = .success
                self.receipt = response.meals.first
            })
            .store(in: &cancellables)
    }
}
