//
//  BottomContentView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 14/05/22.
//

import PDFKit
import SwiftUI

struct BottomContentView: View {
    @ObservedObject var homeVM: HomeViewModel
    @ObservedObject var dataVM: DataViewModel
    @ObservedObject var utilityVM: UtilityViewModel
    @ObservedObject var categoryVM: CategoryViewModel
    @StateObject var pdfVM = PdfViewModel()

    @State private var viewAllNumbers = false
    @State private var viewAllDocuments = false
    @State private var viewAllEvents = false
    @State private var showEventEdit = false

    @State private var showingOptions = false

    @State private var presentImporter = false
    @State private var showPDF = false

    var body: some View {
        VStack(spacing: 0) {
            // MARK: LAST EVENTS

            TitleSectionComponent(sectionTitle: "Last events", binding: $viewAllEvents)
                .padding()
                .padding(.top, 10)
                .padding(.bottom, -10)
                .sheet(isPresented: $viewAllEvents) { LastEventsListView(dataVM: dataVM, categoryVM: categoryVM, utilityVM: utilityVM) }

            if dataVM.expenseList.isEmpty {
                HStack {
                    Text(LocalizedStringKey("There are no events to show"))
                        .font(Typography.TextM)
                        .foregroundColor(Palette.greyMiddle)
                    Spacer()
                }
                .padding()
            } else {
                ForEach(dataVM.expenseList.reversed().prefix(3), id: \.self) { expense in
                    Button(action: {
                        utilityVM.expenseToEdit = ExpenseState.fromExpenseViewModel(vm: expense)
                        showEventEdit.toggle()
                    }, label: {
                        CategoryComponent(
                            category: Category(rawValue: Int(expense.category)) ?? .other,
                            date: expense.date, cost: String(expense.price)
                        )
                    })
                }
            }

            // MARK: DOCUMENTS

            HStack {
                Text("Documents")
                    .foregroundColor(Palette.black)
                    .font(Typography.headerL)
                Spacer()
            }.padding()
                .padding(.top, 10)
                .padding(.bottom, -10)

            ScrollView(.horizontal, showsIndicators: false) {
                VStack {
                    Spacer(minLength: 12)
                    HStack {
                        ForEach(dataVM.documentsList, id: \.self) { document in
                            Button(action: {
                                showPDF.toggle()
                                pdfVM.documentState = DocumentState.fromDocumentViewModel(vm: document)
                                pdfVM.loadBookmark()
                            }, label: {
                                documentComponent(title: document.title)
                            })
                        }
                        Button(action: {
                            presentImporter.toggle()
                        }, label: {
                            addComponent(title: "Add document")
                        })
                    }
                    Spacer(minLength: 16)
                }
                .fileImporter(isPresented: $presentImporter, allowedContentTypes: [.pdf]) { result in
                    switch result {
                    case let .success(url):
                        if url.startAccessingSecurityScopedResource() {
                            pdfVM.documentState.title = url.lastPathComponent.replacingOccurrences(of: ".pdf", with: "")
                            dataVM.addDocument(documentS: pdfVM.documentState, url: url)
                        }
                        url.stopAccessingSecurityScopedResource()
                    case let .failure(error):
                        print(error)
                    }
                }
            }
            .safeAreaInset(edge: .trailing, spacing: 0) {
                Spacer()
                    .frame(width: 16)
            }
            .safeAreaInset(edge: .leading, spacing: 0) {
                Spacer()
                    .frame(width: 16)
            }

            TitleSectionComponent(sectionTitle: "Useful contacts", binding: $viewAllNumbers)
                .padding()
                .padding(.top, 10)
                .padding(.bottom, -10)

            // MARK: IMPORTANT NUMBERS

            ScrollView(.horizontal, showsIndicators: false) {
                VStack {
                    Spacer(minLength: 12)
                    HStack {
                        ForEach(dataVM.numberList, id: \.self) { number in
                            Button(action: {
                                UIApplication.shared.open(URL(string: "tel://" + number.telephone)!)
                            }, label: {
                                importantNumbersComponent(title: number.title, number: number.telephone)
                            })
                        }
                        Button(action: {
                            DispatchQueue.main.asyncAfter(deadline: .now()) {
                                withAnimation(.easeInOut) {
                                    homeVM.showAlertNumbers.toggle()
                                }
                            }
                        }, label: {
                            addComponent(title: "Add contact")
                        })
                    }
                    Spacer(minLength: 16)
                }
            }
            .safeAreaInset(edge: .trailing, spacing: 0) {
                Spacer()
                    .frame(width: 16)
            }
            .safeAreaInset(edge: .leading, spacing: 0) {
                Spacer()
                    .frame(width: 16)
            }

            // Trick for scroll space, if you remove this you will see the problem
            Text("")
                .padding(.vertical, 55)
            Spacer()
        }
        .sheet(isPresented: $showEventEdit) {
            EditEventView(
                utilityVM: utilityVM,
                dataVM: dataVM, categoryVM: categoryVM,
                category: Category(rawValue: Int(utilityVM.expenseToEdit.category ?? 0)) ?? .other
            )
        }
        .sheet(isPresented: $viewAllNumbers, onDismiss: homeVM.resetAlertFieldsInside) {
            ImportantNumbersView(homeVM: homeVM, dataVM: dataVM)
                .interactiveDismissDisabled(homeVM.interactiveDismiss)
        }
        .fullScreenCover(isPresented: $viewAllDocuments) { WorkInProgress(dataVM: dataVM) }
        .fullScreenCover(isPresented: $showPDF) { DocumentView(pdfVM: pdfVM) }
    }

