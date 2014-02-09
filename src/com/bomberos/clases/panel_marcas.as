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


private var get_latlng:LatLng;								// variable que almacena la latlng del punto pasado por parámetro
private var get_direccion:String;							// variable que almacena la dirección del punto marcado en el mapa


private var quedoAbiertoMarcas:Boolean= false;
private var toggleBotonMarcas: Boolean= false;


//-----------------------------------
//  Actualizar Mostrar Marcas
//-----------------------------------
private function actualizarMostrarMarcas():void{
	if(c_mostrar_marcas.selected) {
		map.capa_marcas.visible=true;
		if (array_marcas.length>0) { 
			b_last_marca.enabled=true;
			b_all_marca.enabled=true;
		}
		
	} else {
		map.capa_marcas.visible=false;
		if (b_activar_marcacion.emphasized){goMarcas();}
		b_last_marca.enabled=false;
		b_all_marca.enabled=false;	
		b_sel_marca.enabled=false;
	}
}


//-----------------------------------
// ACTIVACIÓN DEL PANEL DE MARCAS
//-----------------------------------
private function activar_panel_marcas():void{
	bottom_bar.desactivarBotones();
	grupo_panel_marcas.visible=true;
	actualizarMostrarMarcas();
	
}

//-----------------------------------
// DESACTIVACIÓN DEL PANEL DE MARCAS
//-----------------------------------
private function desactivar_panel_marcas():void{
	
	grupo_panel_marcas.visible=false;					// Borra el panel marcas
	bottom_bar.activarBotones();
	
}	


private var color_marca:String = 	"Azul";					// Recoje el valor del color elegido para las marcas
private var color_poligono:String = "Azul";					// Recoje el valor del color elegido para los polígonos

private var toggle_add_marcas:Boolean=false;				// Variables de activación del marcado para las marcas y polígonos
private var toggle_add_poligono:Boolean=false;	





/**************************************************************
 *   AÑADIR MARCAS			
 *************************************************************/

private var toggleMarcas:Boolean = false;					// Activación del modo de dibujo de marcas
private var array_marcas:Array = new Array();				// Matriz donde se almacenan todas las marcas (las añadidas por el ussuario)
private var grupo_marca:IOverlay;							// Capa del mapa para las Marcas
private var marca_seleccionada:LatLng = null;				// Valor de latlng de la marca seleccionada.


//--------------------------------------------------------------------------
//
// goMarcas(), se activa cuando se hace click sobre el botón AÑADIR MARCAS
//
//--------------------------------------------------------------------------
private function goMarcas():void{
	
	if(toggle_add_poligono){goPoligonos()}					// Desactiva el dibujado del polígono si estuviese abierto
	
	// Si Añadir marcas no está activo se activa mediante:
	if (!toggle_add_marcas){
		b_activar_marcacion.emphasized = true;
		texto_marca.enabled=true;
		b_color.enabled=true;
		borrar_t_marca.enabled=true;
		c_mostrar_marcas.selected=true;
		actualizarMostrarMarcas();
	}
		
	else{
		b_activar_marcacion.emphasized = false;
		texto_marca.enabled=false;
		b_color.enabled=false;
		borrar_t_marca.enabled=false;
	}
	
	if (array_marcas.length>0) { 
		b_last_marca.enabled=true;
		b_all_marca.enabled=true;	
	}
	toggle_add_marcas = !toggle_add_marcas;	
	addMarcas(); 											//Iniciamos la añadición de marcas al abir el panel‚
}


//--------------------------------------------------------------------------
//
// función para activar o desactivar el botón de marcación
// Activar Marcas
//
//--------------------------------------------------------------------------
private function addMarcas():void{
	if (!toggleMarcas) {map.addEventListener(MapMouseEvent.MOUSE_UP, addMarcasMapa)}
	else { map.removeEventListener(MapMouseEvent.MOUSE_UP, addMarcasMapa)}
	toggleMarcas = !toggleMarcas;
}


