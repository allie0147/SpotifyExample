//
//  SearchResultsSubtitleTableViewCell.swift
//  SpotifyExample
//
//  Created by Allie Kim on 2021/05/05.
//

import UIKit
import SDWebImage

class SearchResultsSubtitleTableViewCell: UITableViewCell {

    static let identifier = "SearchResultsSubtitleTableViewCell"

    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()

    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        return label
    }()

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(iconImageView)
        contentView.clipsToBounds = true
        accessoryType = .disclosureIndicator
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize: CGFloat = contentView.height - 10
        iconImageView.frame = CGRect(
            x: 10,
            y: 5,
            width: imageSize,
            height: imageSize
        )

        let lableHeight = contentView.height / 2

        label.frame = CGRect(
            x: iconImageView.right + 10,
            y: 0,
            width: contentView.width - iconImageView.right - 15,
            height: lableHeight
        )

        subTitleLabel.frame = CGRect(
            x: iconImageView.right + 10,
            y: label.bottom,
            width: contentView.width - iconImageView.right - 15,
            height: lableHeight
        )

    }

    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        label.text = nil
        subTitleLabel.text = nil
    }

    func configure(with viewModel: SearchResultsSubtitleTableViewCellViewModel) {
        label.text = viewModel.title
        subTitleLabel.text = viewModel.subtitle
        iconImageView.sd_imageTransition = .fade
        iconImageView.sd_setImage(
            with: viewModel.imageURL,
            completed: nil
        )
    }

}
