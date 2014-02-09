/////////////////////////////////////////////////////////////////
//																
//	UNIDADES -  													
//																
//	Activa la capa de las unidades haciendo llamada
//	por HTTPService mendiante el método send().
//						
// Contiene los métodos de de selección de las unidades.
//
//	Localización: Bomberos Main 
//
//	- -															
//	Jesús García González											
//	Universidad Carlos III de Madrid 							
//	- -															
/////////////////////////////////////////////////////////////////

import com.bomberos.componentes.listado;
import com.bomberos.componentes.listado_rec;
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

import mx.collections.ArrayCollection;


[Bindable] private var unidades_xml:ArrayCollection;							// Array con todos los datos

// Array de unidades disponibles listos para la intervención.
[Bindable] private var uds_disponibles:Array;							// Lista de disponibles

// Array de unidades solicitadas, se muestran en el listado solicitudes.
[Bindable] private var uds_solicitadas:ArrayCollection;							// Lista de solicitados

//--------------------------------------------------------------------------
//
//  Crear Capas
//	Crea las capas de google maps una vez leidas del xml de capas
//
//--------------------------------------------------------------------------

//--------------------------------------------------------------------------------
//  PDICargados: Se activa cuando se reciben los datos de datos_capas_serv.send()
//--------------------------------------------------------------------------------
private function unidadesCargadas(select:String):void{
	if(select=="carga1"){
		unidades_xml = datos_unidades_serv.lastResult.capas.unidad.item; 			// Guarda todas las unidades 
		actual1.visible=true; actual2.visible=false; 
	}
	else{
		unidades_xml = datos_unidades_serv2.lastResult.capas.unidad.item; 			// Guarda todas las unidades
		actual2.visible=true; actual1.visible=false;
	}
	
	//--------------------------------------------------------------------------
	// crea la lista de activos del mapa
	//--------------------------------------------------------------------------
	var lista_activos:listado = new listado();
	lista_activos.list_data= unidades_xml;
	lp_elementos.addElement(lista_activos);
	
	//-----------------------------------------------------------------
	//  crea la lista, en principio vacia de los recursos pedidos.
	//-----------------------------------------------------------------
	//var lista_recursos:listado_rec = new listado_rec();
	//lp_recursos.addElement(lista_recursos);
	
	
	//-----------------------------------
	//Crea las marcas de las unidades desplegadas
	//-----------------------------------
	for (var i:int = 0; i < unidades_xml.length; i++)	{
	trace (unidades_xml[i].tipo)

		switch(unidades_xml[i].tipo)
		{
			case "bombero":
			{
				marcaBombero(unidades_xml[i],null);									// Le pasa el objeto
				break;
			}
			
			case "dotacion":
			{
				marcaDotacion(unidades_xml[i],null);								// Le pasa el objeto
				break;
			}
			
			case "cisterna":
			{
				marcaCisterna(unidades_xml[i],null);								// Le pasa el objeto	
				break;
			}
			
			case "helicoptero":
			{
				marcaHelicoptero(unidades_xml[i],null);								// Le pasa el objeto	
				break;
			}
		}
	} // Fin del for
	
	initPuntos();
}


//-----------------------------------
//  ICONOS de las Capas
//-----------------------------------
[Embed(source="assets/icons_map/bom.png")] private var bomberoIcon:Class;
[Embed(source="assets/icons_map/dot.png")] private var dotacionIcon:Class;
[Embed(source="assets/icons_map/cis.png")] private var cisternaIcon:Class;
[Embed(source="assets/icons_map/hel.png")] private var helicopteroIcon:Class;


//-----------------------------------------
//  Crea las marcas según el tipo que sean
//-----------------------------------------
private function marcaBombero(obj:Object, nueva_dir:LatLng):void{	
	var marca:Marker;
	if (nueva_dir!=null){
		marca = new Marker(nueva_dir,new MarkerOptions({
			//strokeStyle: new StrokeStyle({color: 0x000000}),						// Toma el color por defecto.
			icon: new bomberoIcon(),
			fillStyle: new FillStyle({color: 0x666666, alpha: 0.8}),
			radius: 12,
			hasShadow: true,
			draggable:false
		}));
	}
	else{
		marca = new Marker(toLatLng(obj.coordinates),new MarkerOptions({
			//strokeStyle: new StrokeStyle({color: 0x000000}),						// Toma el color por defecto.
			icon: new bomberoIcon(),
			fillStyle: new FillStyle({color: 0x666666, alpha: 0.8}),
			radius: 12,
			hasShadow: true,
			draggable:false
		})); 
	}
	
	
	// Añade la ventana de información
	marca.addEventListener(MapMouseEvent.CLICK, function(event:Event):void {
		marca.openInfoWindow(new InfoWindowOptions({title: obj.nombre, content: obj.rango +"\n -Oxígeno: "+ obj.ox +"\n -Pulso: "+ obj.pulso +"\n -Explosímetro: "+ obj.explo
		}))});
	
	map.addOverlay(marca);

}

