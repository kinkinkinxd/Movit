//
//  GenreCollectionViewCell.swift
//  Movit
//
//  Created by กิตติธัช อิงคสมภพ on 24/9/2566 BE.
//

import UIKit

class GenreCollectionViewCell: UICollectionViewCell {
    
    let genreDict = [28: "Action",
                     12: "Adventure",
                     16: "Animation",
                     35: "Comedy ",
                     80: "Crime",
                     99: "Documentary",
                     18: "Drama",
                     10751: "Family",
                     14: "Fantasy",
                     36: "History",
                     27: "Horror",
                     10402: "Music",
                     9648: "Mystery",
                     10749: "Romance",
                     878: "Science Fiction",
                     10770: "TV Movie",
                     53: "Thriller",
                     10752: "War",
                     37: "Western"
    ]

    @IBOutlet weak var cellGenreLabel: UILabel!
    
    func setup(_ genre_id: Int) {
        self.layer.cornerRadius = 5
        cellGenreLabel.text = genreDict[genre_id]
    }

}
