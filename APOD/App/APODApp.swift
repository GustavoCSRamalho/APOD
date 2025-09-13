import SwiftUI

@main
struct NasaAPODApp: App {
    let diContainer = AppDIContainer()
     
     var body: some Scene {
         WindowGroup {
             diContainer.makeHomeView()
         }
     }
}
