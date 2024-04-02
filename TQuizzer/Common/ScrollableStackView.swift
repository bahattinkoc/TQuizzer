//
//  ScrollableStackView.swift
//  TQuizzer
//
//  Created by BAHATTIN KOC on 24.03.2024.
//

import UIKit

final class ScrollableStackView: UIView {

    // MARK: Properties
    private var didSetupConstraints = false

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.backgroundColor = .clear
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.layoutMargins = .zero
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()

    // MARK: Life Cycle
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        setNeedsUpdateConstraints()
    }

    override func updateConstraints() {
        super.updateConstraints()
        if !didSetupConstraints {
            NSLayoutConstraint.activate([
                scrollView.topAnchor.constraint(equalTo: topAnchor),
                scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
                scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
                stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
                stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
                stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
                stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
                stackView.centerXAnchor.constraint(equalTo: scrollView.frameLayoutGuide.centerXAnchor)
            ])
            didSetupConstraints.toggle()
        }
    }
}

// MARK: - ScrollableStackView - Actions
extension ScrollableStackView {
    /// Adds a view to the end of the arranged subviews array.
    ///
    /// - Parameter view: The view to be added to the array of views arranged by the stack.
    func add(view: UIView) {
        stackView.addArrangedSubview(view)
    }

    /// Adds the provided view to the array of arranged subviews at the specified index.
    ///
    /// - Parameters:
    ///   - view: The view to be added to the array of views arranged by the stack.
    ///   - index: The index where the stack inserts the new view in its arranged subviews array.
    ///     This value must not be greater than the number of views currently in this array.
    ///     If the index is out of bounds, this method throws an `internalInconsistencyException` exception.
    func insert(view: UIView, at index: Int) {
        stackView.insertArrangedSubview(view, at: index)
    }

    /// Removes the provided view from the stack’s array of arranged subviews.
    ///
    /// - Parameter view: The view to be removed from the array of views arranged by the stack.
    func remove(view: UIView) {
        stackView.removeArrangedSubview(view)
    }

    /// Sets custom spacing to inner `UIStackView` by using `UIStackView.setCustomSpacing(:after:)`
    /// - Parameters:
    ///   - spacing: Spacing after the view
    ///   - view: The view that will have spacing after it
    func setCustomSpacing(_ spacing: CGFloat, after view: UIView) {
        stackView.setCustomSpacing(spacing, after: view)
    }

    /// Removes all arranged subviews from stack’s array..
    func removeAllArrangedSubviews() {
        stackView.removeAllArrangedSubviews()
    }
}

// MARK: - ScrollableStackView - Configuration
extension ScrollableStackView {
    /// The distance in points between the adjacent edges of the stack view’s arranged views.
    ///
    /// This property defines a strict spacing between arranged views for the `UIStackView.Distribution.fillProportionally` distributions.
    /// It represents the minimum spacing for the `UIStackView.Distribution.equalSpacing` and `UIStackView.Distribution.equalCentering` distributions.
    /// Use negative values to allow overlap.
    /// The default value is `0.0`.
    var spacing: CGFloat {
        get {
            stackView.spacing
        }
        set {
            stackView.spacing = newValue
        }
    }

    /// The alignment of the arranged subviews perpendicular to the stack view’s axis.
    ///
    /// This property determines how the stack view lays out its arranged views perpendicularly to its axis.
    /// The default value is `UIStackView.Alignment.fill`.
    /// For a list of possible values, see `UIStackView.Alignment`.
    var alignment: UIStackView.Alignment {
        get {
            stackView.alignment
        }
        set {
            stackView.alignment = newValue
        }
    }

    /// The distribution of the arranged views along the stack view’s axis.
    ///
    /// This property determines how the stack view lays out its arranged views along its axis.
    /// The default value is `UIStackView.Distribution.fill`.
    /// For a list of possible values, see `UIStackView.Distribution`.
    var distribution: UIStackView.Distribution {
        get {
            stackView.distribution
        }
        set {
            stackView.distribution = newValue
        }
    }

    /// The custom distance that the content view is inset from the safe area or scroll view edges.
    ///
    /// Use this property to extend the space between your content and the edges of the content view. The unit of size is points. The default value is `zero`.
    ///
    /// By default,`UIKit` automatically adjusts the content inset to account for overlapping bars. You use this property to extend that distance even further,
    /// perhaps to accommodate your own custom content. Get the total adjustment
    /// — the safe area plus your custom insets
    /// — using the `adjustedContentInset` property. To change how the safe area is applied, modify the `contentInsetAdjustmentBehavior` property.
    var contentInset: UIEdgeInsets {
        get {
            scrollView.contentInset
        }
        set {
            scrollView.contentInset = newValue
        }
    }

    var margins: UIEdgeInsets {
        get {
            stackView.layoutMargins
        }
        set {
            stackView.isLayoutMarginsRelativeArrangement = true
            stackView.layoutMargins = newValue
        }
    }
}

extension UIStackView {
    func removeAllArrangedSubviews() {
        let removedSubviews = arrangedSubviews.reduce([]) { allSubviews, subview -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
}