//--------------------------------------------------------------------------
//
//  AddMarcasMapa
//
//--------------------------------------------------------------------------
private var get_elevacion:String="";
private function addMarcasMapa(evento:MapMouseEvent):void{
	// Antes de dibujar la marca en el lugar donde se hizo click en el mapa, esperaremos a que nos devuelvan los datos 
	// de la transformación de las coordenadas. Geocoder. 
	var geocoder:ClientGeocoder = new ClientGeocoder();
	geocoder.addEventListener(GeocodingEvent.GEOCODING_SUCCESS,
		function(event:GeocodingEvent):void {
			var placemarks:Array = event.response.placemarks;
			if (placemarks.length > 0) {
				get_direccion=placemarks[0].address;
				array_marcas.push(creaMarca(evento));
				map.capa_marcas.addOverlay(array_marcas[array_marcas.length -1]);
			}	// fin del if
		});
	
	geocoder.addEventListener(GeocodingEvent.GEOCODING_FAILURE,
		function(event:GeocodingEvent):void {
			trace("Geocoding failed");
		});
	
	
	// *********************************************************
	/* ELEVACiÖN DEL TERRENO, Mientras no se obtengan los datos de elevación, no se continúa con la captura de las
		coordenadas */
	
	import com.google.maps.MapMouseEvent;
	import com.google.maps.LatLng;
	import com.google.maps.MapEvent;
	import com.google.maps.Map;
	import com.google.maps.MapType;
	import com.google.maps.InfoWindowOptions;
	import com.google.maps.services.*;
	
	var elevator:Elevation;
	
	elevator = new Elevation();

	var locationArray:Array = new Array();
	locationArray[0] = evento.latLng;
	
	elevator.loadElevationForLocations(locationArray);								// Activa el listener de la elevación,y cuando se recibe se sigue el proceso

	
	elevator.addEventListener(ElevationEvent.ELEVATION_SUCCESS, 
		function (event:ElevationEvent):void {
			var elevationArray:Array = event.elevations;
			get_elevacion= elevationArray[0].elevation;
			get_elevacion= get_elevacion.substr(0, 6);								// Acorta la cadena para que no muestre tantos decimales
			
			// Aquí se activa el listener para la petición de la transformación de las coordenadas
			// Una vez que se reciben los datos de elevación se llama a la función conseguir dirección. Y después se dibuja la marca.  
			geocoder.geocode(evento.latLng.toString()); 
		
		}
	);// Fin del listener
		
	b_last_marca.enabled=true;													// Activamos los botones al añadir la marca.
	b_all_marca.enabled=true;
	
	//-----------------------------------------------------
	//  Desactivar botón añadir marcas al añadir una marca
	//-----------------------------------------------------
	goMarcas();
}

//--------------------------------------------------------------------------
//
//  Crear Marca en el mapa
//
//--------------------------------------------------------------------------
private function creaMarca(evento:MapMouseEvent):Marker{
	
	var relleno:Color = elegirColor(color_marca);
	var win_texto:String = texto_marca.text;
	var direccion:String = get_direccion;
	var elevacion:String = get_elevacion; 
	var marca:Marker = new Marker(evento.latLng,new MarkerOptions({
		//strokeStyle: new StrokeStyle({color: 0x000000}),						// Toma el color por defecto.
		fillStyle: new FillStyle({color: relleno.rgb, alpha: 0.8}),
		radius: 12,
		hasShadow: true,
		draggable:true}) ); 
	marca.addEventListener(MapMouseEvent.CLICK, marcaSeleccionada);
	
	// Añade la ventana de información
	if ((texto_marca.text != "") && (texto_marca.text != " ")) {win_texto}
	else{win_texto=''}
	marca.addEventListener(MapMouseEvent.ROLL_OVER, function(event:Event):void { 
		marca.openInfoWindow(new InfoWindowOptions( { title: win_texto, content: "Dirección:\n" +direccion +"\n\n"+ "Elevación:\n" + elevacion+ " metros"} )); 
	})
	
	return marca;
}


//--------------------------------------------------------------------------
//
//  Borrar Marca seleccionada
//
//--------------------------------------------------------------------------
private function marcaSeleccionada(event:MapMouseEvent):void{
	trace("Marca seleccionada: "+event.latLng);						// en la matriz se busca esta lat y long y se elimina esa entrada
	b_sel_marca.enabled=true;
	marca_seleccionada = event.latLng; 
}

private function borrarMarcaSel():void{
	if (marca_seleccionada != null){
		//Recorre el array de las marcas hasta encontrar una coincidencia de latlng, entonces, borrar esa entrada
		for (var i:Number=0; i<array_marcas.length;i++){ 
			var sel:String = marca_seleccionada.toString();
			var marc:LatLng = array_marcas[i].getLatLng();
			
			if (sel == marc.toString()){	
				array_marcas.splice(i, 1);									// Elimina la fila i, y solo borra 1 fila. 
				
				if (array_marcas.length==0){borrarAllMarcas()}
				else{
					map.capa_marcas.clear();									//limpia las marcas en pantalla
					for (var j:int=0;j<array_marcas.length;j++){				// y vuelve a pintar el array
						map.capa_marcas.addOverlay(array_marcas[j]);
					}
					
				}
			}
		}
	}
	marca_seleccionada = null;
	
	// Una vez borrada la marca, se desactiva el botón de borrar marca seleccionada hasta que se vuelva a activar otro botón.
	b_sel_marca.enabled=false;
}

