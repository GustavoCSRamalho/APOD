import Foundation

final class MockAPODService: APODServiceProtocol {
    func fetchAPOD(for date: String?) async throws -> APOD {
        return APOD(
            date: "2025-09-12",
            explanation: "September's total lunar eclipse is tracked across night skies from both the northern and southern hemispheres of planet Earth in these two dramatic timelapse series. In the northern hemisphere sequence (top panel) the Moon’s trail arcs from the upper left to the lower right. It passes below bright planet Saturn, seen under mostly clear skies from the international campus of Zhejiang University in China at about 30 degrees north latitude. In contrast, the southern hemisphere view from Lake Griffin, Canberra, Australia at 35 degrees south latitude, records the Moon’s trail from the upper right to the lower left. Multiple lightning flashes from thunderstorms near the horizon appear reflected in the lake. Both sequences were photographed with 16mm wide-angle lenses and both cover the entire eclipse, with the darkened red Moon totally immersed in Earth's umbral shadow near center. But the different orientations of the Moon’s path across the sky reveal the perspective shifts caused by the views from northern vs. southern latitudes.",
            hdurl: "https://apod.nasa.gov/apod/image/2509/APODtwo_hemisphere_combined_no_text.jpg",
            media_type: "image",
            service_version: "v1",
            title: "Lunar Eclipse in Two Hemispheres",
            url: "https://apod.nasa.gov/apod/image/2509/APODtwo_hemisphere_combined_no_text1065.jpg"
        )
    }

    func fetchRange(startDate: String, endDate: String) async throws -> [APOD] {
        []
    }

    func fetchRandom(count: Int) async throws -> [APOD] {
        []
    }
}
