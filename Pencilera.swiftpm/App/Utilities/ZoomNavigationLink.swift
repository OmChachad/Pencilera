import SwiftUI

import SwiftUI

struct ZoomNavigationLink<Label: View, Destination: View>: View {
    let destination: Destination
    let label: Label
    let id: String
    let namespace: Namespace.ID
    
    init(id: String, namespace: Namespace.ID, @ViewBuilder destination: () -> Destination, @ViewBuilder label: () -> Label) {
        self.id = id
        self.namespace = namespace
        self.destination = destination()
        self.label = label()
    }
    
    var body: some View {
        if #available(iOS 18.0, *) {
            NavigationLink {
                destination
                    .navigationTransition(.zoom(sourceID: id, in: namespace))
            } label: {
                label
                    .matchedTransitionSource(id: id, in: namespace)
            }
        } else {
            NavigationLink(destination: destination) {
                label
            }
        }
    }
}
