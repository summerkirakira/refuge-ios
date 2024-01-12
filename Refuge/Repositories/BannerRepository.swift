//
//  BannerRepository.swift
//  Refuge
//
//  Created by Summerkirakira on 2023/12/22.
//

import Foundation

public class BannerRepository: ObservableObject{
    @Published var banners: [Banner] = []
    
    static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                       in: .userDomainMask,
                                       appropriateFor: nil,
                                       create: false)
            .appendingPathComponent("banners.data")
    }
    
    
    func loadSync() {
        do {
            let fileURL = try BannerRepository.fileURL()
            let banners = try loadArrayFromJSON(Banner.self, from: fileURL)
            self.banners = banners
        } catch {
            self.banners = []
        }
    }
    
    func saveSync(banners: [Banner]) {
        do {
            let outfile = try BannerRepository.fileURL()
            try saveArrayAsJSON(banners, to: outfile)
            self.banners = banners

        } catch {

        }
    }
    
    func refresh() async {
        let newBanners = await CirnoApi.getBanners()
        if newBanners.count == 0 {
            return
        } else {
            self.banners = newBanners
            self.saveSync(banners: newBanners)
        }
    }
    
}

public let bannerRepo = BannerRepository()