//--------------------------------------------------------------------------
//
//  Borrar última Marca añadida
//
//--------------------------------------------------------------------------
private function deleteLastMarca(e:Event):void {
	
	//limpia las marcas en pantalla 
	map.capa_marcas.clear();
	
	if (array_marcas.length > 0) {
		array_marcas.pop();														// Borra el último elemento del array
	}
	// y vuelve a pintar el array
	for (var i:int=0;i<array_marcas.length;i++){
		map.capa_marcas.addOverlay(array_marcas[i]);
	}
	if (array_marcas.length == 0){
		b_last_marca.enabled=false; 
		b_all_marca.enabled=false;
		b_sel_marca.enabled=false;
		
		//	b_mostrar_marcas_b.emphasized=false;		
	}
}


private function borrarAllMarcas():void{
	map.capa_marcas.clear(); 
	array_marcas.length = 0; 
	b_last_marca.enabled=false; 
	b_all_marca.enabled=false; 
	b_sel_marca.enabled=false;
	
	if(toggle_add_marcas){goMarcas()}					//desactiva si estuviese activado el añadir marcas
}

// Función de transformación de color
private function elegirColor(color:String):Color{
	var rcolor:Color;
	switch (color){
		
		case "Rojo": 		rcolor=new Color(0xC70000); break; 
		case "Amarillo": 	rcolor=new Color(0xFFF000); break;
		case "Verde": 		rcolor=new Color(0x00E61B); break;
		case "Azul": 		rcolor=new Color(0x0011D1); break;
	}
	return rcolor;
}

// Clases para cambiar el icono de color
[Embed(source='assets/icons/peq/azul.png')]
public static var icon_azul:Class;
[Embed(source='/assets/icons/peq/amarillo.png')]
public static var icon_amarillo:Class;
[Embed(source='/assets/icons/peq/verde.png')]
public static var icon_verde:Class;
[Embed(source='/assets/icons/peq/rojo.png')]
public static var icon_rojo:Class;

// Cambiar icono del botón CallouButton del Color de las marcas
private function cambiarIcono(color:String, event:MouseEvent):void{
	color_clickHandler(event); 													//Cierra el desplegable
	switch (color){
		case "azul":b_color.setStyle("icon", icon_azul);break;
		case "amarillo":b_color.setStyle("icon", icon_amarillo);break;
		case "verde":b_color.setStyle("icon",icon_verde);break;
		case "rojo":b_color.setStyle("icon",icon_rojo);break;
	}
} // Fin cambiar icono.

// Función, cerrar el callouButton del Color
protected function color_clickHandler(event:MouseEvent):void
{
	color_marca= event.target.label;
	b_color.closeDropDown();
}









/**************************************************************
 *   AÑADIR POLÍGONOS
 *************************************************************/		

//	private var testPoint:Marker;
private var array_poligono:Array = new Array();
private var modo_poligono:Boolean;
private var grupo_poligono:IOverlay;	

// Toggles para activar y desactuvar los botones
private var togglePoligonos:Boolean = false;


private function goPoligonos():void{	
	
	//desactiva si estuviese activado el añadir marcas
	if(toggle_add_marcas){goMarcas()}
	
	// Si Añadir poligono está activo:
	if (!toggle_add_poligono){
		b_activar_poligono.emphasized = true;
		c_mostrar_poligono.selected=true;
		actualizarMostrarPoligono();
	}
	else{
		b_activar_poligono.emphasized = false;
	}
	
	if (array_poligono.length>0) { 
		rm_poligono.enabled=true;
		rm_linea.enabled=true;
		
		b_last_poligono.enabled=true;
		b_all_poligono.enabled=true;	
	}
	toggle_add_poligono = !toggle_add_poligono;	
	addPoligonos();									
	
}

private function actualizarMostrarPoligono():void{
	if(c_mostrar_poligono.selected) {
		//trace(evt.target);
		map.capa_poligonos.visible=true;
		if (array_poligono.length>0) { 
			rm_poligono.enabled=true;
			rm_linea.enabled=true;
			
			b_last_poligono.enabled=true;
			b_all_poligono.enabled=true;	
		}
		
		
	} else {
		map.capa_poligonos.visible=false;
		if (b_activar_poligono.emphasized){goPoligonos();}
		rm_poligono.enabled=false;
		rm_linea.enabled=false;
		b_last_poligono.enabled=false;
		b_all_poligono.enabled=false;	
	}
}

// Activar polígonos
private function addPoligonos():void{
	
	if (!togglePoligonos) {map.addEventListener(MapMouseEvent.MOUSE_UP, addPoligonoMapa)}
	else { map.removeEventListener(MapMouseEvent.MOUSE_UP, addPoligonoMapa)}
	togglePoligonos = !togglePoligonos;
	
}

