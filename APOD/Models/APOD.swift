import Foundation

struct APOD: Codable, Identifiable {
    public var id: String { date } // convenient id
    let date: String     // "YYYY-MM-DD"
    let explanation: String?
    let hdurl: String?
    let media_type: String // "image" or "video"
    let service_version: String?
    let title: String?
    let url: String?      // regular URL

    enum CodingKeys: String, CodingKey {
        case date, explanation, hdurl, media_type, service_version, title, url
    }
}
