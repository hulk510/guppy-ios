//
//  StorageView.swift
//  Guppy
//
//  Created by 後藤遥 on 2023/02/09.
//

import SwiftUI
import Charts

struct StorageView: View {
    // FIXME: できれば使った時間が多い順になるように並び替えたい
    // 今はカテゴリごとにまとめるように並べてるだけ
    var data: [Activity]
    @State private var isShowLedgend = true // 項目の色分けテキストを表示するかどうか
    private var totalSize: Double {
        data.reduce(0) { $0 + $1.usedTime}
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("はるかの一日")
                    .foregroundColor(Color.navy)
                Spacer()
                Text("\(totalSize, specifier: "%.1f")h of 24h Used")
                    .foregroundColor(.secondary)
                Image(systemName: isShowLedgend ? "chevron.down" : "chevron.up")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 12, height: 12)
                    .foregroundColor(.secondary)
                    .padding(4)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation {
                            isShowLedgend.toggle()
                        }
                    }
            }
            .font(.caption)
            ToggleLedgend(isShowLedgend: $isShowLedgend) {
                StorageChartView(data: data)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

struct StorageView_Previews: PreviewProvider {
    static var previews: some View {
        StorageView(data: [])
            .padding()
    }
}
