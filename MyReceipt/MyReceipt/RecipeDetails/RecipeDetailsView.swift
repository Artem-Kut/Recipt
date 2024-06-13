//
//  RecipeDetailsView.swift
//  MyReceipt
//
//  Created by Artem Kutasevych on 6/10/24.
//

import SwiftUI

struct RecipeDetailsView: View {
    let id: String
    @StateObject private var viewModel = RecipeDetailsViewModel(receiptService: ReceiptService())
    var body: some View {
        if viewModel.viewState == .loading {
            ProgressView()
                .onAppear {
                    viewModel.fetchReceipt(with: id)
                }
        } else {
            ScrollView {
                VStack {
                    AsyncImage(url: URL(string: viewModel.receipt?.receipt.urlImage ?? "")) { phase in
                        switch phase {
                        case .failure:
                            Image(systemName: "photo")
                                .font(.largeTitle)
                        case .success(let image):
                            image
                                .resizable()
                        default:
                            ProgressView()
                        }
                    }
                    .frame(width: 300, height: 300)
                    .clipShape(.rect(cornerRadius: 10))
                    Text(viewModel.receipt?.receipt.name ?? "")
                        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 0))
                        .font(.system(size: 24))
                        .bold()
                        .multilineTextAlignment(.center)
                    Grid(alignment: .leading, horizontalSpacing: 10, verticalSpacing: 10) {
                        GridRow {
                            Text("Ingredient")
                            Spacer(minLength: 24)
                            Text("Measure")
                        }
                        .bold()
                        Divider()
                        ForEach(viewModel.receipt?.ingredients ?? []) { ingredient in
                            GridRow {
                                Text(ingredient.ingredient)
                                Spacer(minLength: 24)
                                Text(ingredient.measure)
                                    .bold()
                            }
                            GridRow {
                                Rectangle()
                                    .fill(.secondary)
                                    .frame(height: 1)
                                    .gridCellColumns(3)
                                    .gridCellUnsizedAxes([.horizontal])
                            }
                        }
                    }
                    .padding()
                    Text(viewModel.receipt?.instructions ?? "")
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }
    }
}

#Preview {
    RecipeDetailsView(id: "52893")
}
