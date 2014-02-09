/////////////////////////////////////////////////////////////////
//																
//	CAPAS - COMPONENTE 													
//																
//	Activa las capas de Puntos de Información haciendo llamadas
//	por HTTPService mendiante el método send()
//						
//	Localización: Bomberos Main 
//
//	- -															
//	Jesús García González											
//	Universidad Carlos III de Madrid 							
//	- -															
/////////////////////////////////////////////////////////////////

import com.bomberos.contenedores.bottom_bar;
import com.google.maps.Color;
import com.google.maps.InfoWindowOptions;
import com.google.maps.LatLng;
import com.google.maps.MapMouseEvent;
import com.google.maps.interfaces.IOverlay;
import com.google.maps.overlays.*;
import com.google.maps.overlays.Marker;
import com.google.maps.overlays.MarkerOptions;
import com.google.maps.services.ClientGeocoder;
import com.google.maps.services.ClientGeocoderOptions;
import com.google.maps.services.GeocodingEvent;
import com.google.maps.styles.*;

import flash.events.Event;
import flash.events.MouseEvent;

//--------------------------------------------------------------------------
//
//  Arrays PDI, recojen los datos de los PDI
//
//--------------------------------------------------------------------------

[Bindable]
private var datos_bomberos:ArrayCollection;
/*[Bindable]
private var datos_garajes:ArrayCollection;
[Bindable]
private var datos_toxicos:ArrayCollection;*/
/*[Bindable]													//Otras posibles capas
private var datos_sanidad:ArrayCollection;
[Bindable]
private var datos_seguridad:ArrayCollection;
*/


//--------------------------------------------------------------------------
//
//  Crear Capas
//	Crea las capas de google maps una vez leidas del xml de capas
//
//--------------------------------------------------------------------------

//--------------------------------------------------------------------------------
//  PDICargados: Se activa cuando se reciben los datos de datos_capas_serv.send()
//--------------------------------------------------------------------------------
private function PDICargados():void{
	
	datos_bomberos = datos_capas_serv.lastResult.capas.bomberos.item;  
//	datos_garajes =  datos_capas_serv.lastResult.capas.garajes.item;  
//	datos_toxicos =  datos_capas_serv.lastResult.capas.toxicos.item; 
	//datos_sanidad =  datos_capas_serv.lastResult.capas.sanidad.item;  
	//datos_seguridad = datos_capas_serv.lastResult.capas.seguridad.item; 
	
	// En este punto ya está cargado el HTTPService
	// Así que activamos los botones de las capas
	bottom_bar.b_capas.enabled=true;
	// Se crean todas las marcas y capas
	crearCapas();						
}

//--------------------------------------------------------------------------
//
//  DIBUJAR LAS MARCAS EN LAS CPAS CORRESPONDIENTES
//
//--------------------------------------------------------------------------
//------------------------------------------
//  Crea y almacena las capas en los mapas
//------------------------------------------


//-----------------------------------
//  ICONOS de las Capas
//-----------------------------------
[Embed(source="assets/icons_map/par.png")] private var parIcon:Class;
[Embed(source="assets/icons_map/hid.png")] private var hidIcon:Class;
[Embed(source="assets/icons_map/gar.png")] private var garIcon:Class;
[Embed(source="assets/icons_map/tox.png")] private var toxIcon:Class;





