//
//  InicioView.swift
//  IntelligenSAP
//
//  Created by David Palafox on 11/10/22.
//

import Foundation
import SwiftUI

struct InicioView: View {
    
    @State var correo = ""
    @State var contrasena = ""
    @State var isHomeViewActive = false
    
    var body: some View {
        
        NavigationView {
            ZStack {
                Color(.white).ignoresSafeArea()

                VStack {
                    HeaderLogo()

                    ScrollView {
                        VStack(alignment: .leading) {

                        // Campo de correo electrónico
                            Text("Correo electrónico")
                                .foregroundColor(Color("blue_lettering"))
                            ZStack(alignment: .leading) {
                                if correo.isEmpty {
                                    Text(verbatim: "ejemplo@intelligensap.com.mx")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                TextField("", text: $correo)
                            }
                            DivisorInicio()

                         // Campo de contraseña
                            Text("Contraseña")
                                .foregroundColor(Color("blue_lettering"))
                            ZStack(alignment: .leading) {
                                if contrasena.isEmpty {
                                    Text("Introduce tu contraseña")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                SecureField("", text: $contrasena)
                            }
                            DivisorInicio()
                        }
                        .padding(.horizontal, 30)

                        NavigationLink(destination: HomeView(),
                                       isActive: $isHomeViewActive,
                                       label: { EmptyView() })
                    }

                    Button("INICIAR SESIÓN") {
                        print("Pulsando botón INICIAR SESIÓN")
                        iniciarSesion()
                    }
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity,
                           alignment: .center)
                    .padding(.vertical, 12)
                    .overlay(RoundedRectangle(cornerRadius: 12)
                        .stroke(Color("blue_accent")))
                    .background(Color("blue_accent").cornerRadius(12))

                }.frame(width: 330)
            }
            .navigationBarHidden(true)
        }
//        TODO: Analizar para iPad.
//        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func iniciarSesion() {
        print("Iniciando sesión")
        isHomeViewActive = true
    }
}

struct HeaderLogo: View {
    var body: some View {
        Image("IntelligenceSAP_Logo")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 200)
            .padding(.top, 60)
        
        Spacer(minLength: 80)
    }
}

struct DivisorInicio: View {
    var body: some View {
        Divider()
            .frame(height: 1)
            .background(Color("blue_accent"))
            .padding((.bottom))
    }
}

struct InicioView_Previews: PreviewProvider {
    static var previews: some View {
        InicioView()
    }
}
