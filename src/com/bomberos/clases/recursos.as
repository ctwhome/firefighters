/////////////////////////////////////////////////////////////////
//																
//	RECURSOS 													
//																
//	Funciones a utilizar en la petición de los recursos																	
//																
//	- -															
//	Jesús García González											
//	Universidad Carlos III de Madrid								
//	- -															
/////////////////////////////////////////////////////////////////

import com.bomberos.clases.Llamada;
import com.bomberos.componentes.panel_confirmation;
import com.google.maps.MapEvent;
import com.google.maps.MapMouseEvent;

import flash.events.Event;
import flash.events.MouseEvent;

import spark.components.Button;
import spark.components.TextArea;

private var cuadro_info:TextArea = new TextArea();
private var recurso_a_anadir:String;

private var pinchadoEn:LatLng;



//-----------------------------------------------------------------
//  Se ejecuta cuando se pulsa sobre el botón de añadir un recurso
//-----------------------------------------------------------------
private function recursosAccion(e:Event):void{
	// Si el botón está activo sale, y si no lo emphatiza
	recurso_a_anadir = e.target.id;
	
	if (e.target.emphasized) {
		e.target.emphasized=false;
		bottom_bar.activarBotones(); 
		b_peticion.enabled=true;
		bottom_bar.gb_herramientas.visible=true;
		//this.removeElement(panl);
		map.removeEventListener(MapMouseEvent.MOUSE_UP,addMarcaRecurso);
		
		this.removeElement(cuadro_info);
	}
		

	
		//SE PULSA EL BOTÖN DEL RECURSO
	else{	
		bottom_bar.desactivarBotones();
		bottom_bar.gb_herramientas.visible=false; 
		b_peticion.enabled=false;
		gb_recursos.enabled=true;
		desenfatizarR();									// Emfatiza el botón
		e.target.emphasized=true;
		
		
		//Activamos el listener para el mapa.
		map.addEventListener(MapMouseEvent.MOUSE_UP,addMarcaRecurso);
		
		cuadro_info.x=898; cuadro_info.y=736; cuadro_info.width=374; cuadro_info.height=60; cuadro_info.editable=false;
		cuadro_info.text="Hacer click en el mapa para situar el recursos solicitado";
		cuadro_info.setStyle("color",0xffffff);
		this.addElement(cuadro_info);
	}
	
}


private function addMarcaRecurso(e:MapMouseEvent):void{
	//enfatizado y botones
	
	fondo_negro.visible=true;
	
	
	trace("ha pinchado en " + e.latLng);
	pinchadoEn= e.latLng;
	
	map.removeEventListener(MapMouseEvent.MOUSE_UP,addMarcaRecurso);
	
	
	// Abre la ventana de confirmación para añadir la marca.
	openWindow();
}


//-----------------------------------
//  Quitar empatizado de los botones
//-----------------------------------
private function desenfatizarR():void
{
	b_recursos.emphasized=false;	
	b_cisterna.emphasized=false;	
	b_helicoptero.emphasized=false;	
	b_peticion.emphasized=false;	
}


import spark.components.TitleWindow;
import flash.events.*;
import mx.managers.PopUpManager;
import spark.components.Button;
import mx.core.IFlexDisplayObject;

// The variable for the TitleWindow container
import spark.primitives.Rect;
import spark.components.Label;
import com.google.maps.LatLng;

public var myTitleWindow:TitleWindow = new TitleWindow();

// Method to instantiate and display a TitleWindow container.
// This is the initial Button control's click event handler.
public function openWindow():void {
	
	// Set the TitleWindow container properties.
	myTitleWindow = new TitleWindow();
	myTitleWindow.title = "Confirmar petición";
	myTitleWindow.width= 300;
	myTitleWindow.height= 160;
	
	// Call the method to add the Button control to the 
	// TitleWindow container.
	populateWindow();
	// Use the PopUpManager to display the TitleWindow container.
	PopUpManager.addPopUp(myTitleWindow, this, true);
}



//-----------------------------------
//  Contenido del panel de aceptar
//-----------------------------------
private var btn1:Button = new Button();
private var btn2:Button = new Button();


public function populateWindow():void {
	var label:Label = new Label();
	
	btn1.x=60;btn1.y=70;
	btn2.x=150;btn2.y=70;
	
	label.text="¿Desea solicitar el recurso en esa posición del mapa?";
	label.x=10; label.y=10; label.width=280;
	
	
	//enlace.addEventListener("click", function(){ MyFuncion(parametro1,parametro2);} , false);
	
	
	btn1.label="Aceptar"; btn1.addEventListener(MouseEvent.CLICK, closeTitleWindow);
	btn2.label="Cancelar"; btn2.addEventListener(MouseEvent.CLICK,closeTitleWindow);
	
	
	myTitleWindow.x=350; myTitleWindow.y=250; 	myTitleWindow.addElement(btn1); 
	myTitleWindow.addElement(btn2); myTitleWindow.addElement(label);
	// Add a close handler for the closeButton
	myTitleWindow.addEventListener("close", cerrarVentanaPop);
}

