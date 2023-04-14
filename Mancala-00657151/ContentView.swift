//
//  ContentView.swift
//  Mancala-00657151
//
//  Created by User15 on 2023/4/14.
//

import SwiftUI
import Foundation

struct ContentView: View {
    @State var pits: [[Int]] = [
        [4, 4, 4, 4, 4, 4],
        [4, 4, 4, 4, 4, 4],
]
    @State var currentPlayer = 0
    @State var point0 = 0
    @State var point1 = 0
    @State var final = false

    var body: some View {
        ZStack {
            Image("bg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            HStack{
                VStack {
                    PitHole(point: $point1, playernow: $currentPlayer, player: 1)
                        .foregroundColor(.white)
                }
                Spacer()

                VStack {
                    PitRow(oppositepit: $pits,pits: $pits[0], player: $currentPlayer, playerpoint: $point1, oppositepoint: $point0, final: $final, pitsnum: 0)
                        .foregroundColor(.white)
                        .padding()
                    Text("MANCALA GAME")
                        .foregroundColor(.white)
                        .font(.title2)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    PitRow(oppositepit: $pits,pits: $pits[1], player: $currentPlayer, playerpoint: $point0, oppositepoint: $point1, final: $final, pitsnum: 1)
                        .foregroundColor(.white)
                        .padding()
                    if(final){
                        if(point0 < point1){
                            Text("Player 1 win!!!!")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                        }
                        else if(point0 > point1){
                            Text("Player 2 win!!!!")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                        }
                        else {
                            Text("Tie!!!")
                            .font(.largeTitle)
                                .foregroundColor(.white)
                        }
                    }
                    else{
                        Text("Player \(currentPlayer + 1) Turn")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                    }
                }

                Spacer()
                VStack {
                    PitHole(point: $point0, playernow: $currentPlayer, player: 0)
                        .foregroundColor(.white)
                }
            }
            .padding()
        }
}
}

