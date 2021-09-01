//
//  LoremPicsum.swift
//  LoremPicsum
//
//  Created by Alex Nagy on 01.09.2021.
//

import SwiftUI

/// Adds Dummy Images
public struct LoremPicsum {
    
    public static var foodAndDrink: Image {
        Image("slashio-photography-bKAWpR4y5nU-unsplash", bundle: Bundle.module)
    }
    
    public static var backToSchool: Image {
        Image("quinton-coetzee-Lf94850dM14-unsplash", bundle: Bundle.module)
    }
    
    public static var nature: Image {
        Image("damien-schnorhk-ccg5KqHcIlU-unsplash", bundle: Bundle.module)
    }
    
    public static var architecture: Image {
        Image("devon-divine-8bIFt7xq_uU-unsplash", bundle: Bundle.module)
    }
    
    public static var business: Image {
        Image("israel-andrade-YI_9SivVt_s-unsplash", bundle: Bundle.module)
    }
    
    public static var fashion: Image {
        Image("ehimetalor-akhere-unuabona-Vbk36H9YNLQ-unsplash", bundle: Bundle.module)
    }
    
    public static var health: Image {
        Image("tyler-nix-HmVQh_EQJhY-unsplash", bundle: Bundle.module)
    }
    
    public static var interior: Image {
        Image("dmitriy-frantsev-zbafP5GeL0Q-unsplash", bundle: Bundle.module)
    }
    
    public static var street: Image {
        Image("lerone-pieters-vy4Yg_d-3DI-unsplash", bundle: Bundle.module)
    }
    
    public static var technology: Image {
        Image("taiki-ishikawa-cXjFsX5UvGw-unsplash", bundle: Bundle.module)
    }
    
    public static var texture: Image {
        Image("hossein-beygi-P6XQbfknFR8-unsplash", bundle: Bundle.module)
    }
    
    public static var travel: Image {
        Image("florian-wehde-cgVrmivyQvI-unsplash", bundle: Bundle.module)
    }
    
    public static var athletics: Image {
        Image("maksym-tymchyk-bGOBoZorNoQ-unsplash", bundle: Bundle.module)
    }
    
    public static var history: Image {
        Image("ismail-zabalawi-WX39Ass0zDs-unsplash", bundle: Bundle.module)
    }
    
    public static var person0: Image {
        Image("mika-baumeister-k7ppbDckDwQ-unsplash", bundle: Bundle.module)
    }
    
    public static var person1: Image {
        Image("darshan-patel-QJEVpydulGs-unsplash", bundle: Bundle.module)
    }
    
    public static var person2: Image {
        Image("karsten-winegeart-qYO_mjVcLpg-unsplash", bundle: Bundle.module)
    }
    
    public static var person3: Image {
        Image("mos-sukjaroenkraisri-jz8AmJDyhig-unsplash", bundle: Bundle.module)
    }
    
    public static var person4: Image {
        Image("idowu-emmanuel-pzclzArQSA4-unsplash", bundle: Bundle.module)
    }
    
    public static var person5: Image {
        Image("evilicio-inc-zo9-6ofZ91Y-unsplash", bundle: Bundle.module)
    }
    
    public static var person6: Image {
        Image("ade-tunji-B0q7eBuXKjA-unsplash", bundle: Bundle.module)
    }
    
    public static var person7: Image {
        Image("anastasia-vityukova-ZRfSpvIh-FA-unsplash", bundle: Bundle.module)
    }
    
    public static var person8: Image {
        Image("courtney-cook-TSZo17r3m0s-unsplash", bundle: Bundle.module)
    }
    
    public static var person9: Image {
        Image("angelo-pari-X5dYIZj24sQ-unsplash", bundle: Bundle.module)
    }
    
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
    
    public static func randomImage() -> Image {
        images.randomElement() ?? foodAndDrink
    }
    
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
    
    public static func randomPerson() -> Image {
        people.randomElement() ?? person0
    }
    
}
