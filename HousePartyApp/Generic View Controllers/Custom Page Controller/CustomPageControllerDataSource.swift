
import Foundation
import UIKit

final class CustomPageControllerDataSource: NSObject, UIPageViewControllerDataSource {
    
    private var viewControllers: [UIViewController]
    
    internal init(viewControllers: [UIViewController]) {
        self.viewControllers = viewControllers
    }

    internal func indexFor(controller: UIViewController) -> Int? {
        return self.viewControllers.index(of: controller)
    }
    
    internal func controllerFor(index: Int) -> UIViewController? {
        guard index >= 0 && index < self.viewControllers.count else { return nil }
        return self.viewControllers[index]
    }
    
    internal func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let pageIdx = self.viewControllers.index(of: viewController) else {
            fatalError("Couldn't find \(viewController) in \(self.viewControllers)")
        }
        
        let nextPageIdx = pageIdx + 1
        guard nextPageIdx < self.viewControllers.count else {
            return nil
        }
        
        return self.viewControllers[nextPageIdx]
    }
    
    internal func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let pageIdx = self.viewControllers.index(of: viewController) else {
            fatalError("Couldn't find \(viewController) in \(self.viewControllers)")
        }
        
        let previousPageIdx = pageIdx - 1
        guard previousPageIdx >= 0 else {
            return nil
        }
        
        return self.viewControllers[previousPageIdx]
    }
}
