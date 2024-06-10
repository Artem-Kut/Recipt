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
        List {
            ForEach(viewModel.receipts) { receipt in
                ReceiptCellView(url: receipt.urlImage, name: receipt.name)
            }
        }
        .scrollContentBackground(.hidden)
    }
}

#Preview {
    ReceiptsList()
}