private function cerrarVentanaPop(e:Event):void{
	myTitleWindow.removeEventListener("close", cerrarVentanaPop);
	PopUpManager.removePopUp(myTitleWindow);
	desenfatizarR();
	//Quitar cuadro info
	this.removeElement(cuadro_info);
	fondo_negro.visible=false;
}

	import com.bomberos.componentes.ItemRecurso; 

import com.google.maps.*;
import com.google.maps.overlays.*;
import com.google.maps.services.*;
import com.google.maps.interfaces.INavigationControl;

private var dir:Directions;				// para calcular la dirección
private var tiempo:String; 
private var distancia:String;

	//añadir el elemento a la lista de los recursos solicitados:
	private var obj:ItemRecurso = new ItemRecurso();




//-----------------------------------
//  FUNCIONES PARA PINTAR LAS RUTAS
//-----------------------------------

//Cuando google devuelve los datos centra el mapa y añade el elemento a la lista de los recursos solicitados.
private function onDirLoad(event:DirectionsEvent):void {
	var dir:Directions = event.directions as Directions;
	trace(dir.distance);			// Distancia en metros
	trace(dir.duration);			// duración en segundos
	trace(dir.durationHtml);			// duración en minutos, con además la palabra minutos
	map.setZoom(map.getBoundsZoomLevel(dir.bounds));
	map.setCenter(dir.bounds.getCenter());
	
	
	
	import com.google.maps.styles.StrokeStyle; 
	
	
	//var line:Polyline = dir.createPolyline();
	

	
	//var contorno:StrokeStyle = new StrokeStyle({color: 0xFF0000,thickness: 4,alpha: 0.7}); 
	
	//line.setOptions( new PolylineOptions({ strokeStyle: contorno	})	); 
	map.addOverlay(dir.createPolyline(new PolylineOptions({ strokeStyle: new StrokeStyle({
		color: 0x000ff,
		thickness: 5,
		alpha: 0.7})}))); 
	
	
	
	
	
	
	obj.tiempo=dir.durationHtml;		// cambiar esto por el dato automático
	obj.dis=roundDecimal((dir.distance/1000),2).toString();
	
	addToRecursos();					// Añade el item a la lista de los recursos.
	
}

private function onDirFail(event:DirectionsEvent):void {
	// Process failure, perhaps by showing an alert
	trace("Error al cargar la ruta en el mapa.");
}

//-----------------------------------
//-----------------------------------
private function addToRecursos():void{
	var objIn:ItemRecurso = new ItemRecurso();
	
	objIn.nombre=obj.nombre;
	objIn.dir= obj.dir;
	objIn.dis=obj.dis;
	objIn.tiempo=obj.tiempo;
	
	lp_recursos.addElement(objIn);					// Añade el obejeto a la lista
}




