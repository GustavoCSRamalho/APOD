import Foundation

final class MockAPODService: APODServiceProtocol {
    private let mockData: [APOD] = [
        APOD(
            date: "2025-09-03",
            explanation: "How soon do jets form when a supernova gives birth to a neutron star?  The Africa Nebula provides clues. ...",
            hdurl: "https://apod.nasa.gov/apod/image/2508/CirX1_English_960.jpg",
            media_type: "image",
            service_version: "v1",
            title: "Cir X-1: Jets in the Africa Nebula",
            url: "https://apod.nasa.gov/apod/image/2508/CirX1_English_960.jpg"
        ),
        APOD(
            date: "2025-09-04",
            explanation: "Magnificent spiral galaxy NGC 4565 is viewed edge-on from planet Earth. ...",
            hdurl: "https://apod.nasa.gov/apod/image/2509/NGC4565_APOD_sRGB.jpg",
            media_type: "image",
            service_version: "v1",
            title: "NGC 4565: Galaxy on Edge",
            url: "https://apod.nasa.gov/apod/image/2509/NGC4565_APOD_sRGB1024.jpg"
        ),
        APOD(
            date: "2025-09-05",
            explanation: "Also known as NGC 104, 47 Tucanae is a jewel of the southern sky. ...",
            hdurl: "https://apod.nasa.gov/apod/image/2509/crtastro_0352.jpg",
            media_type: "image",
            service_version: "v1",
            title: "47 Tucanae: Globular Star Cluster",
            url: "https://apod.nasa.gov/apod/image/2509/crtastro_0352_1024.jpg"
        ),
        APOD(
            date: "2025-09-06",
            explanation: "When the sun sets on September 7, the Full Moon will rise. ...",
            hdurl: "https://apod.nasa.gov/apod/image/2509/MangiabarcheTramonto.jpg",
            media_type: "image",
            service_version: "v1",
            title: "Sardinia Sunset",
            url: "https://apod.nasa.gov/apod/image/2509/MangiabarcheTramonto1060.jpg"
        ),
        APOD(
            date: "2025-09-07",
            explanation: "How much of planet Earth is made of water? Very little, actually. ...",
            hdurl: "https://apod.nasa.gov/apod/image/2509/WaterlessEarth2_woodshole_2520.jpg",
            media_type: "image",
            service_version: "v1",
            title: "All the Water on Planet Earth",
            url: "https://apod.nasa.gov/apod/image/2509/WaterlessEarth2_woodshole_960.jpg"
        ),
        APOD(
            date: "2025-09-08",
            explanation: "This butterfly can hatch planets. The nebula fanning out from the star IRAS 04302+2247 ...",
            hdurl: "https://apod.nasa.gov/apod/image/2509/IrasDisk_Webb_2045.jpg",
            media_type: "image",
            service_version: "v1",
            title: "IRAS 04302: Butterfly Disk Planet Formation",
            url: "https://apod.nasa.gov/apod/image/2509/IrasDisk_Webb_1080.jpg"
        ),
        APOD(
            date: "2025-09-09",
            explanation: "What's that rising up from the Earth? ...",
            hdurl: "https://apod.nasa.gov/apod/image/2509/JetIss_nasa_6604.jpg",
            media_type: "image",
            service_version: "v1",
            title: "Up from the Earth: Gigantic Jet Lightning",
            url: "https://apod.nasa.gov/apod/image/2509/JetIss_nasa_960.jpg"
        ),
        APOD(
            date: "2025-09-10",
            explanation: "It is one of the largest nebulas on the sky -- why isn't it better known? ...",
            hdurl: "https://apod.nasa.gov/apod/image/2509/GrLacerta_Moehring_5509.jpg",
            media_type: "image",
            service_version: "v1",
            title: "The Great Lacerta Nebula",
            url: "https://apod.nasa.gov/apod/image/2509/GrLacerta_Moehring_960.jpg"
        ),
        APOD(
            date: "2025-09-11",
            explanation: "The dark, inner shadow of planet Earth is called the umbra. ...",
            hdurl: "https://apod.nasa.gov/apod/image/2509/UmbraEarth.jpg",
            media_type: "image",
            service_version: "v1",
            title: "The Umbra of Earth",
            url: "https://apod.nasa.gov/apod/image/2509/UmbraEarth1050.jpg"
        ),
        APOD(
            date: "2025-09-12",
            explanation: "September's total lunar eclipse is tracked across night skies from both the northern and southern hemispheres ...",
            hdurl: "https://apod.nasa.gov/apod/image/2509/APODtwo_hemisphere_combined_no_text.jpg",
            media_type: "image",
            service_version: "v1",
            title: "Lunar Eclipse in Two Hemispheres",
            url: "https://apod.nasa.gov/apod/image/2509/APODtwo_hemisphere_combined_no_text1065.jpg"
        )
    ]
    
    func fetchAPOD(for date: String?) async -> Result<APOD, APIError> {
           if let found = mockData.first(where: { $0.date == date }) {
               return .success(found)
           } else if let last = mockData.last {
               return .success(last)
           } else {
               return .failure(.apiError(statusCode: 404))
           }
       }
       
       func fetchRange(startDate: String, endDate: String) async -> Result<[APOD], APIError> {
           let filtered = mockData.filter { $0.date >= startDate && $0.date <= endDate }
           if filtered.isEmpty {
               return .failure(.apiError(statusCode: 404))
           }
           return .success(filtered)
       }
       
       func fetchRandom(count: Int) async -> Result<[APOD], APIError> {
           guard !mockData.isEmpty else {
               return .failure(.apiError(statusCode: 404))
           }
           return .success(Array(mockData.shuffled().prefix(count)))
       }
}
