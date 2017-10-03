//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

class TagCollectionViewCell: UICollectionViewCell {

    let tagButton = TagButton(bookmarkTag: "")

    var bookmarkTag: BookmarkTag {
        set {
            tagButton.bookmarkTag = newValue
        }

        get {
            return tagButton.bookmarkTag
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    final fileprivate func commonInit() {
        tagButton.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(tagButton)

        NSLayoutConstraint.activate([
            tagButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            tagButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            tagButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tagButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}


// ---------------------------------------------------------------------------------------


class View: UIView, UICollectionViewDataSource {

    let tags: [BookmarkTag]
    let cv: UICollectionView

    init(frame: CGRect, tags: [BookmarkTag]) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        cv = UICollectionView(frame: .zero, collectionViewLayout: layout)

        self.tags = tags

        super.init(frame: frame)

        configureView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func configureView() {
        backgroundColor = .white

        cv.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: TagCollectionViewCell.self))
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        cv.dataSource = self
        cv.delegate = self

        addSubview(cv)

        NSLayoutConstraint.activate([
            cv.topAnchor.constraint(equalTo: topAnchor),
            cv.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            cv.bottomAnchor.constraint(equalTo: bottomAnchor),
            cv.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("tags.count: \(tags.count)")

        return tags.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: TagCollectionViewCell.self), for: indexPath) as! TagCollectionViewCell

        cell.bookmarkTag = tags[indexPath.row]

        print("cell size: \(cell.frame.size)")

        // Configure the cell
        return cell
    }
}

extension View: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let button = TagButton(bookmarkTag: tags[indexPath.row])
        button.setNeedsLayout()
        let size = button.frame.size

        print("size: \(size)")
        return size
    }
}

let frame = CGRect(x: 0, y: 0, width: 600, height: 40)
let view = View(frame: frame, tags: ["great", "tags", "are", "great"])

PlaygroundPage.current.needsIndefiniteExecution = true

PlaygroundPage.current.liveView = view