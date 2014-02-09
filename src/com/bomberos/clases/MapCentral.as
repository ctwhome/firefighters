package com.bomberos.clases
{

	import com.bomberos.clases.Llamada;
	import flash.events.EventDispatcher;
	
	import com.google.maps.InfoWindowOptions;
	import com.google.maps.LatLng;
	import com.google.maps.LatLngBounds;
	import com.google.maps.Map3D;
	import com.google.maps.MapEvent;
	import com.google.maps.MapMouseEvent;
	import com.google.maps.MapType;
	import com.google.maps.StyledMapType;
	import com.google.maps.controls.*;
	import com.google.maps.interfaces.IPane;
	import com.google.maps.interfaces.IPaneManager;
	import com.google.maps.overlays.*;
	import com.google.maps.overlays.GroundOverlay;
	import com.google.maps.overlays.GroundOverlayOptions;
	import com.google.maps.styles.*;
	

	
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	
	import com.bomberos.clases.Llamada;
	import com.bomberos.clases.ClaseDispatcher;
	
	
	public class MapCentral extends Map3D
	{
		private var dispatcher:ClaseDispatcher;					// Lanza el evento de llamada.
		//----------------------------------------------------
		//  Variable para las capas de las marcas y polígonos
		//----------------------------------------------------
		public var capa_marcas:IPane;							// Creación del panel de las marcas
		public var capa_poligonos:IPane;						// Creación del panel del polígono
		
		// Capas XML
		public var capa_parques:IPane;							// Creación del panel de los parques
		public var capa_hidrantes:IPane;						// Creación del panel del hidrantes
		public var capa_garajes:IPane;							// Creación del panel de los garages
		public var capa_toxicos:IPane;							// Creación del panel del toxicos
		public var capa_unidades:IPane;							// Creación del panel de las unidades acativas
		public var capa_metro:IPane;							// Creación del panel de las unidades acativas
		public var capa_medir:IPane;							// Creación del panel de las unidades acativas
		
		private var manager:IPaneManager;						// Manager de la "Sobre Capa"
		private var manager_pol:IPaneManager;
		// Managers para las capas XML
		private var manager_parques:IPaneManager;
		private var manager_hidrantes:IPaneManager;
		private var manager_garajes:IPaneManager;
		private var manager_toxicos:IPaneManager;
		private var manager_unidades:IPaneManager;				// Manager Unidades
		private var manager_metro:IPaneManager;				// Manager Unidades
		private var manager_medir:IPaneManager;				// Manager Unidades
		
		
		//-----------------------------------
		//  Variables
		//-----------------------------------
		//	public var map:Map;									// Variable mapa, global para el paquete, se utiliza this
		public var lat:Number = 40.333157;						// Posición y zoom inicial del mapa
		public var lon:Number = -3.766261;						// Puede obtenerse por geolocalización
		public var zoomInit:Number = 17;
		public var anchoMap:Number = 1035; 
		public var altoMap:Number = 668; 						// Es un poco más alto para que la barra de abajo oculte el logotipo de google, OJO: esto es ilegal
		public var metroSur:GroundOverlay;						// Imagen del metroSur
		
		//--------------------------------------------------------------------------
		//
		//  Constructor: Map central
		//
		//--------------------------------------------------------------------------
		public function MapCentral()
		{
			super();										// Herencia de la clase UIComponent.
			//	this = new Map3D();
			this.key="ABQIAAAAfW_QHvvoxG1oKWN-_ooRrRS4R2vLJZ5MaorvhZfCuwsqwi3tPRT0wVFfkmX76VJUfWw1aFd-A0Ho9Q";
			this.url = "http://ctwhome.com" ;
			this.sensor="false";
			this.focusRect="false";
			this.addEventListener(MapEvent.MAP_READY, onMapReady);
			
			//	addChild(map);	
			
		} // Fin del constructor
		
		
		//--------------------------------------------------------------------------
		//
		//  On Map Ready: función que inicializa el mapa 
		//
		//--------------------------------------------------------------------------
		private function onMapReady(event:Event):void {	
			
			//------------------------------------------------------------
			// creación de las capas para las marcas y sus Managers.
			//------------------------------------------------------------
			manager 		  =	this.getPaneManager();			// Capa Marcas
			manager_pol		  = this.getPaneManager();			// Capa Polígonos
			manager_parques   =	this.getPaneManager();			// Capa Parques
			manager_hidrantes = this.getPaneManager();			// ...
			manager_garajes   =	this.getPaneManager();			// ...
			manager_toxicos   =	this.getPaneManager();			// ...
			manager_unidades  =	this.getPaneManager();			// ...
			manager_metro	  =	this.getPaneManager();			// ...
			manager_medir	  =	this.getPaneManager();			// ...
			
			manager.createPane(9);								// crea las opciones del panel, el manager
			manager_pol.createPane(3);							// crea las opciones del panel, el manager
			manager_parques.createPane(5);						// ...
			manager_hidrantes.createPane(6);					// ...
			manager_garajes.createPane(7);						// ...
			manager_toxicos.createPane(8);						// ...
			manager_unidades.createPane(2);						// ...
			manager_metro.createPane(1);						// ...
			manager_medir.createPane(10);						// ...
			
			capa_marcas 	= manager.getPaneAt(9);				// el 0 indica el orden (mayor arriba).
			capa_poligonos 	= manager_pol.getPaneAt(3);			// el orden de la capa polígonos.
			capa_parques	= manager_parques.getPaneAt(5);		// ...	
			capa_hidrantes	= manager_hidrantes.getPaneAt(6);	// ...		
			capa_garajes	= manager_garajes.getPaneAt(7);		// ...	
			capa_toxicos	= manager_toxicos.getPaneAt(8);		// ...
			capa_unidades	= manager_unidades.getPaneAt(2);	// ...
			capa_metro		= manager_metro.getPaneAt(1);	// ...
			capa_medir		= manager_medir.getPaneAt(10);	// ...
			
			
			
			//-----------------------------------
			//  Capas Ocultadas  a priori
			//-----------------------------------
			capa_parques.visible=false;
			capa_hidrantes.visible=false;
			capa_garajes.visible=false;
			capa_toxicos.visible=false;
			
			
			//-----------------------------------
			//  Opciones del Mapa
			//-----------------------------------			
			this.setSize(new Point(anchoMap, altoMap));			// Tamaño del mapa dentro del contenedor mapHolder
			this.setCenter(new LatLng(lat, lon), zoomInit);		// Centramos el mapa
			this.enableScrollWheelZoom();						// Activa el scroll del ratón en PC
			this.enableContinuousZoom();
			//	this.setMapType(MapType.HYBRID_MAP_TYPE());		//inicia el Mapa en este modo
			
			
			/*  
			//-----------------------------------
			// TIPO DE MAPA
			//-----------------------------------
			VIEWMODE_2D    			=> Mapa 2d
			VIEWMODE_PERSPECTIVE	=> Mapa con perspectiva: requiere más potencia
			VIEWMODE_ORTHOGONAL		=> MApa con perspectiva sin deformación: equipos más lentos.*/
			//map.viewMode = View.VIEWMODE_2D;  			
			//map.setAttitude(new Attitude(0,0,0));  			// perspectiva de la vista en grados= de 0º a 70º para cada eje
			
			//----------------------------------------
			// DIBUJA UNA lÏNEA: Polyline overlay	
			//----------------------------------------
			/* var polyline:Polyline = new Polyline([
				new LatLng(37.4419, -122.1419),
				new LatLng(37.4519, -122.1519)], 
				new PolylineOptions({
					strokeStyle: new StrokeStyle({
						color: 0xFF0000,
						thickness: 4,
						alpha: 0.7})
				}));
			
			this.addOverlay(polyline);*/
			
			//------------------------------------------------
			// VISTA DEL NAVEGADOR EN MINIATURA DEL MAPA
			// ejemplo completo: http://code.google.com/p/gmaps-samples-flash/source/browse/trunk/samplecode/com/google/maps/examples/ControlOptions.as?r=21		
			//------------------------------------------------			
			var overviewMapControlOptions:OverviewMapControlOptions = new OverviewMapControlOptions({
			padding: new Point(3, 3),
			size: new Point(216, 140),
			controlStyle: new BevelStyle({bevelAlpha: .5, 
			bevelStyle: BevelStyle.BEVEL_RAISED,
			bevelThickness: 2}),
			navigatorStyle: new RectangleStyle({fillStyle: new FillStyle({alpha: 0}),
			strokeStyle: new StrokeStyle({alpha: 0.5, thickness: 1, color: 0xFFF000}),
			bevelStyle: BevelStyle.BEVEL_RAISED }),
			position: new ControlPosition(ControlPosition.ANCHOR_TOP_RIGHT, -232, 5)	});
			this.addControl(new OverviewMapControl(overviewMapControlOptions));
					
			//------------------------------------------------------------------
			// CONTROL DEL ZOOM map.setCenter(new LatLng(lat, lon), zoomInit);
			//------------------------------------------------------------------			
			/*var posicionZoom:ControlPosition = new ControlPosition(ControlPosition.ANCHOR_TOP_LEFT, 25,250);
			var cZoom:ZoomControl= new ZoomControl();
			cZoom.setControlPosition(posicionZoom);  
			this.addControl(cZoom);
			*/
			
			
			//-----------------------------------
			// Control de escala y Zoom
			//-----------------------------------
			var posicionScale:ControlPosition = new ControlPosition(ControlPosition.ANCHOR_TOP_LEFT, 70, 585);
			var cScale:ScaleControl= new ScaleControl();
			cScale.setControlPosition(posicionScale);  
			this.addControl(cScale);

			
			/*MARCAS pulsando la tecla SHIFT en google maps, aparecen las coordenadas de dónde esté el ratón.
			
			//latlon de las marcas
			
			helicoptero: 
			m1: 40.33191, -3.76780
			m2: 40.33178,  -3.76776
			m3: 40.33168,  -3.76749
			//el que esta arriba
			m4: 40.33436,  -3.76489  */
			
			//var markerOptions:MarkerOptions = new MarkerOptions(); 
			//markerOptions.icon = marker_icon; 
			//if (hideControles){ map.clearControls(); } 
			//if (dragDisabled) { map.disableDragging(); } 
			
			
			/*var pView:GOverviewMapControl = new GOverviewMapControl();
			pView.x = 30;
			pView.y = 600;
			map.addControl(pView);
			*/
			// map.addControl(new GOverviewMapControl()); 
			
			
			/*	var bottomRight:ControlPosition = new ControlPosition(ControlPosition.ANCHOR_TOP_RIGHT, 16, 10);
			var myMapTypeControl:MapTypeControl = new MapTypeControl();
			myMapTypeControl.setControlPosition(bottomRight);  
			map.addControl(myMapTypeControl);;*/
			
			
			//getXml();
			
			
			//----------------------------------------
			//  IMAGEN DENTRO DE UNA CAPA: METRO SUR
			//----------------------------------------

			var testLoader:Loader = new Loader();
			var urlRequest:URLRequest = new URLRequest("http://ctwhome.com/xml/MetroSur.jpg");
			testLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void {
				metroSur= new GroundOverlay(
					testLoader,
					new LatLngBounds(new LatLng(40.2702,-3.9067), new LatLng(40.3764,-3.6906)));
			metroSur.visible=false;
			capa_metro.addOverlay(metroSur);
			});
			testLoader.load(urlRequest);  
			
		
			
			//-----------------------------------
			//  Recojer las unidades del XML
			//-----------------------------------
			dispatcher = ClaseDispatcher.getInstancia();
			dispatcher.dispatchEvent(new Llamada(Llamada.ACCION,'MAPA_CARGADO',''));
			
			
			
			
			
			
		/*	
			// RUTAS CODIFICADAS!!!!!!!! NO TE LO PIERDAS!!
			import com.google.maps.MapEvent;
			import com.google.maps.Map;
			import com.google.maps.overlays.Polyline;
			import com.google.maps.overlays.PolylineOptions;
			import com.google.maps.overlays.EncodedPolylineData;
			import com.google.maps.MapType;
			import com.google.maps.LatLng;
			import com.google.maps.controls.ZoomControl;
			import com.google.maps.controls.MapTypeControl;
			import com.google.maps.styles.StrokeStyle;
			
	
				// Add an encoded polyline.
				var encodedPoints:String = "iuowFf{kbMzH}N`IbJb@zBpYzO{dAvfF{LwDyN`_@`NzKqB|Ec@|L}BKmBbCoPjrBeEdy@uJ`Mn@zoAer@bjA~Xz{JczBa]pIps@de@tW}rCdxSwhPl`XgikCl{soA{dLdAaaF~cCyxCk_Aao@jp@kEvnCgoJ`]y[pVguKhCkUflAwrEzKk@yzCv^k@?mI";
				var encodedLevels:String = "B????????????????????????????????????B";
				
				var encodedPolyline:Polyline = Polyline.fromEncoded(
					new EncodedPolylineData(encodedPoints, 32, encodedLevels, 4), 
					new PolylineOptions({ strokeStyle: new StrokeStyle({
						color: 0x0000ff,
						thickness: 4,
						alpha: 0.7})
					}));
				this.addOverlay(encodedPolyline);*/
			
			
			
			
			
			
		/*	dir = new Directions();
			dir.addEventListener(DirectionsEvent.DIRECTIONS_SUCCESS, onDirLoad);
			dir.addEventListener(DirectionsEvent.DIRECTIONS_FAILURE, onDirFail);*/
			
			
			
		
			
		} // Fin onMapReady
		
		
		
		
		
		
		
		
		//-----------------------------------
		//  Bottones Zoom Personalizados
		//-----------------------------------
		private function createButton(text:String,
									  x:Number, 
									  y:Number,
									  callback:Function):void {
			var button:Sprite = new Sprite();
			button.x = x;
			button.y = y;
			
			var label:TextField = new TextField();
			label.text = text;
			label.x = 2;
			label.selectable = false;
			label.autoSize = TextFieldAutoSize.CENTER;
			var format:TextFormat = new TextFormat("Verdana");
			label.setTextFormat(format);
			
			var buttonWidth:Number = 30;
			var background:Shape = new Shape();
			background.graphics.beginFill(0xFFFFFF);
			background.graphics.lineStyle(1, 0x000000);
			background.graphics.drawRoundRect(0, 0, buttonWidth, 30, 4);
			
			button.addChild(background);
			button.addChild(label);
			button.addEventListener(MouseEvent.CLICK, callback);
			
			addChild(button);
		}
		
		
		/*****************************************
		 * Métodos de la clase MapCentral 		 *
		 * ***************************************/
		
		
		/* Funciones para cambiar el tipo de mapa. 
		Serán llamados desde la bottom_bar.  */
		public function cambiarMapa(mapa:String):void{
			
			// Definir los estilo
			var estiloAtlas:StyledMapType = new StyledMapType(roadAtlasStyles);      	// Mapa de Carreteras Americano:
			var estiloContraste:StyledMapType = new StyledMapType(contrasteStyles);     // Mapa de Carreteras HipHop:
			var estiloRosado:StyledMapType = new StyledMapType(originalStyles);         // Mapa de Carreteras HipHop:
			
			switch (mapa){
				case "RELIEVE": 	this.setMapType(MapType.PHYSICAL_MAP_TYPE);	 
					if (this.getZoom()>15){this.setZoom(15)}			break;
				case "NORMAL":  	this.setMapType(MapType.NORMAL_MAP_TYPE); 		break;
				case "HIBRIDO":  	this.setMapType(MapType.HYBRID_MAP_TYPE); 		break;
				case "SATELITE":  	this.setMapType(MapType.SATELLITE_MAP_TYPE); 	break;
				case "ATLAS":       this.setCenter( this.getCenter(), this.getZoom(), estiloAtlas);		break;
				case "CONTRASTE":	this.setCenter( this.getCenter(), this.getZoom(), estiloContraste);	break;
				case "ROSADO":		this.setCenter( this.getCenter(), this.getZoom(), estiloRosado);	break;      
			}// Fin del Switch
		}// fin de cambiar mapa.
		
		
		
		/*****************************************
		 * Estilos personalizados de los mapas	 *
		 * ***************************************/
		
		//Estilo de Mapa Americano
		private var roadAtlasStyles:Array = [
			new MapTypeStyle(MapTypeStyleFeatureType.ROAD_HIGHWAY,
				MapTypeStyleElementType.GEOMETRY,
				[MapTypeStyleRule.hue(0xff0022),
					MapTypeStyleRule.saturation(60),
					MapTypeStyleRule.lightness(-20)]),
			new MapTypeStyle(MapTypeStyleFeatureType.ROAD_ARTERIAL,
				MapTypeStyleElementType.GEOMETRY,
				[MapTypeStyleRule.hue(0x2200ff),
					MapTypeStyleRule.lightness(-40),
					MapTypeStyleRule.visibility("simplified"),
					MapTypeStyleRule.saturation(30)]),
			new MapTypeStyle(MapTypeStyleFeatureType.ROAD_LOCAL,
				MapTypeStyleElementType.ALL,
				[MapTypeStyleRule.hue(0xf6ff00),
					MapTypeStyleRule.saturation(50),
					MapTypeStyleRule.gamma(0.7),
					MapTypeStyleRule.visibility("simplified")]),
			new MapTypeStyle(MapTypeStyleElementType.GEOMETRY,
				MapTypeStyleFeatureType.WATER,
				[MapTypeStyleRule.saturation(40),
					MapTypeStyleRule.lightness(40)]),
			new MapTypeStyle(MapTypeStyleFeatureType.ROAD_HIGHWAY,
				MapTypeStyleElementType.LABELS,
				[MapTypeStyleRule.visibility("on"),
					MapTypeStyleRule.saturation(98)]),
			new MapTypeStyle(MapTypeStyleFeatureType.ADMINISTRATIVE_LOCALITY,
				MapTypeStyleElementType.LABELS,
				[MapTypeStyleRule.hue(0x0022ff),
					MapTypeStyleRule.saturation(50),
					MapTypeStyleRule.lightness(-10),
					MapTypeStyleRule.gamma(0.9)]),
			new MapTypeStyle(MapTypeStyleFeatureType.TRANSIT_LINE,
				MapTypeStyleElementType.GEOMETRY,
				[MapTypeStyleRule.hue(0xff0000),
					MapTypeStyleRule.visibility("on"),
					MapTypeStyleRule.lightness(-70)])          
		];
		
		// Estilo hip Hop, calles verdes y bloques en negro
		private var contrasteStyles:Array = [
			new MapTypeStyle(MapTypeStyleFeatureType.ROAD_LOCAL,
				MapTypeStyleElementType.GEOMETRY,
				[MapTypeStyleRule.hue(0x00ff00),
					MapTypeStyleRule.saturation(100)]),
			new MapTypeStyle(MapTypeStyleFeatureType.LANDSCAPE,
				MapTypeStyleElementType.GEOMETRY,
				[MapTypeStyleRule.lightness(-100)])
		];
		
		
		// carreterass rojas‚
		private var originalStyles:Array = [
			new MapTypeStyle(MapTypeStyleFeatureType.ALL,
				MapTypeStyleElementType.ALL,
				[MapTypeStyleRule.saturation(-80)]),
			new MapTypeStyle(MapTypeStyleFeatureType.ROAD,
				MapTypeStyleElementType.GEOMETRY,
				[MapTypeStyleRule.saturation(70),
					MapTypeStyleRule.hue(0xff0000)])
		];
		
		
	} // Fin de la clase MapCentral	
}// Fin del paquete com.bomberos.clases