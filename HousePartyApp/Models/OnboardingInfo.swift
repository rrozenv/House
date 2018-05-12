
import Foundation

struct OnboardingInfo {
    let pageNumber: Int
    let header: String
    let body: String
    let buttonTitle: String
}

extension OnboardingInfo {
    static var initalOnboardingInfo: [OnboardingInfo] {
        let page0 = OnboardingInfo(pageNumber: 0,
                                   header: "This is the first page",
                                   body: "This is the first body",
                                   buttonTitle: "Button 1")
        let page1 = OnboardingInfo(pageNumber: 1,
                                   header: "This is the second page",
                                   body: "This is the second body",
                                   buttonTitle: "Button 2")
        return [page0, page1]
    }
    
    static var promptPageTutorial: [OnboardingInfo] {
        let page0 = OnboardingInfo(pageNumber: 0,
                                   header: "Posts created by other users live here.",
                                   body: "PUBLIC posts are viewable by everyone. PRIVATE posts are those which friends have shared with you.",
                                   buttonTitle: "Got It")
        let page1 = OnboardingInfo(pageNumber: 1,
                                   header: "One more thing...",
                                   body: "Tapping the Outpost icon in the top center will switch between viewing modes. Tap it now to see the latest news from the web.",
                                   buttonTitle: "Button 2")
        return [page0, page1]
    }
}
