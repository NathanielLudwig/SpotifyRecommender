//
//  Attribute.swift
//  SpotifyRecommender
//
//  Created by 90303054 on 5/12/20.
//  Copyright © 2020 90303054. All rights reserved.
//

import Foundation

struct Attribute {
    var name: String
    var minValue: Float = 0.0
    var maxValue: Float = 1.0
    var value: Float = 0.5
    var isSelected = false
    var description: String
}

struct AttributeTypes {
    static var shared = AttributeTypes()
    var values = [
        Attribute(name: "acousticness", description: "A confidence measure from 0.0 to 1.0 of whether the track is acoustic. 1.0 represents high confidence the track is acoustic."),
        Attribute(name: "danceability", description: "Danceability describes how suitable a track is for dancing based on a combination of musical elements including tempo, rhythm stability, beat strength, and overall regularity. A value of 0.0 is least danceable and 1.0 is most danceable."),
        Attribute(name: "energy", description: "Energy is a measure from 0.0 to 1.0 and represents a perceptual measure of intensity and activity. Typically, energetic tracks feel fast, loud, and noisy. For example, death metal has high energy, while a Bach prelude scores low on the scale. Perceptual features contributing to this attribute include dynamic range, perceived loudness, timbre, onset rate, and general entropy."),
        Attribute(name: "instrumentalness", description: "Predicts whether a track contains no vocals. “Ooh” and “aah” sounds are treated as instrumental in this context. Rap or spoken word tracks are clearly “vocal”. The closer the instrumentalness value is to 1.0, the greater likelihood the track contains no vocal content. Values above 0.5 are intended to represent instrumental tracks, but confidence is higher as the value approaches 1.0."),
        Attribute(name: "liveness", description: "Detects the presence of an audience in the recording. Higher liveness values represent an increased probability that the track was performed live. A value above 0.8 provides strong likelihood that the track is live."),
        Attribute(name: "popularity", maxValue: 100.0, value: 50.0, description: "The popularity of the track. The value will be between 0 and 100, with 100 being the most popular."),
        Attribute(name: "speechiness", description: "Speechiness detects the presence of spoken words in a track. The more exclusively speech-like the recording (e.g. talk show, audio book, poetry), the closer to 1.0 the attribute value. Values above 0.66 describe tracks that are probably made entirely of spoken words. Values between 0.33 and 0.66 describe tracks that may contain both music and speech, either in sections or layered, including such cases as rap music. Values below 0.33 most likely represent music and other non-speech-like tracks."),
        Attribute(name: "valence", description: "A measure from 0.0 to 1.0 describing the musical positiveness conveyed by a track. Tracks with high valence sound more positive (e.g. happy, cheerful, euphoric), while tracks with low valence sound more negative (e.g. sad, depressed, angry).")
    ]
    func getSelectedAttributes() -> [Attribute] {
        var selectedAttributes: [Attribute] = []
        for attribute in values {
            if attribute.isSelected == true {
                selectedAttributes.append(attribute)
            }
        }
        return selectedAttributes
    }
    func getUnselectedAttributes() -> [Attribute] {
        var unselectedAttributes: [Attribute] = []
        for attribute in values {
            if attribute.isSelected == false {
                unselectedAttributes.append(attribute)
            }
        }
        return unselectedAttributes
    }
}