struct PitRow: View {
    @Binding var oppositepit:[[Int]]
    @Binding var pits: [Int]
    @Binding var player: Int
    @Binding var playerpoint: Int
    @Binding var oppositepoint: Int
    @Binding var final: Bool
    let pitsnum: Int
    var body: some View {
        var position = 0
        var stone = 0
        var remain = 0
        var rremain = 0
        HStack {
            Spacer()
            ForEach(pits.indices, id: \.self) { index in
                VStack {
                    Circle()
                        .background(
                            Image("marble")
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                        )
                        .foregroundColor(.clear)
                        .frame(width: 80, height: 80)
                        .overlay(
                            Circle()
                                .stroke(pitsnum == 0 ? Color.white : Color.purple
                                        , lineWidth: 10)
                        )
                        .onTapGesture {
                            if(pits.allSatisfy { $0 == 0 } || oppositepit[(player + 1) % 2].allSatisfy{$0 == 0}) {
                                                        playerpoint += pits.reduce(0, +)
                                                        for index in 0...5 {
                                                            pits[index] = 0
                                                        }
                                                        oppositepoint += oppositepit[(player + 1) % 2].reduce(0, +)
                                                        for index in 0...5 {
                                                            oppositepit[(player + 1) % 2][index] = 0
                                                        }
                                                        final = true
                                                    }
                                                    if(player == 1 && pits[index] > 0 && player == pitsnum){     //player 1
                                                        position = index
                                                        stone = pits[index]
                                                        pits[index] = 0
                                                        if(index + stone <= 5) {    //same side
                                                            while stone > 0 {
                                                                pits[position + 1] += 1
                                                                position += 1
                                                                stone -= 1
                                                            }
                                                            if(pits[position] == 1 && oppositepit[(player + 1) % 2][position] != 0) {
                                                                playerpoint += oppositepit[(player + 1) % 2][position]
                                                                oppositepit[(player + 1) % 2][position] = 0
                                                                playerpoint += 1
                                                                pits[position] = 0
                                                                player = (player + 1) % 2
                                                            }
                                                            player = (player + 1) % 2
                                                        }
                                                        else if(index + stone == 6) { //to point
                                                            playerpoint += 1
                                                            stone -= 1
                                                            while stone > 0 {
                                                                pits[position + 1] += 1
                                                                position += 1
                                                                stone -= 1
                                                            }
                                                            player = (player + 1) % 2
                                                        }
                                                        else if(stone + index == 13){   //to different point
                                                            remain = stone - (5 - index) - 2
                                                            stone -= (remain + 2)
                                                            playerpoint += 1
                                                            while stone > 0 {
                                                                pits[position + 1] += 1
                                                                position += 1
                                                                stone -= 1
                                                            }
                                                            player = (player + 1) % 2
                                                            position = 5
                                                            while remain > 0 {
                                                                oppositepit[player][position] += 1
                                                                position -= 1
                                                                remain -= 1
                                                            }
                                                            oppositepoint += 1
                                                        }
                                                        else if(stone + index > 13){    //back to same side
                                                            rremain = stone - (5 - index) - 2 - 6
                                                            remain = 6
                                                            stone -= (rremain + remain + 2)
                                                            playerpoint += 1
                                                            while stone > 0 {
                                                                pits[position + 1] += 1
                                                                position += 1
                                                                stone -= 1
                                                            }
                                                            position = 0
                                                            while rremain > 0 {
                                                                pits[position] += 1
                                                                position += 1
                                                                rremain -= 1
                                                            }
                                                            position = 5
                                                            while remain > 0 {
                                                                oppositepit[(player + 1) % 2][position] += 1
                                                                position -= 1
                                                                remain -= 1
                                                            }
                                                            oppositepoint += 1
                                                            if(pits[position] == 1 && oppositepit[(player + 1) % 2][position] != 0) {
                                                                playerpoint += oppositepit[(player + 1) % 2][position]
                                                                oppositepit[(player + 1) % 2][position] = 0
                                                                playerpoint += 1
                                                                pits[position] = 0
                                                                player = (player + 1) % 2
                                                            }
                                                            player = (player + 1) % 2
                                                        }
                                                        else {
                                                            remain = stone - (5 - index) - 1
                                                            stone -= (remain + 1)
                                                            playerpoint += 1
                                                            while stone > 0 {
                                                                pits[position + 1] += 1
                                                                position += 1
                                                                stone -= 1
                                                            }
                                                            player = (player + 1) % 2
                                                            position = 5
                                                            while remain > 0 {
                                                                oppositepit[player][position] += 1
                                                                position -= 1
                                                                remain -= 1
                                                            }
                                                        }
                                                    }
                                                    else if(player == 0 && pits[index] > 0 && player == pitsnum) {   //player 2
                                                        position = index
                                                        stone = pits[index]
                                                        pits[index] = 0
                                                        if(stone - index < 0) {
                                                            while stone > 0 {
                                                                pits[position - 1] += 1
                                                                position -= 1
                                                                stone -= 1
                                                            }
                                                            if(pits[position] == 1 && oppositepit[(player + 1) % 2][position] != 0) {
                                                                playerpoint += oppositepit[(player + 1) % 2][position]
                                                                oppositepit[(player + 1) % 2][position] = 0
                                                                playerpoint += 1
                                                                pits[position] = 0
                                                                player = (player + 1) % 2
                                                            }
                                                            player = (player + 1) % 2
                                                        }
                                                        else if(stone - index == 1) {
                                                            playerpoint += 1
                                                            stone -= 1
                                                            while stone > 0 {
                                                                pits[position - 1] += 1
                                                                position -= 1
                                                                stone -= 1
                                                            }
                                                            player = (player + 1) % 2
                                                        }
                                                        else if(stone - index == 8){
                                                            remain = stone - index - 2
                                                            stone -= (remain + 2)
                                                            playerpoint += 1
                                                            while stone > 0 {
                                                                pits[position - 1] += 1
                                                                position -= 1
                                                                stone -= 1
                                                            }
                                                            player = (player + 1) % 2
                                                            position = 0
                                                            while remain > 0 {
                                                                oppositepit[player][position] += 1
                                                                position += 1
                                                                remain -= 1
                                                            }
                                                            oppositepoint += 1
                                                        }
                                                        else if(stone - index > 8){
                                                            remain = 6
                                                            rremain = stone - remain - 2 - index
                                                            stone = index
                                                            playerpoint += 1
                                                            while stone > 0 {
                                                                pits[position - 1] += 1
                                                                position -= 1
                                                                stone -= 1
                                                            }
                                                            position = 5
                                                            while rremain > 0 {
                                                                pits[position] += 1
                                                                position -= 1
                                                                rremain -= 1
                                                            }
                                                            player = (player + 1) % 2
                                                            position = 0
                                                            while remain > 0 {
                                                                oppositepit[player][position] += 1
                                                                position += 1
                                                                remain -= 1
                                                            }
                                                            oppositepoint += 1
                                                            if(pits[position] == 1 && oppositepit[(player + 1) % 2][position] != 0) {
                                                                playerpoint += oppositepit[(player + 1) % 2][position]
                                                                oppositepit[(player + 1) % 2][position] = 0
                                                                playerpoint += 1
                                                                pits[position] = 0
                                                                player = (player + 1) % 2
                                                            }
                                                            player = (player + 1) % 2
                                                        }
                                                        else {
                                                            remain = stone - index - 1
                                                            stone -= (remain + 1)
                                                            playerpoint += 1
                                                            while stone > 0 {
                                                                pits[position - 1] += 1
                                                                position -= 1
                                                                stone -= 1
                                                            }
                                                            player = (player + 1) % 2
                                                            position = 0
                                                            while remain > 0 {
                                                                oppositepit[player][position] += 1
                                                                position += 1
                                                                remain -= 1
                                                            }
                                                        }
                                                    }
                                                }
                                            Text("\(pits[index])")
                                                .font(.title2)
                                        }
                                    }
                                    Spacer()
        }
    }
}

struct PitHole: View {
    @Binding var point: Int
    @Binding var playernow: Int
    let player: Int
    var body: some View {
        VStack {
            Text("\(point)")
                .font(.title)
            Capsule()
                .foregroundColor(.clear)
                .frame(width: 85, height: 270)
                .overlay(
                    Capsule()
                        .stroke(player == 0 ? Color.purple : Color.white, lineWidth: 5)
                )
            if(player == 1){
                Text("Player 1")
                    .font(.title)
                    .foregroundColor(playernow == 0 ? Color.white : Color.gray)
            }
            else{
                Text("Player 2")
                    .font(.title)
                    .foregroundColor(playernow == 1 ? Color.white : Color.gray)
            }

        }
    }
}
extension Array {
    func optionalElement(at index: Int) -> Element? {
        if index < count && index >= 0 {
            return self[index]
        } else {
            return nil
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()

        }
    }
}
