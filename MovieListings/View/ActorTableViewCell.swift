//
//  ActorTableViewCell.swift
//  MovieListings
//
//  Created by Jason Cross on 2020-04-05.
//  Copyright © 2020 Jason Cross. All rights reserved.
//

import SwiftUI

struct ActorTableViewCell: View {
    @ObservedObject var actor : ActorViewModel
    
    var body: some View {
        HStack {
            actor.image
                .resizable()
                .aspectRatio(contentMode: ContentMode.fit)
                .frame(width: 60, height: 60)
            VStack (alignment: .leading) {
                Text(actor.name)
                Text("\(actor.age)").font(.caption).foregroundColor(.secondary)
            }
        }
        .onAppear {
            self.actor.fetchImage()
        }
    }
}

struct ActorTableViewCell_Previews: PreviewProvider {
    static var previews: some View {
        let actor1 = ActorWrapper()
        actor1.name = "Mark Hammill"
        actor1.age = 69
        actor1.imageUrl = URL(string: "https://www.imdb.com/name/nm0000434/mediaviewer/rm1572940288?ref_=nm_ov_ph")
        let data = ActorViewModel(actorWrapper: actor1)
        return ActorTableViewCell(actor: data)
    }
}
