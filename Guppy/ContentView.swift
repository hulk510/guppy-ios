//
//  ContentView.swift
//  Guppy
//
//  Created by 後藤遥 on 2023/02/07.
//

import SwiftUI
import CoreData

struct ContentView: View {
    var body: some View {
        TabView {
            TimelineView()
                .tag(0)
                .tabItem {
                    Image(systemName: "house")
                    Text("ホーム")
                }
            UserStorageListView()
                .tag(1)
                .tabItem {
                    Image(systemName: "calendar")
                    Text("みんなの一日")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
