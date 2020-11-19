//
//  Utilities.swift
//  SupportDocsSwiftUI
//
//  Created by Zheng on 10/31/20.
//

import SwiftUI

/**
 Configure the navigation bar's look, for iOS 14 and above.
 
 Source: [https://stackoverflow.com/a/58427754/14351818](https://stackoverflow.com/a/58427754/14351818).
 */
internal struct NavigationConfigurator: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void = { _ in }

    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        UIViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
        if let nc = uiViewController.navigationController {
            self.configure(nc)
        }
    }
}

/**
 Apply the `NavigationConfigurator`.
 */
internal extension View {
    @ViewBuilder
    func configureNavigationBarIfAvailable(navigationOptions: SupportOptions.NavigationBar) -> some View {
        if #available(iOS 14, *) {
            let _ = print("iOS 14 nav bar!")
            self.background(
                NavigationConfigurator { nc in /// Set the properties of `options.navigationBar`.
                    let navBarAppearance = UINavigationBarAppearance()
                    navBarAppearance.configureWithOpaqueBackground()
                    navBarAppearance.titleTextAttributes = [.foregroundColor: navigationOptions.titleColor]
                    navBarAppearance.largeTitleTextAttributes = [.foregroundColor: navigationOptions.titleColor]
                    
                    if let backgroundColor = navigationOptions.backgroundColor {
                        navBarAppearance.backgroundColor = backgroundColor
                        nc.navigationBar.scrollEdgeAppearance = navBarAppearance
                    }
                    nc.navigationBar.standardAppearance = navBarAppearance
                    
                    nc.navigationBar.barTintColor = navigationOptions.backgroundColor
                    nc.navigationBar.tintColor = navigationOptions.buttonTintColor
                }
            )
        } else {
            let _ = print("NOT iOS 14 nav bar!")
            self
        }
    }
}

/**
 Hide or show a View (support for iOS 13).
 
 Source: [https://stackoverflow.com/a/57685253/14351818](https://stackoverflow.com/a/57685253/14351818).
 */
internal extension View {
   @ViewBuilder
   func ifConditional<Content: View>(_ conditional: Bool, content: (Self) -> Content) -> some View {
        if conditional {
            content(self)
        } else {
            self
        }
    }
}

/**
 Prevent default all-caps behavior if possible (iOS 14 and above).
 */
internal extension View {
    @ViewBuilder
    func displayTextAsConfigured() -> some View {
        if #available(iOS 14, *) {
            self.textCase(nil)
        } else {
            self
        }
    }
}
