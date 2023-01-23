//
//  StatusBarAppearance.swift
//  Hurricane
//
//  Created by Francesco Puzone on 01/06/22.
//

// import SwiftUI
//
// extension View {
//    /// A view modifier to set the color of the iOS Status Bar
//    func statusBarStyle(_ style: UIStatusBarStyle, ignoreDarkMode: Bool = false) -> some View {
//        background(HostingWindowFinder(callback: { window in
//            guard let rootViewController = window?.rootViewController else { return }
//            let hostingController = HostingViewController(rootViewController: rootViewController, style: style, ignoreDarkMode: ignoreDarkMode)
//            window?.rootViewController = hostingController
//        }))
//    }
// }
//
// fileprivate class HostingViewController: UIViewController {
//    private var rootViewController: UIViewController?
//    private var style: UIStatusBarStyle = .lightContent
//    private var ignoreDarkMode: Bool = false
//
//    init(rootViewController: UIViewController, style: UIStatusBarStyle, ignoreDarkMode: Bool) {
//        self.rootViewController = rootViewController
//        self.style = style
//        self.ignoreDarkMode = ignoreDarkMode
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        guard let child = rootViewController else { return }
//        addChild(child)
//        view.addSubview(child.view)
//        child.didMove(toParent: self)
//    }
//
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        if ignoreDarkMode || traitCollection.userInterfaceStyle == .dark {
//            return .lightContent
//        } else {
//            if style == .darkContent {
//                return .darkContent
//            }
//            else if style == .default {
//                    return .default
//            } else {
//                return .darkContent
//            }
//        }
//    }
//
//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        setNeedsStatusBarAppearanceUpdate()
//    }
// }
//
// fileprivate struct HostingWindowFinder: UIViewRepresentable {
//    var callback: (UIWindow?) -> ()
//
//    func makeUIView(context: Context) -> UIView {
//        let view = UIView()
//        DispatchQueue.main.async { [weak view] in
//            self.callback(view?.window)
//        }
//        return view
//    }
//
//    func updateUIView(_ uiView: UIView, context: Context) {
//        // NO-OP
//    }
// }
//
