import SwiftUI

struct HistoryView: View {
    
    private let storageService = SoundStorageService.shared
    
    @State var data: [SoundModel] = []
    
    @State private var isEmpty: Bool = true
    @State private var isLoading: Bool = false
    
    private var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.dateFormat = "dd.MM.YY HH:mm"
        return dateFormatter
    }
    
    init() {
        setupNavigation()
    }
    
    var body: some View {
        NavigationView {
            if isLoading {
                ZStack {
                    Constants.Colors.BACKGROUND
                        .ignoresSafeArea()
                    ProgressView()
                        .scaleEffect(1.5)
                }
            } else {
                if data.isEmpty {
                    ZStack {
                        Constants.Colors.BACKGROUND
                            .ignoresSafeArea()
                        VStack(spacing: 40) {
                            Image(systemName: "list.bullet")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100)
                            VStack(spacing: 10) {
                                Text("Data is empty")
                                    .font(.custom(Constants.Fonts.BOLD, size: 22))
                                Text("Record the data once it appears on this screen.")
                                    .font(.custom(Constants.Fonts.REGULAR, size: 14))
                            }
                        }
                        .foregroundColor(Constants.Colors.FOREGROUND)
                    }
                } else {
                    List {
                        ForEach(data, id: \.id) { value in
                            let sum = value.dbArray.reduce(0, +)
                            let average = value.dbArray.isEmpty ? 0 : Double(sum) / Double(value.dbArray.count)
                            VStack {
                                HStack {
                                    
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text("max:")
                                                .font(.custom(Constants.Fonts.REGULAR, size: 16))
                                            Text("\(value.dbArray.max() ?? 0) dB")
                                                .font(.custom(Constants.Fonts.MEDIUM, size: 16))
                                                .foregroundStyle(Constants.Colors.SECOND_ACCENT)
                                        }
                                        
                                        HStack {
                                            Text("avg:")
                                                .font(.custom(Constants.Fonts.REGULAR, size: 16))
                                            Text("\(Int(average)) dB")
                                                .font(.custom(Constants.Fonts.MEDIUM, size: 16))
                                                .foregroundStyle(Constants.Colors.SECOND_ACCENT)
                                        }
                                    }
                                    
                                    VStack(alignment: .leading) {
                                        
                                        HStack {
                                            Text("min:")
                                                .font(.custom(Constants.Fonts.REGULAR, size: 16))
                                            Text("\(value.dbArray.min() ?? 0) db")
                                                .font(.custom(Constants.Fonts.MEDIUM, size: 16))
                                                .foregroundStyle(Constants.Colors.SECOND_ACCENT)
                                            Spacer()
                                            Text(dateFormatter.string(from: value.date))
                                                .font(.custom(Constants.Fonts.MEDIUM, size: 14))
                                                .foregroundStyle(Constants.Colors.FIRST_ACCENT)
                                        }
                                        
                                        HStack {
                                            Text("dur: ")
                                                .font(.custom(Constants.Fonts.REGULAR, size: 16))
                                            Text("\(value.dbArray.count) sec")
                                                .font(.custom(Constants.Fonts.MEDIUM, size: 16))
                                                .foregroundStyle(Constants.Colors.SECOND_ACCENT)
                                        }
                                    }
                                    Spacer()
                                }
                                LineChartView(data: value.dbArray)
                                    .padding()
                                    .frame(height: 200)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 25, style: .continuous)
                                    .foregroundStyle(Constants.Colors.FOREGROUND)
                            )
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Constants.Colors.BACKGROUND)
                        .listRowSeparatorTint(Constants.Colors.FOREGROUND)
                        .listRowBackground(Color.clear)
                        .listSectionSeparator(.hidden)
                    }
                    .listStyle(.plain)
                    .background(Constants.Colors.BACKGROUND)
                    .navigationViewStyle(.stack)
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationTitle(TabType.history.title)
                }
            }
        }
        .modifyView(body: {
            if #available(iOS 16.0, *) {
                $0
                    .scrollContentBackground(.hidden)
                    .scrollIndicators(.hidden)
            } else {
                $0
                    .onAppear(perform: {
                        setupList()
                    })
            }
        })
        .onAppear(perform: {
            DispatchQueue.main.async {
                storageService.fetchData(completion: { array in
                    data = array
                    isLoading = false
                })
            }
        })
    }

}

#Preview {
    HistoryView()
}