private function addPoligonoMapa(e:MapMouseEvent):void {
	var mapa_pulsado:LatLng = e.latLng;
	array_poligono.push(mapa_pulsado);						// Almacena en el array los puntos añadidos
	rm_poligono.enabled=true;
	rm_linea.enabled=true;
	b_last_poligono.enabled=true;
	b_all_poligono.enabled=true;
	dibujaPoligono();										// Dibuja la coordenada introducida
}

private function deleteLastLatLng(e:Event):void {
	if (array_poligono.length > 0) {
		array_poligono.pop();								// Borra el último elemento del array
	}
	dibujaPoligono();
	if (array_poligono.length == 0) {
		b_last_poligono.enabled=false;
		b_all_poligono.enabled=false;
		rm_poligono.enabled=false;
		rm_linea.enabled=false;
	}
	
}

private function borraPoligono():void{
	map.capa_poligonos.clear();
	array_poligono.length = 0; 
	b_last_poligono.enabled=false;
	b_all_poligono.enabled=false;
	rm_poligono.enabled=false;
	rm_linea.enabled=false;
}


// Toggle from Polygon PolyLine mode
private function toggleDrawMode(e:Event):void {
	map.capa_poligonos.clear();  //map.clearOverlays();
	grupo_poligono = null;
	dibujaPoligono();
}

private function dibujaPoligono():void {
	map.capa_poligonos.clear(); //	map.clearOverlays();
	if (array_poligono.length > 1) {
		//Re-create Polyline/Polygon
		modo_poligono = rm_poligono.selected;
		if (modo_poligono) {
			grupo_poligono = new Polygon(array_poligono);
		} else {
			grupo_poligono = new Polyline(array_poligono);
		}
		map.capa_poligonos.addOverlay(grupo_poligono);
	}
	
	if (array_poligono.length > 0) {
		// Grab last point of polyPoints to add new marker
		var tmpLatLng:LatLng = array_poligono[array_poligono.length -1];
		map.capa_poligonos.addOverlay(new Marker(tmpLatLng));
	}
}



// FUNCIÓN Codificación geográfica
// Convierte los datos pasados por un String, ya sea latLong o direcciones reales.
// Y almacena sus resultados en "get_latlng:LatLng"	y "get_direccion:String"
// **************************************************************************************************************


private function getDireccion(punto:String):void{
	var geocoder:ClientGeocoder = new ClientGeocoder();
	geocoder.addEventListener(GeocodingEvent.GEOCODING_SUCCESS, geoCoding);
	geocoder.addEventListener(GeocodingEvent.GEOCODING_FAILURE,geoCodingFallo);
	geocoder.geocode(punto);
	//Elimina los listeners
	//	geocoder.removeEventListener(GeocodingEvent.GEOCODING_SUCCESS, geoCoding);
	//	geocoder.removeEventListener(GeocodingEvent.GEOCODING_FAILURE,geoCodingFallo);
}// Fin getDirección
private function geoCoding (event:GeocodingEvent):void {
	var placemarks:Array = event.response.placemarks;
	/*if (placemarks.length > 0) {
	get_latlng=placemarks[0].point;
	get_direccion=placemarks[0].address;
	}*/
	//	trace("evento :"+ event);
	//	trace("placemarks :"+event.response.placemarks);
	//		get_latlng=placemarks[0].point;
	get_direccion=event.response.placemarks.address;
	trace("get_direccion :"+event.response.placemarks);
	
}
private function geoCodingFallo(event:GeocodingEvent):void {
	trace(event);
	trace(event.status);
}
// **************************************************************************************************************


private function doGeocode(event:Event):void {
	// Geocoding example
	var geocoder:ClientGeocoder = new ClientGeocoder();
	
	geocoder.addEventListener(
		GeocodingEvent.GEOCODING_SUCCESS,
		function(event:GeocodingEvent):void {
			var placemarks:Array = event.response.placemarks;
			if (placemarks.length > 0) {
				map.setCenter(placemarks[0].point);
				var marker:Marker = new Marker(placemarks[0].point);
				
				marker.addEventListener(MapMouseEvent.CLICK, function (event:MapMouseEvent):void {
					marker.openInfoWindow(new InfoWindowOptions({content: placemarks[0].address}));
				});
				map.addOverlay(marker);
			}
		});
	geocoder.addEventListener(
		GeocodingEvent.GEOCODING_FAILURE,
		function(event:GeocodingEvent):void {
			trace(event);
			trace(event.status);
		});
	geocoder.geocode(address.text);
}