// The method to close the TitleWindow container.
public function closeTitleWindow(event:MouseEvent):void {
	btn1.removeEventListener(MouseEvent.CLICK, closeTitleWindow);
	btn2.removeEventListener(MouseEvent.CLICK, closeTitleWindow);
	PopUpManager.removePopUp(myTitleWindow);
	desenfatizarR();
	//Quitar cuadro info
	this.removeElement(cuadro_info);
	fondo_negro.visible=false;
	
	
	
	
	
	if (event.target.label=="Aceptar"){
		trace(event.target.label);
		dir= new Directions();
		dir.addEventListener(DirectionsEvent.DIRECTIONS_SUCCESS, onDirLoad);
		dir.addEventListener(DirectionsEvent.DIRECTIONS_FAILURE, onDirFail);
		//dir.load("from: " + from.text + " to: " + to.text);
		//dir.load("from: Illescas to: Leganes");
		
		
		
		
		
		
		//Añadir la marca al mapa
		var i:int;
		//añadimos la marca
		switch (recurso_a_anadir){
			case "b_recursos":
				//buscamos la primera dotación que haya en la matriz de disponibles y la eliminamos de esta matriz
				for (i = 0; i < uds_disponibles.length; i++) {
					if(uds_disponibles[i].tipo=="dotacion"){
						marcaDotacion(uds_disponibles[i],pinchadoEn);					//Añadimos la marca
						
						//añadir el elemento a la lista de los recursos solicitados:
						obj.nombre=uds_disponibles[i].nombre;
						obj.dir=toCoordenates(pinchadoEn);
						
						// Hace la llamada donde calcula los tiempos y añade el objeto a la lista
						//dir.load("from: 40.334466,-3.764841 to: 40.27437734049198,-3.760463634887654");
						dir.load("from: "+ toCoordenatesD(pinchadoEn) +" to: " + toDir(uds_disponibles[i].coordinates));
						
						uds_disponibles.splice(i,1);					//eliminamos ese elemento de la tabla disponibles
						break;
					}
				}
				
				trace("Nuevas disponibles: "+uds_disponibles);
				break;
			
			
			case "b_cisterna":
				
				//buscamos la primera cisterna que haya en la matriz de disponibles y la eliminamos de esta matriz
				for (i= 0; i < uds_disponibles.length; i++) {
					if(uds_disponibles[i].tipo=="cisterna"){
						//Añadimos la marca
						marcaCisterna(uds_disponibles[i],pinchadoEn);
						
						
						//añadir el elemento a la lista de los recursos solicitados:
						obj.nombre=uds_disponibles[i].nombre;
						obj.dir=toCoordenates(pinchadoEn);
						
						// Hace la llamada donde calcula los tiempos y añade el objeto a la lista
						//dir.load("from: 40.334466,-3.764841 to: 40.27437734049198,-3.760463634887654");
						dir.load("from: "+ toCoordenatesD(pinchadoEn) +" to: " + toDir(uds_disponibles[i].coordinates));
						
						
						
						//eliminamos ese elemento de la tabla disponibles
						uds_disponibles.splice(i,1);					//eliminamos ese elemento de la tabla disponibles
						break;
					}
				}
				
				trace("Nuevas disponibles: "+uds_disponibles);
				break;
			
			
			case "b_helicoptero":
				//buscamos la primera dotación que haya en la matriz de disponibles y la eliminamos de esta matriz
				for (i = 0; i < uds_disponibles.length; i++) {
					if(uds_disponibles[i].tipo=="helicoptero"){
						//Añadimos la marca
						marcaHelicoptero(uds_disponibles[i],pinchadoEn);
						
						//eliminamos ese elemento de la tabla disponibles
						
						
						obj.nombre=uds_disponibles[i].nombre;
						obj.dir=toCoordenates(pinchadoEn);
						
						// Distancia:
						var dir1:LatLng = pinchadoEn;
						var dir2:LatLng = toLatLng(uds_disponibles[i].coordinates);
						var disH:Number = roundDecimal((dir1.distanceFrom(dir2))/1000,2);
						obj.dis= disH.toString();
						
						// Velocidad media de un helicóptero: 186 km/h = 51.6667 metro/segundo
						var tmp:Number= roundDecimal((disH/51.667)/60,3)*1000;
						obj.tiempo= tmp+" minutos";
						
						

						
						
						//var lines:Polyline; 
						
						var polyline:Polyline = new Polyline(
							[dir1,dir2],
							new PolylineOptions({ strokeStyle: new StrokeStyle({
								color: 0x000ff,
								thickness: 5,
								alpha: 0.7})
						}));
						
						
						// centra el mapa entre los dos puntos y muestra el zoom también entre los dos
						var bounds:LatLngBounds = new LatLngBounds(dir1,dir2);
						trace(bounds.getCenter());  // outputs "(15, 60)"
						map.setCenter(bounds.getCenter());
						map.setZoom(map.getBoundsZoomLevel(bounds));
					//	map.zoomOut(dir1);
					//	map.setZoom(12);
						
						map.addOverlay(polyline);
						
						addToRecursos();								// Añade a la lista de recursos
						
						uds_disponibles.splice(i,1);					//eliminamos ese elemento de la tabla disponibles
						
						
					/*	// Calculate distance in km between London and Sydney.
						var london:LatLng = new LatLng(51.53, -0.08);
						var sydney:LatLng = new LatLng(-34.0, 151.0);
						trace("km: " + sydney.distanceFrom(london) / 1000);*/
						
						
						
						break;
					}
				}
				
				trace("Nuevas disponibles: "+uds_disponibles);
				break;
			
		}
				
		// después de añadir la marca actualizamos los puntos
		actualizarPuntos();
		
	}
		// Se pulsa en CANCELAR
	else{
		// no hacer nada, salir y ya está.
		trace(event.target.label)
	}
	
	//e.target.emphasized=false;
	bottom_bar.activarBotones(); 
	bottom_bar.gb_herramientas.visible=true;
}