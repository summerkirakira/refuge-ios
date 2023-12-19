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
//                        let user = try await parseNewUser(email: "", password: "", rsi_device: "ninv6pihctq8lnzkwaqimafsdf", rsi_token: "f28f2f29020fe3852694d6210ee81214")
//                        if user != nil {
//                            userRepo.setCurrentUser(user: user!)
//                            try await userRepo.save()
//                        }
                        await appInit()
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