    @ViewBuilder
    func documentComponent(title: String) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack {
                Circle()
                    .frame(width: 24, height: 24)
                    .foregroundColor(Palette.greyLight)
                Image("documents")
                    .resizable()
                    .frame(width: 14, height: 14)
                    .foregroundColor(Palette.black)
            }
            Spacer()
            Text(title)
                .frame(width: UIScreen.main.bounds.width * 0.33, height: UIScreen.main.bounds.height * 0.03, alignment: .leading)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: false)
                .foregroundColor(Palette.black)
                .font(Typography.ControlS)
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width * 0.38, height: UIScreen.main.bounds.height * 0.13)
        .background {
            Rectangle()
                .cornerRadius(8)
                .foregroundColor(Palette.white)
                .shadowGrey()
        }
    }

    @ViewBuilder
    func importantNumbersComponent(title: String, number: String) -> some View {
        ZStack {
            Rectangle()
                .cornerRadius(8)
                .foregroundColor(Palette.white)
                .shadowGrey()
                .frame(width: UIScreen.main.bounds.width * 0.38, height: UIScreen.main.bounds.height * 0.13)
            VStack(alignment: .leading, spacing: 22) {
                ZStack {
                    Circle()
                        .frame(width: 24, height: 24)
                        .foregroundColor(Palette.greyLight)
                    Image("Service")
                        .resizable()
                        .frame(width: 14, height: 14)
                        .foregroundColor(Palette.black)
                }
                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .foregroundColor(Palette.black)
                        .font(Typography.ControlS)
                    Text(number)
                        .foregroundColor(Palette.greyMiddle)
                        .font(Typography.TextM)
                        .lineLimit(1)
                        .frame(width: UIScreen.main.bounds.width * 0.25, alignment: .leading)
                }
            }
            .padding(.leading, -34)
            .padding(.top, -2)
        }
    }

    @ViewBuilder
    func addComponent(title: LocalizedStringKey) -> some View {
        ZStack {
            Rectangle()
                .cornerRadius(8)
                .frame(width: UIScreen.main.bounds.width * 0.38, height: UIScreen.main.bounds.height * 0.13)
                .foregroundColor(Palette.white)
                .shadowGrey()
            VStack(alignment: .center, spacing: 10) {
                Image("plus")
                    .foregroundColor(Palette.greyMiddle)
                Text(title)
                    .foregroundColor(Palette.greyMiddle)
                    .font(Typography.ControlS)
            }
        }
    }
}

// struct BottomContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        BottomContentView()
//
//    }
// }

struct CategoryComponent: View {
    var category: Category
    var date: Date
    var cost: String

    @ObservedObject var utilityVM = UtilityViewModel()

    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .frame(width: 32, height: 32)
                    .foregroundColor(category.color)
                Image(category.icon)
                    .resizable()
                    .frame(width: 16, height: 16)
            }
            VStack(alignment: .leading) {
                HStack {
                    Text(category.label)
                        .foregroundColor(Palette.black)
                        .font(Typography.headerS)
                    Spacer()
                    Text("-\(cost) \(utilityVM.currency)")
                        .foregroundColor(Palette.greyHard)
                        .font(Typography.headerS)
                        .padding(.trailing, -10)
                }
                Text(date.formatDate())
                    .foregroundColor(Palette.greyMiddle)
                    .font(Typography.TextM)
            }
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
}

struct TitleSectionComponent: View {
    var sectionTitle: LocalizedStringKey
    @Binding var binding: Bool

    var body: some View {
        HStack {
            Text(sectionTitle)
                .foregroundColor(Palette.black)
                .font(Typography.headerL)
            Spacer()
            HStack {
                Button(action: {
                    binding.toggle()
                }, label: {
                    Text("View all")
                        .font(Typography.ControlS)
                        .foregroundColor(Palette.greyMiddle)

                })
            }
        }
    }
}

extension Date {
    func formatDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("MMM d, EE")
        return dateFormatter.string(from: self)
    }
}
