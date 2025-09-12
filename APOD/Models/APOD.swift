import Foundation

struct APOD: Codable, Identifiable {
    public var id: String { date }
    let date: String
    let explanation: String?
    let hdurl: String?
    let media_type: String
    let service_version: String?
    let title: String?
    let url: String?

    enum CodingKeys: String, CodingKey {
        case date, explanation, hdurl, media_type, service_version, title, url
    }
}
