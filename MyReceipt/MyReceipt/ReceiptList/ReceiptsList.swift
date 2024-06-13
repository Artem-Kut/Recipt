//
//  ReceiptsList.swift
//  MyReceipt
//
//  Created by Artem Kutasevych on 6/10/24.
//

import SwiftUI

struct ReceiptsList: View {
    @StateObject private var viewModel = ReceiptsViewModel(receiptService: ReceiptService())
    var body: some View {
        if viewModel.viewState == .loading {
            ProgressView()
        } else {
            List {
                ForEach(viewModel.receipts) { receipt in
                    NavigationLink {
                        RecipeDetailsView(id: receipt.id)
                    } label: {
                        ReceiptCellView(url: receipt.urlImage, name: receipt.name)
                    }
                }
                .scrollContentBackground(.hidden)
            }
        }
    }
}

#Preview {
    ReceiptsList()
}