private function marcaDotacion(obj:Object, nueva_dir:LatLng):void{	
	var marca:Marker;
	
		if (nueva_dir!=null){
			marca = new Marker(nueva_dir,new MarkerOptions({
				//strokeStyle: new StrokeStyle({color: 0x000000}),						// Toma el color por defecto.
				icon: new dotacionIcon(),
				fillStyle: new FillStyle({color: 0x666666, alpha: 0.8}),
				radius: 12,
				hasShadow: true,
				draggable:false
			}));
		}
		else{
			marca = new Marker(toLatLng(obj.coordinates),new MarkerOptions({
				//strokeStyle: new StrokeStyle({color: 0x000000}),						// Toma el color por defecto.
				icon: new dotacionIcon(),
				fillStyle: new FillStyle({color: 0x666666, alpha: 0.8}),
				radius: 12,
				hasShadow: true,
				draggable:false
			})); 
		}
		
	// Añade la ventana de información
	marca.addEventListener(MapMouseEvent.CLICK, function(event:Event):void { 
		marca.openInfoWindow(
			new InfoWindowOptions({
				title: obj.nombre, 
				content: "\n -Nivel Cisterna: "+ obj.cisterna +"% \n -Vel. Viento: "+ obj.anemo +"\n -Dir. Viento: "+ obj.vele +"º"})); 
	})
				
			map.addOverlay(marca);
}

private function marcaCisterna(obj:Object, nueva_dir:LatLng):void{	
	var marca:Marker;
	
		if (nueva_dir!=null){
			marca = new Marker(nueva_dir,new MarkerOptions({
				//strokeStyle: new StrokeStyle({color: 0x000000}),						// Toma el color por defecto.
				icon: new cisternaIcon(),
				fillStyle: new FillStyle({color: 0x666666, alpha: 0.8}),
				radius: 12,
				hasShadow: true,
				draggable:false
			}) );
		}
		else{
			marca = new Marker(toLatLng(obj.coordinates),new MarkerOptions({
				//strokeStyle: new StrokeStyle({color: 0x000000}),						// Toma el color por defecto.
				icon: new cisternaIcon(),
				fillStyle: new FillStyle({color: 0x666666, alpha: 0.8}),
				radius: 12,
				hasShadow: true,
				draggable:false
			})); 
		}
		
	// Añade la ventana de información
	marca.addEventListener(MapMouseEvent.CLICK, function(event:Event):void { 
		marca.openInfoWindow(
			new InfoWindowOptions( { 
				title: obj.nombre, 
				content: "\n -Nivel Cisterna: "+ obj.cisterna +"% \n -Vel. Viento: "+ obj.anemo +"\n -Dir. Viento: "+ obj.vele +"º"	
			} 
			)); 
	})
		
			map.addOverlay(marca);
}

private function marcaHelicoptero(obj:Object, nueva_dir:LatLng):void{	
	var marca:Marker;
	
		
	
		if (nueva_dir!=null){
			marca = new Marker(nueva_dir, new MarkerOptions({
				//strokeStyle: new StrokeStyle({color: 0x000000}),						// Toma el color por defecto.
				icon: new helicopteroIcon(),
				fillStyle: new FillStyle({color: 0x666666, alpha: 0.8}),
				radius: 12,
				hasShadow: true,
				draggable:false
			}));
		}
		else{
			marca = new Marker(toLatLng(obj.coordinates),new MarkerOptions({
				//strokeStyle: new StrokeStyle({color: 0x000000}),						// Toma el color por defecto.
				icon: new helicopteroIcon(),
				fillStyle: new FillStyle({color: 0x666666, alpha: 0.8}),
				radius: 12,
				hasShadow: true,
				draggable:false
			})); 
		}
		
		
	// Añade la ventana de información
	marca.addEventListener(MapMouseEvent.CLICK, function(event:Event):void { 
		marca.openInfoWindow(
			new InfoWindowOptions( { 
				title: obj.nombre, 
				content: "\n -Altura: "+ obj.alt
			}  
			)); 
	})
		
			map.addOverlay(marca);
}

