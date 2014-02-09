
import com.google.maps.LatLng;
import com.google.maps.MapMouseEvent;

/**************************************************************
 *  Herramienta medir distancia
 *************************************************************/		


private var p1:LatLng;		//Puntos medidos 1 y 2.
private var p2:LatLng;



// Toggles para activar y desactuvar los botones
//private var toggleMedir:Boolean = false;


private function goMedir():void{	
	
	// ENTRA A MEDIR
	if (!bottom_bar.b_medir.emphasized){
		bottom_bar.b_medir.emphasized=true;		//Activa el botón azul
		bottom_bar.info_medir.visible=true;
		//Desactivar el resto de botones
		bottom_bar.b_mapas.enabled=false;bottom_bar.b_marcas.enabled=false; bottom_bar.b_capas.enabled=false;
		bottom_bar.b_viento_bottom.visible=false;bottom_bar.b_web.visible=false;bottom_bar.b_herramientas.visible=false;
		b_recursos.enabled=false;b_cisterna.enabled=false;b_helicoptero.enabled=false; b_peticion.enabled=false;b_peticion.enabled=false;
		bottom_bar.info_medir.text="Info: Pulsar sobre el mapa los puntos a medir.";
		
		
		
		map.addEventListener(MapMouseEvent.MOUSE_UP, addMedirP1);		//Activa para introducir el primer punto.
	}
	
	else{
		//CERRAR PANEL 
		cerrarPanelMedir();
		//Eliminar listeners y cerrar
		map.removeEventListener(MapMouseEvent.MOUSE_UP, addMedirP1);
		map.removeEventListener(MapMouseEvent.MOUSE_UP, addMedirP2);
	}
	
	
}// Fin de goMedir()



// Activa el mapa para el primer punto
private function addMedirP1(e:MapMouseEvent):void{
	//pinta la marca del primer punto y asugna el valos de p1:latlng
	p1=e.latLng;
	var mp1:Marker = new Marker(e.latLng,
		new MarkerOptions({
			strokeStyle: new StrokeStyle({color: 0x987654}),
			fillStyle: new FillStyle({color: 0xFF9900, alpha: 0.8}),
			radius: 12,
			hasShadow: true
		}));
	map.capa_medir.addOverlay(mp1);
	
	//borra el listener del primer
	map.removeEventListener(MapMouseEvent.MOUSE_UP, addMedirP1);
	//crea el listener del segundo
	map.addEventListener(MapMouseEvent.MOUSE_UP, addMedirP2);
	
}


// Activa el mapa para el primer punto
private function addMedirP2(e:MapMouseEvent):void{
	//pinta la marca del segundo punto y asugna el valos de p2:latlng
	p2=e.latLng;
	var mp2:Marker = new Marker(e.latLng,
		new MarkerOptions({
			strokeStyle: new StrokeStyle({color: 0x987654}),
			fillStyle: new FillStyle({color: 0xFF9900, alpha: 0.8}),
			radius: 12,
			hasShadow: true
		}));
	map.capa_medir.addOverlay(mp2);
	
	//borra el listener del segundo
	map.removeEventListener(MapMouseEvent.MOUSE_UP, addMedirP2);
	
	
	// pinta la linea formado por p1 y p2
	var line_medir:Polyline = new Polyline(
		[p1,p2],
		new PolylineOptions({ strokeStyle: new StrokeStyle({
			color: 0xff9900,
			thickness: 4,
			alpha: 0.7})
		}));
	
	map.capa_medir.addOverlay(line_medir);
	
	
	
	// Muestra el panel de info con la distancia
	var distancia:Number= p1.distanceFrom(p2);
	bottom_bar.info_medir.text= "La distancia entre los puntos es de:\n"+roundDecimal(distancia,2)+" metros.";
}


private function cerrarPanelMedir():void{
	bottom_bar.b_medir.emphasized=false;		//Desactiva el botón azul
	bottom_bar.info_medir.visible=false;
	//activar el resto de los botones. 
	bottom_bar.b_mapas.enabled=true;bottom_bar.b_marcas.enabled=true; bottom_bar.b_capas.enabled=true;
	bottom_bar.b_viento_bottom.visible=true;bottom_bar.b_web.visible=true;bottom_bar.b_herramientas.visible=true;
	b_peticion.enabled=true;
	//b_recursos.enabled=true;b_cisterna.enabled=true;b_helicoptero.enabled=true; b_peticion.enabled=true;b_peticion.enabled=true;
	actualizarPuntos();
		
	//limpiar la capa de medir
	map.capa_medir.clear();
}