private function crearMarcaCapa(mark:Object):void{

	var marca:Marker;
	//	trace (mark.coordinates);
	// Añade la marca creada a la capa
	// map.capa_parques.addOverlay(marca);
	switch(mark.tipo)
	{
		case "parque":
		{
			marca = new Marker(toLatLng(mark.coordinates), 
				new MarkerOptions({
					//strokeStyle: new StrokeStyle({color: 0x000000}),						// Toma el color por defecto.
					icon: new parIcon(),
					fillStyle: new FillStyle({color: 0x666666, alpha: 0.8}),
					radius: 12,
					hasShadow: true,
					draggable:false}) 
			); 
			
			// Añade la ventana de información
			marca.addEventListener(MapMouseEvent.CLICK, function(event:Event):void { 
				marca.openInfoWindow(
					new InfoWindowOptions( { 
						title: mark.nombre, 
						content: mark.dir +"\n"+ mark.web +"\n"+mark.tel	
					} 
					)); 
			})
			
			map.capa_parques.addOverlay(marca);
			break;
		}
		case "hidrante":{
			marca = new Marker(toLatLng(mark.coordinates), 
				new MarkerOptions({
					//strokeStyle: new StrokeStyle({color: 0x000000}),						// Toma el color por defecto.
					icon: new hidIcon(),
					fillStyle: new FillStyle({color: 0xffffff, alpha: 0.8}),
					radius: 12,
					hasShadow: true,
					draggable:false}) 
			); 
			
			// Añade la ventana de información
			marca.addEventListener(MapMouseEvent.CLICK, function(event:Event):void { 
				marca.openInfoWindow(
					new InfoWindowOptions( { 
						title: mark.dir 
					} 
					)); 
			})
			map.capa_hidrantes.addOverlay(marca); 
			break;
		}
			
			
		case "garaje":{
			
			marca = new Marker(toLatLng(mark.coordinates), 
				new MarkerOptions({
					//strokeStyle: new StrokeStyle({color: 0x000000}),						// Toma el color por defecto.
					icon: new garIcon(),
					fillStyle: new FillStyle({color: 0x666457, alpha: 0.8}),
					radius: 12,
					hasShadow: true,
					draggable:false}) 
			); 
			
			// Añade la ventana de información
			marca.addEventListener(MapMouseEvent.CLICK, function(event:Event):void { 
				marca.openInfoWindow(
					new InfoWindowOptions( { 
						title: mark.nombre, 
						content: mark.dir +"\n"+mark.tel	
					} 
					)); 
			})
			map.capa_garajes.addOverlay(marca); 
			break;
		}
			
		case "toxico":{
			marca = new Marker(toLatLng(mark.coordinates), 
				new MarkerOptions({
					//strokeStyle: new StrokeStyle({color: 0x000000}),						// Toma el color por defecto.
					icon: new toxIcon(),
					fillStyle: new FillStyle({color: 0x659666, alpha: 0.8}),
					radius: 12,
					hasShadow: true,
					draggable:false}) 
			); 
			
			// Añade la ventana de información
			marca.addEventListener(MapMouseEvent.CLICK, function(event:Event):void { 
				marca.openInfoWindow(
					new InfoWindowOptions( { 
						title: mark.nombre, 
						content: mark.dir +"\n"+ mark.web +"\n"+mark.tel	
					} 
					)); 
			})
			map.capa_toxicos.addOverlay(marca); 
			break;
		}			
			
	}
}


private function crearCapas():void{
	
	//------------------------------------------
	//  Insetar marcas en las distintas capas
	//------------------------------------------
	for (var i:int = 0; i < datos_bomberos.length; i++)	{
			crearMarcaCapa(datos_bomberos[i]);
	}
	
	//  Capas Cargadas: Muestra los botones del menú
	bottom_bar.cargando_capas.visible=false;
	bottom_bar.b_capas_cargadas.visible=true;
} 

//--------------------------------------------------------------------------
//
//  MOSTRAR OCULTAR CAPAS, acceso desde los botones de la bottom_bar
//
//--------------------------------------------------------------------------
	
	//-----------------------------------
	//  Parques de bomberos
	//-----------------------------------
	private function capaParques():void{
		if(bottom_bar.tb_parques.selected){
			map.capa_parques.visible=true;
		}	
		else {map.capa_parques.visible=false}
	}	
	
	//-----------------------------------
	//  Hidrantes (Suministros)
	//-----------------------------------
	private function capaHidrantes():void{
		if(bottom_bar.tb_hidrantes.selected){
			map.capa_hidrantes.visible=true;
		}	
		else {map.capa_hidrantes.visible=false}
	}	

//-----------------------------------
//  Hidrantes (Suministros)
//-----------------------------------
private function capaGarajes():void{
	if(bottom_bar.tb_garajes.selected){
		map.capa_garajes.visible=true;
	}	
	else {map.capa_garajes.visible=false}
}	

//-----------------------------------
//  Hidrantes (Suministros)
//-----------------------------------
private function capaToxicos():void{
	if(bottom_bar.tb_toxicos.selected){
		map.capa_toxicos.visible=true;
	}	
	else {map.capa_toxicos.visible=false}
}	

//-----------------------------------
//  Imagen del Metro Sur
//-----------------------------------
private function capaMetroImg():void{
	if(bottom_bar.tb_metro_img.selected){
		map.setCenter(new LatLng(40.3240,-3.8009),12.6);
		map.metroSur.visible=true;
	}
	else{
		map.metroSur.visible=false;
	}
}	