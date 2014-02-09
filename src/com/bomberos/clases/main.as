/////////////////////////////////////////////////////////////////
//																
//	Funciones del Main 													
//																
//	La principal función es recoger los evenos despachados 
//	por los botones del programa																	
//																
//	- -															
//	Jesús García González											
//	Universidad Carlos III de Madrid								
//	- -															
/////////////////////////////////////////////////////////////////

import com.bomberos.clases.Llamada;
import com.bomberos.contenedores.bottom_bar;
import com.bomberos.contenedores.mapa;
import com.google.maps.Map;
import com.google.maps.MapType;

import mx.collections.ArrayCollection;

import com.bomberos.clases.ClaseDispatcher;

//-----------------------------------------------------------------
//  RECOGE TODAS LAS LLAMADAS A LA APLICACIÓN PRINCIPAL
//-----------------------------------------------------------------
private var dispatcher:ClaseDispatcher;	
private var cargadoXML:Boolean = false; 							// Una vez que se pulsa el botón de capas se cargan los datos

//--------------------------------------------------------------------------
//  init(); 
//--------------------------------------------------------------------------
public function init():void{
	
	datos_capas_serv.makeObjectsBindable=true;						// Al llamar de nuevo al método datos_marcadores.send() se actualizan los datos de la lista.
	// Disparcher es el que recoge el evento y hace la llamada a la función que se quiera.
	dispatcher = ClaseDispatcher.getInstancia();
	
	dispatcher.addEventListener(Llamada.ACCION,recogeEvento);
	bottom_bar.addEventListener(Llamada.ACCION, recogeEvento);		// Hace que la bottom_bar escuche los eventos de la clase Llamada
	
}	// Fin de init 



//-----------------------------------
//  Recoge los eventos
//-----------------------------------
public function recogeEvento(evento:Llamada):void{
	trace("Recoge evento: " + evento.tipo + " y " + evento.tipo2);
	switch(evento.tipo){
		case "MAPA_CARGADO":	datos_unidades_serv.send();break;
		case "UNIDADES":		map.panTo(toLatLng(evento.tipo2));break;
		case "C_MAPA": 			map.cambiarMapa(evento.tipo2); break;									//Cambiar mapa
		case "C_TIEMPO": 		visor_tiempo.visible = !visor_tiempo.visible; break;					// Mostrar/Ocultar Tiempo
		case "C_CAPAS":
			switch (evento.tipo2){
				case "PARQUES": 	capaParques(); 		break;
				case "HIDRANTES": 	capaHidrantes();	break;
				case "GARAJES": 	capaGarajes();	break;
				case "TOXICOS": 	capaToxicos();	break;
				//	case "METRO": 		capaMetro(); 		break;
				case "METRO_IMG": 	capaMetroImg();		break;
			}
			break;
		
		case "GB_RECURSOS":
			trace("entra a desactivar los recursos");
			switch (evento.tipo2){
				case "ACTIVAR": 	b_recursos.enabled=true; b_cisterna.enabled=true;b_helicoptero.enabled=true; b_peticion.enabled=true;b_peticion.enabled=true;		break;
				case "DESACTIVAR":  b_recursos.enabled=false; b_cisterna.enabled=false;b_helicoptero.enabled=false; b_peticion.enabled=false;b_peticion.enabled=false;	break;
				case "VER": 		gb_recursos.visible=false;	break;
				case "OCULTAR": 	gb_recursos.visible=true;	break;
			}
			break;				
		case "VER_MARCAS":	map.capa_marcas.visible = !map.capa_marcas.visible; break; 			//Mostrar la capa de las marcas
		case "PANEL_MARCAS": 																	//Activa y desactiva el panel de las marcas.
			if (evento.tipo2=="CERRAR"){
				if (b_activar_marcacion.emphasized){goMarcas()}									// desactiva el añadir marcas si estuviese activado
				if (b_activar_poligono.emphasized){goPoligonos()}								// desactiva el añadir marcas si estuviese activado
				desactivar_panel_marcas();
				b_recursos.enabled=true;b_cisterna.enabled=true;b_helicoptero.enabled=true; b_peticion.enabled=true;b_peticion.enabled=true;
				actualizarPuntos();

			}
			else {
				activar_panel_marcas();
				b_recursos.enabled=false;b_cisterna.enabled=false;b_helicoptero.enabled=false; b_peticion.enabled=false;b_peticion.enabled=false;
			}
			break;									
		case "CAPAS_XML":if (!cargadoXML){cargadoXML=true; datos_capas_serv.send(); }; break;
		
		case "C_MEDIR": goMedir();break;
		case "IMG_VIENTO": lineas_viento_pantalla(); break;
		case "CARGA_XML": openCargaXML(); break;
			
	}// Fin del Switch
}