
import Foundation
import UIKit

class CustomPageViewController: UIViewController {
    
    var pageViewController: UIPageViewController!
    var dataSource: CustomPageControllerDataSource!
    var currentPageIndex = 0
    
    override func loadView() {
        super.loadView()
        setupPageController()
    }
    
    deinit { print("Onboarding Page VC deinit") }
    
    //MARK: - Public Methods
    
    func configurePagerDataSource() {
        self.pageViewController.dataSource = self.dataSource
        DispatchQueue.main.async {
            self.pageViewController.setViewControllers(
                [self.dataSource.controllerFor(index: 0)!],
                direction: .forward,
                animated: false,
                completion: nil
            )
        }
    }
    
    func transitionTo(viewController: UIViewController) {
        let currentPageIndex = dataSource.indexFor(controller: viewController) ?? 0
        self.currentPageIndex = currentPageIndex
        self.pageViewController.setViewControllers(
            [viewController],
            direction: .forward,
            animated: true,
            completion: nil
        )
    }
    
}

extension CustomPageViewController {
    
    private func setPageViewControllerScrollEnabled(_ enabled: Bool) {
        self.pageViewController.dataSource = enabled == false ? nil : self.dataSource
    }
    
    private func setupPageController() {
        pageViewController = UIPageViewController(transitionStyle: .scroll,
                                                  navigationOrientation: .horizontal,
                                                  options: nil)
        pageViewController.delegate = self
        pageViewController.setViewControllers(
            [.init()],
            direction: .forward,
            animated: false,
            completion: nil
        )
        addChildViewController(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController!.view.frame = view.bounds
        pageViewController.didMove(toParentViewController: self)
        view.gestureRecognizers = pageViewController.gestureRecognizers
    }
    
}

extension CustomPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        willTransitionTo pendingViewControllers: [UIViewController]) {
        guard let idx = pendingViewControllers.first.flatMap(self.dataSource.indexFor(controller:)),
            let vc = dataSource.controllerFor(index: idx)
            else { return }
        self.transitionTo(viewController: vc)
    }
    
}
