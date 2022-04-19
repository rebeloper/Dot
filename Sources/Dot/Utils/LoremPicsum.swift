//
//  LoremPicsum.swift
//  LoremPicsum
//
//  Created by Alex Nagy on 01.09.2021.
//

import SwiftUI

/// Adds Dummy Images
public struct LoremPicsum {
    
    public static let foodAndDrinkName = "slashio-photography-bKAWpR4y5nU-unsplash"
    public static let backToSchoolName = "quinton-coetzee-Lf94850dM14-unsplash"
    public static let natureName = "damien-schnorhk-ccg5KqHcIlU-unsplash"
    public static let architectureName = "devon-divine-8bIFt7xq_uU-unsplash"
    public static let businessName = "israel-andrade-YI_9SivVt_s-unsplash"
    public static let fashionName = "ehimetalor-akhere-unuabona-Vbk36H9YNLQ-unsplash"
    public static let healthName = "tyler-nix-HmVQh_EQJhY-unsplash"
    public static let interiorName = "dmitriy-frantsev-zbafP5GeL0Q-unsplash"
    public static let streetName = "lerone-pieters-vy4Yg_d-3DI-unsplash"
    public static let technologyName = "taiki-ishikawa-cXjFsX5UvGw-unsplash"
    public static let textureName = "hossein-beygi-P6XQbfknFR8-unsplash"
    public static let travelName = "florian-wehde-cgVrmivyQvI-unsplash"
    public static let athleticsName = "maksym-tymchyk-bGOBoZorNoQ-unsplash"
    public static let historyName = "ismail-zabalawi-WX39Ass0zDs-unsplash"
    public static let person0Name = "mika-baumeister-k7ppbDckDwQ-unsplash"
    public static let person1Name = "darshan-patel-QJEVpydulGs-unsplash"
    public static let person2Name = "karsten-winegeart-qYO_mjVcLpg-unsplash"
    public static let person3Name = "mos-sukjaroenkraisri-jz8AmJDyhig-unsplash"
    public static let person4Name = "idowu-emmanuel-pzclzArQSA4-unsplash"
    public static let person5Name = "evilicio-inc-zo9-6ofZ91Y-unsplash"
    public static let person6Name = "ade-tunji-B0q7eBuXKjA-unsplash"
    public static let person7Name = "anastasia-vityukova-ZRfSpvIh-FA-unsplash"
    public static let person8Name = "courtney-cook-TSZo17r3m0s-unsplash"
    public static let person9Name = "angelo-pari-X5dYIZj24sQ-unsplash"
    
    public static var foodAndDrink: Image {
        Image(foodAndDrinkName, bundle: Bundle.module)
    }
    
    public static var backToSchool: Image {
        Image(backToSchoolName, bundle: Bundle.module)
    }
    
    public static var nature: Image {
        Image(natureName, bundle: Bundle.module)
    }
    
    public static var architecture: Image {
        Image(architectureName, bundle: Bundle.module)
    }
    
    public static var business: Image {
        Image(businessName, bundle: Bundle.module)
    }
    
    public static var fashion: Image {
        Image(fashionName, bundle: Bundle.module)
    }
    
    public static var health: Image {
        Image(healthName, bundle: Bundle.module)
    }
    
    public static var interior: Image {
        Image(interiorName, bundle: Bundle.module)
    }
    
    public static var street: Image {
        Image(streetName, bundle: Bundle.module)
    }
    
    public static var technology: Image {
        Image(technologyName, bundle: Bundle.module)
    }
    
    public static var texture: Image {
        Image(textureName, bundle: Bundle.module)
    }
    
    public static var travel: Image {
        Image(travelName, bundle: Bundle.module)
    }
    
    public static var athletics: Image {
        Image(athleticsName, bundle: Bundle.module)
    }
    
    public static var history: Image {
        Image(historyName, bundle: Bundle.module)
    }
    
    public static var person0: Image {
        Image(person0Name, bundle: Bundle.module)
    }
    
    public static var person1: Image {
        Image(person1Name, bundle: Bundle.module)
    }
    
    public static var person2: Image {
        Image(person2Name, bundle: Bundle.module)
    }
    
    public static var person3: Image {
        Image(person3Name, bundle: Bundle.module)
    }
    
    public static var person4: Image {
        Image(person4Name, bundle: Bundle.module)
    }
    
    public static var person5: Image {
        Image(person5Name, bundle: Bundle.module)
    }
    
    public static var person6: Image {
        Image(person6Name, bundle: Bundle.module)
    }
    
    public static var person7: Image {
        Image(person7Name, bundle: Bundle.module)
    }
    
    public static var person8: Image {
        Image(person8Name, bundle: Bundle.module)
    }
    
    public static var person9: Image {
        Image(person9Name, bundle: Bundle.module)
    }
    
    public static let imageNames = [
        foodAndDrinkName,
        backToSchoolName,
        natureName,
        architectureName,
        businessName,
        fashionName,
        healthName,
        interiorName,
        streetName,
        technologyName,
        textureName,
        travelName,
        athleticsName,
        historyName
    ]
    
    public static let images = [
        foodAndDrink,
        backToSchool,
        nature,
        architecture,
        business,
        fashion,
        health,
        interior,
        street,
        technology,
        texture,
        travel,
        athletics,
        history
    ]
    
    public static func randomImageName() -> String {
        imageNames.randomElement() ?? foodAndDrinkName
    }
    
    public static func randomImage() -> Image {
        images.randomElement() ?? foodAndDrink
    }
    
    public static let peopleNames = [
        person0Name,
        person1Name,
        person2Name,
        person3Name,
        person4Name,
        person5Name,
        person6Name,
        person7Name,
        person8Name,
        person9Name
    ]
    
    public static let people = [
        person0,
        person1,
        person2,
        person3,
        person4,
        person5,
        person6,
        person7,
        person8,
        person9
    ]
    
    public static func randomPersonName() -> String {
        peopleNames.randomElement() ?? person0Name
    }
    
    public static func randomPerson() -> Image {
        people.randomElement() ?? person0
    }
    
}
