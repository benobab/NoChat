/*
 The MIT License (MIT)

 Copyright (c) 2015-present Badoo Trading Limited.

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
*/

import UIKit

public enum ChatItemVisibility {
    case Hidden
    case Appearing
    case Visible
}

public class BaseChatItemPresenter<CellT: UICollectionViewCell>: ChatItemPresenterProtocol {
    public final weak var cell: CellT?

    public init() { }

    public class func registerCells(collectionView: UICollectionView) {
        assert(false, "Implement in subclass")
    }

    public var canCalculateHeightInBackground: Bool {
        return false
    }

    public func heightForCell(maximumWidth width: CGFloat, decorationAttributes: ChatItemDecorationAttributesProtocol?) -> CGFloat {
        assert(false, "Implement in subclass")
        return 0
    }

    public func dequeueCell(collectionView collectionView: UICollectionView, indexPath: NSIndexPath) -> UICollectionViewCell {
        assert(false, "Implemenent in subclass")
        return UICollectionViewCell()
    }

    public func configureCell(cell: UICollectionViewCell, decorationAttributes: ChatItemDecorationAttributesProtocol?) {
        assert(false, "Implemenent in subclass")
    }

    public private(set) final var itemVisibility: ChatItemVisibility = .Hidden

    // Need to override default implementatios. Otherwise subclasses's code won't be executed
    // http://stackoverflow.com/questions/31795158/swift-2-protocol-extension-not-calling-overriden-method-correctly
    public final func cellWillBeShown(cell: UICollectionViewCell) {
        if let cell = cell as? CellT {
            self.cell = cell
            self.itemVisibility = .Appearing
            self.cellWillBeShown()
            self.itemVisibility = .Visible
        } else {
            assert(false, "Invalid cell was given to presenter!")
        }
    }

    public func cellWillBeShown() {
        // Hook for subclasses
    }

    public func shouldShowMenu() -> Bool {
        return false
    }

    public final func cellWasHidden(cell: UICollectionViewCell) {
        // Carefull!! This doesn't mean that this is no longer visible
        // If cell is replaced (due to a reload for instance) we can have the following sequence:
        //   - New cell is taken from the pool and configured. We'll get cellWillBeShown
        //   - Old cell is removed. We'll get cellWasHidden
        // --> We need to check that this cell is the last one made visible
        if let cell = cell as? CellT {
            if cell === self.cell {
                self.cell = nil
                self.itemVisibility = .Hidden
                self.cellWasHidden()
            }
        } else {
            assert(false, "Invalid cell was given to presenter!")
        }
    }

    public func cellWasHidden() {
        // Hook for subclasses. Here we are not visible for real.
    }

    public func canPerformMenuControllerAction(action: Selector) -> Bool {
        return false
    }

    public func performMenuControllerAction(action: Selector) {
        assert(self.canPerformMenuControllerAction(action))
    }
}
