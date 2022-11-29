//
//  HomeView.swift
//  IntelligenSAP
//
//  Created by David Palafox on 11/10/22.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        
        TabView {
            PerfilView()
                .tabItem{
                    Image(systemName: "person.fill")
                    Text("Perfil")
                }
            
            Text("Pantalla Home")
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .tabItem{
                    Image(systemName: "house")
                    Text("Home")
                }
            
            Text("Pantalla Cursos")
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .tabItem{
                    Image(systemName: "books.vertical.fill")
                    Text("Cursos")
                }
            
            TimeSheetView()
                .tabItem{
                    Image(systemName: "calendar.badge.clock")
                    Text("Reporte")
                }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
