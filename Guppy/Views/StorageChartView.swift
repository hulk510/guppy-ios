//
//  StorageChartView.swift
//  Guppy
//
//  Created by 後藤遥 on 2023/02/10.
//

import SwiftUI
import Charts

struct ToggleLedgend<Content: View> : View {
    @Binding var isShowLedgend: Bool
    let content: Content
    init(isShowLedgend: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self.content = content()
        self._isShowLedgend = isShowLedgend
    }

    var body: some View {
        content
            .chartLegend(isShowLedgend ? .visible : .hidden )
            .frame(height: isShowLedgend ? 32 : 4)

    }
}

struct StorageChartView: View {
    var data: [Activity]

    var body: some View {
        Chart(data) { element in
            BarMark(
                x: .value("Data Size", element.usedTime)
            )
            .foregroundStyle(by: .value("Data Category", element.category?.name ?? ""))
        }
        .animation(.easeInOut, value: data)
        .chartPlotStyle { plotArea in
            plotArea
                .background(Color(.systemFill))
                .cornerRadius(8)
        }
        .chartXAxis(.hidden)
        .chartXScale(domain: 0...24)
    }
}

struct StorageChartView_Previews: PreviewProvider {
    static var previews: some View {
        StorageChartView(data: [])
        .frame(height: 32)
    }
}
