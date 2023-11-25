//
//  RefugeApp.swift
//  Refuge
//
//  Created by Summerkirakira on 22/12/2022.
//

import SwiftUI

@main
struct RefugeApp: App {
    var body: some Scene {
        WindowGroup {
            ShipInfoTabView()
                .task {
                    do {
//                        repository.items.append(HangarItem.sampleData)
//                        try await repository.save()
                        try await repository.load()
                    } catch {
                        repository.items = []
                        do {
                            try await repository.save()
                        } catch {
                            fatalError("Error loading hangar items.")
                        }
                    }
                }
        }
    }
}

