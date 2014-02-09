import spark.components.Image;

// Funciones comunes, conversores y demás. 

//devuelve el latlng en formato string con el dato dado la vuelta.
public function toCoordenates(ll:LatLng):String{
	var l:String=ll.toString();
	
	var dir:Array = l.split(",");
	//le da la vuelta al caracter y borra los paréntesis que se forman en medio
	var posicion:String = dir[1].substring(0, dir[1].length-1)+","+dir[0].substring(1, dir[0].length-1);	
	
	return posicion;
}


//-----------------------------------
//  Convertir String (Coordinates del xml) a LatLng
//-----------------------------------
public function toLatLng(pos:String):LatLng{
	var dir:Array = pos.split(",");
	var posicion:LatLng = new LatLng(Number(dir[1]),Number(dir[0]));
	return posicion;
}

//-----------------------------------
//  Convertir String (Coordinates del xml) a String de la dirección: 40.334466,-3.764841
//-----------------------------------
public function toDir(pos:String):String{
	var dir:Array = pos.split(",");
	var posicion:String = dir[1]+","+dir[0];
	return posicion;
}

//devuelve el latlng en formato string con el dato dado la vuelta.
public function toCoordenatesD(ll:LatLng):String{
	var l:String=ll.toString();
	
	var dir:Array = l.split(",");
	//le da la vuelta al caracter y borra los paréntesis que se forman en medio
	var posicion:String = dir[0].substring(1, dir[0].length-1)+","+dir[1].substring(0, dir[1].length-1);	
	
	return posicion;
}


// redondear un número
public function roundDecimal(num:Number, precision:int):Number{
	
	var decimal:Number = Math.pow(10, precision);
	
	return Math.round(decimal* num) / decimal;
	
}


// Rotación de la la dirección del viento.
// Se necesita esta función porque Flex por defecto gira las imágenes según el vértice sup. izq.
// Esta función hace que el giro sea respecto al centro de la imagen.
private function rotateImage(image:Image, degrees:Number):void {
	// Calculate rotation and offsets
	var radians:Number = degrees * (Math.PI / 180.0);
	var offsetWidth:Number = image.width/2.0;
	var offsetHeight:Number =  image.height/2.0;
	
	// Perform rotation
	var matrix:Matrix = new Matrix();
	matrix.translate(-offsetWidth, -offsetHeight);
	matrix.rotate(radians);
	matrix.translate(+offsetWidth, +offsetHeight);
	matrix.concat(image.transform.matrix);
	image.transform.matrix = matrix;
}



// ************************************************************
// *    MAPA DE VIENTO 			
// ************************************************************
private var img_viento_creada:Boolean=false;
private var img:Image = new Image();
private function lineas_viento_pantalla():void{
	
	// si la imagen no ha sido creada se crea
	if (!img_viento_creada){
		
		img.x=340; img.y=110; img.width=475; img.height= 469; 
		img.source="assets/tiempo/viento_giant.png";
		rotateImage(img, Number(visor_tiempo.dir))//Gira la imagen del viento
		img.visible=false;
		img_viento_creada=true;
		addElement(img);
	}
	//ABRE LA IMAGEN
	if(!bottom_bar.b_viento_bottom.emphasized){
		bottom_bar.b_viento_bottom.emphasized=true; 
		//Desactivar el resto de botones
		bottom_bar.b_mapas.enabled=false;bottom_bar.b_marcas.enabled=false; bottom_bar.b_capas.enabled=false;
		bottom_bar.b_medir.enabled=false;bottom_bar.b_web.enabled=false;bottom_bar.b_herramientas.enabled=false;
		b_recursos.enabled=false;b_cisterna.enabled=false;b_helicoptero.enabled=false; b_peticion.enabled=false;b_peticion.enabled=false;
		
		
		
		img.visible=true;
	}
	else{
		img.visible=false;
		bottom_bar.b_viento_bottom.emphasized=false; 
		
		//activar el resto de los botones. 
		bottom_bar.b_mapas.enabled=true;bottom_bar.b_marcas.enabled=true; bottom_bar.b_capas.enabled=true;
		bottom_bar.b_medir.enabled=true;bottom_bar.b_web.enabled=true;bottom_bar.b_herramientas.enabled=true;
		b_peticion.enabled=true;
		actualizarPuntos();
		
		
		
	}
		
}