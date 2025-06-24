//
//  CountryDetailMapperTests.swift
//  CountriesAppTests
//
//  Created by Narcisa Romero on 24/6/25.
//

import XCTest
@testable import CountriesApp

final class CountryDetailMapperTests: XCTestCase {
    
    func test_map_deliversItemsOn200HTTPResponseWithJSONItems() throws {
        // Arrange
        let item = mockCountryDetail()
        let jsonString = #"[{"name":{"common":"Togo","official":"Togolese Republic","nativeName":{"fra":{"official":"République togolaise","common":"Togo"}}},"tld":[".tg"],"cca2":"TG","ccn3":"768","cioc":"TOG","independent":true,"status":"officially-assigned","unMember":true,"currencies":{"XOF":{"symbol":"Fr","name":"West African CFA franc"}},"idd":{"root":"+2","suffixes":["28"]},"capital":["Lomé"],"altSpellings":["TG","Togolese","Togolese Republic","République Togolaise"],"region":"Africa","subregion":"Western Africa","languages":{"fra":"French"},"latlng":[8.0,1.16666666],"landlocked":false,"borders":["BEN","BFA","GHA"],"area":56785.0,"demonyms":{"eng":{"f":"Togolese","m":"Togolese"},"fra":{"f":"Togolaise","m":"Togolais"}},"cca3":"TGO","translations":{"ara":{"official":"جمهورية توغو","common":"توغو"},"bre":{"official":"Republik Togoat","common":"Togo"},"ces":{"official":"Republika Togo","common":"Togo"},"cym":{"official":"Togolese Republic","common":"Togo"},"deu":{"official":"Republik Togo","common":"Togo"},"est":{"official":"Togo Vabariik","common":"Togo"},"fin":{"official":"Togon tasavalta","common":"Togo"},"fra":{"official":"République togolaise","common":"Togo"},"hrv":{"official":"Togolese Republika","common":"Togo"},"hun":{"official":"Togói Köztársaság","common":"Togo"},"ind":{"official":"Republik Togo","common":"Togo"},"ita":{"official":"Repubblica del Togo","common":"Togo"},"jpn":{"official":"トーゴ共和国","common":"トーゴ"},"kor":{"official":"토고 공화국","common":"토고"},"nld":{"official":"Republiek Togo","common":"Togo"},"per":{"official":"جمهوری توگو","common":"توگو"},"pol":{"official":"Republika Togijska","common":"Togo"},"por":{"official":"República do Togo","common":"Togo"},"rus":{"official":"Того Республика","common":"Того"},"slk":{"official":"Togská republika","common":"Togo"},"spa":{"official":"República de Togo","common":"Togo"},"srp":{"official":"Тоголешка Република","common":"Того"},"swe":{"official":"Republiken Togo","common":"Togo"},"tur":{"official":"Togo Cumhuriyeti","common":"Togo"},"urd":{"official":"جمہوریہ ٹوگو","common":"ٹوگو"},"zho":{"official":"多哥共和国","common":"多哥"}},"flag":"\uD83C\uDDF9\uD83C\uDDEC","maps":{"googleMaps":"https://goo.gl/maps/jzAa9feXuXPrKVb89","openStreetMaps":"https://www.openstreetmap.org/relation/192782"},"population":8278737,"gini":{"2015":43.1},"fifa":"TOG","car":{"signs":["TG"],"side":"right"},"timezones":["UTC"],"continents":["Africa"],"flags":{"png":"https://flagcdn.com/w320/tg.png","svg":"https://flagcdn.com/tg.svg","alt":"The flag of Togo is composed of five equal horizontal bands of green alternating with yellow. A red square bearing a five-pointed white star is superimposed in the canton."},"coatOfArms":{"png":"https://mainfacts.com/media/images/coats_of_arms/tg.png","svg":"https://mainfacts.com/media/images/coats_of_arms/tg.svg"},"startOfWeek":"monday","capitalInfo":{"latlng":[6.14,1.21]},"postalCode":{"format":null,"regex":null}}]"#
        
        let json = jsonString.makeJSON()
        
        // Act
        let result = try CountryDetailMapper.map(json, from: HTTPURLResponse(statusCode: 200))
        
        // Assert
        XCTAssertEqual(result, [item])
    }
    
    func test_map_throwsErrorOnNon200HTTPResponse() throws {
        // Arrange
        let json = "".makeJSON()
        let samples = [199, 201, 300, 400, 500]
        
        try samples.forEach { code in
            // Assert
            XCTAssertThrowsError(
                // Act
                try CountryDetailMapper.map(json, from: HTTPURLResponse(statusCode: code))
            )
        }
    }
    
    func test_map_throwsErrorOn200HTTPResponseWithInvalidJSON() {
        // Arrange
        let invalidJSON = Data("invalid json".utf8)
        
        // Assert
        XCTAssertThrowsError(
            // Act
            try CountryDetailMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: 200))
        )
    }
    
    func mockCountryDetail() -> Country {
        Country(commonName: "Togo",
                officialName: "Togolese Republic",
                capital: "Lomé",
                flagURL: URL(string: "https://flagcdn.com/w320/tg.png")!,
                region: "Africa",
                subregion: "Western Africa",
                population: 8278737,
                timezones: ["UTC"],
                carDriveSide: "right",
                coatOfArms: URL(string: "https://mainfacts.com/media/images/coats_of_arms/tg.png")!,
                isFavorite: false)
    }
}

