//
//  UserStorageListView.swift
//  Guppy
//
//  Created by 後藤遥 on 2023/02/09.
//

import SwiftUI

struct UserStorageListView: View {
    
    @State private var selection = 0
    private var totalSize: Double {
        data.reduce(0) { $0 + $1.usedTime}
    }
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "startTime", ascending: true)], predicate: NSPredicate(format: "createdAt >= %@ AND createdAt <= %@", Date().startOfDay as CVarArg, Date().endOfDay as CVarArg))
    var data: FetchedResults<Activity>
    
    var storageView: some View {
        VStack {
            HStack {
                Text("はるかの一日")
                    .foregroundColor(Color.navy)
                Spacer()
                HStack {
                    Text("400日目")
                        .font(.caption)
                        .foregroundColor(Color.navy)
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                        .background(Color.gold)
                        .mask(RoundedRectangle(cornerRadius: 8))
                    Image("fugu")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                        .padding(4)
                        .rotationEffect(.degrees(15))
                }
            }
            .font(.caption)
            StorageChartView(data: data.compactMap {$0}.sorted {$0.category?.name ?? "" < $1.category?.name ?? ""})
                .frame(height: 32)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.beige
                    .ignoresSafeArea()
                
                VStack {
                    Picker("表示", selection: $selection) {
                        Text("みんなの一日")
                            .tag(0)
                        Text("職業別")
                            .tag(1)
                        
                    }
                    .pickerStyle(.segmented)
                    Spacer()
                    List(0..<30) {
                        _ in
                        storageView
                        .listRowBackground(Color.beige)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 4, leading: 24, bottom: 4, trailing: 24))
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    Spacer()
                }
            }
            .navigationTitle("2022年1月31日")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct UserStorageListView_Previews: PreviewProvider {
    static var previews: some View {
        UserStorageListView()
    }
}
