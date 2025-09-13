import Foundation

struct AppStrings {
    struct Home {
        static let title = "NASA APOD"
        static let menuList = "List"
        static let menuFavorites = "Favorites"
        static let progressIdle = "Ready"
        static let progressLoading = "Carregando..."
        static let mediaNotAvailable = "Media not available"
        static let favorite = "Favorite"
        static let unfavorite = "Unfavorite"
        static let retry = "Tentar novamente"
        static let errorPrefix = "Erro: "
    }
    
    struct Favorites {
        static let title = "Favorites"
        static let emptyMessage = "No favorites yet"
    }
    
    struct List {
        static let title = "List"
        static let progressLoading = "Loading..."
        static let errorPrefix = "Error: "
    }
    
    struct Detail {
        static let title = "Details"
        static let datePrefix = "Date: "
        static let favorite = "Favorite"
        static let unfavorite = "Unfavorite"
        static let mediaNotAvailable = "Media not available"
    }
    
    struct Row {
        static let noTitle = "No title"
    }
}
