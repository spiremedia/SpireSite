

function ajaxWResponseJsCaller(url, formStr ){
	addStopSign();
	
	var info = {
		data : formStr + "&ajax=true",
		error : ajaxWResponseJsCaller_Error,
		success : ajaxWResponseJsCaller_Success,
		type : "POST",
		url : url,
		dataType : "text"
	//    postBody: serializedData + '&ajax=true',
	    // Handle successful response
	//    onSuccess: responseJsCaller,
	    // Handle 404
	 //   on404: function(t) {
	 //       alert('Error 404: location "' + t.statusText + '" was not found.');
	 //   },
	    // Handle other errors
	 //   onFailure: function(t) {
	 //   	if ($('trace')) $('dump').innerHTML = t.responseText;
	 //       alert('Error ' + t.status + ' -- ' + t.statusText);
	 //   }
	}
	$.ajax(info);
	//new Ajax.Request(url, opt);
	return false;
}

function ajaxWResponseJsCaller_Error(XMLHttpRequest, textStatus, errorThrown){
	// typically only one of textStatus or errorThrown 
	// will have info
	
	//for (var z in XMLHttpRequest) alert(z)
	if ($('#dump').length) $('#dump').html(XMLHttpRequest.responseText);
	 //       alert('Error ' + t.status + ' -- ' + t.statusText);
}

function ajaxWResponseJsCaller_Success(data, textStatus){
	removeStopSign();
	
	if (data == 'relogin') location.href='/login/loginForm/';
	
	var jo = eval('(' + data + ')');

	for (var z in jo) {
		try{
			window[z.toLowerCase()](jo[z]);
		} catch(e){
			alert("function : " + z + "\n error : " + e);
			$('#dump').html(data);
		}
	}
	
}
function clearvalidation(){
	//loop thru string and update all images to be checked.
	var errimgs = $('.errorimages').each(function(){
		$(this).attr("src", '/ui/css/images/passed.gif');
		
	});
	
	for (var i = 0; i < errimgs.length; i++){
	  	
	}
}
function validation(d){
	//make string and show it in msg
	var htmlstring = "<ul>";
	for (var i = 0; i < d.length; i++){
	   htmlstring += "<li>" + d[i].TEXT + "</li>";
	}
	
	htmlstring += "</ul>";
	$('#msg').html(htmlstring);
	
	clearvalidation();

	//loop thru string and update failed validation images
	for (var i = 0; i < d.length; i++){
	    if ($('#valimg_' + d[i].FIELD).length) $('#valimg_' + d[i].FIELD).attr("src", '/ui/css/images/error.gif');
	}
}
function focusselectedlinkinnav(){
	$("#browseContent a.selected").each(function(){
		$(this).focus();
		$(this).blur();
	});
}
function message(m){
	//m = m.evalJSON();
	$('#msg').html(m);	
}
function ajaxupdater(t){
	if ($("#" + t.ID).length == 0) return;// alert('in ajaxupdater, element id "'+t.ID+'" was not found');
	if (typeof(t.FOCUSSELECTED) !== 'undefined') $("#" + t.ID).load(t.URL, {}, focusselectedlinkinnav );
	else $("#" + t.ID).load(t.URL);
}

function htmlupdater(t){
	if ($("#" + t.ID).length == 0) alert('in htmlupdater, element id "'+t.ID+'" was not found');
	$("#" + t.ID).html(t.HTML);
}
/*
function reinitializewidgetjs() {
	APP.Base.prototype.baseInitialize();	
}
*/
function verify(txt, url){
	if (confirm(txt)) ajaxWResponseJsCaller(url,'');
}
function relocate(r){
	addStopSign();
	location.href = r;
}
function addStopSign(){
	var statusDiv = document.getElementById("status");
	
	if (statusDiv){
		var ch = statusDiv.childNodes;
		if (ch.length == 1) { 
			ch[0].src = '/ui/images/status/red.png';
		} else if (ch.length > 1){
			statusDiv.innerHTML += "<img src='/ui/images/status/red.png'/>";
		} else {
			alert('missing item in status');
		}
	}
}
function removeStopSign(){
	var statusDiv = document.getElementById("status");
	if (statusDiv){
		var ch = statusDiv.childNodes;
		if (ch.length == 1) { 
			ch[0].src = '/ui/images/status/green.png';
		} else if (ch.length > 1){
			var lastch = ch[ch.length -1];
			statusDiv.removeChild(lastch);
		} else {
			alert('missing item in status');
		}
	}
}
/*
function openWindow(url, width, height, name){	
	var NewWindow = window.open( url ,name , 'directories=0,height=' + height + ',width=' + width + ',location=0,menubar=0,toolbar=0,');
	NewWindow.focus();
}
*/
function openWindow(object){
	var url = '';
	var name = 'default';
	var features = [];
	 
	//set defaults 
	if(!object.directories) 
		features.push('directories=0');
	if(!object.location) 
		features.push('location=0');
	if(!object.menubar) 
		features.push('menubar=0');
	if(!object.toolbar) 
		features.push('toolbar=0');
	if(!object.scrollbars) 
		features.push('scrollbars=0');
	
	 for (var property in object)
	 {
		 switch(property) {
		  case 'url': 
			url = object[property];
			break; 
		  case 'name': 
			name = object[property];
			break; 
		  default: 
			features.push(property+'='+object[property]);
			break; 
		}
	 }
	var NewWindow = window.open( url, name, features.toString() ); 
	NewWindow.focus();
}

function trace(s){
	$("#trace").html(s);	
}

function resetAssetListing(groupname){
	 jQuery(document).trigger('close.facebox');
	$("#" + groupname.replace(/[^a-zA-Z0-9]/g,"")).load("/assets/assetListingHtml/?groupname=" + escape(groupname));
}

function deleteAssetListing(assetid, groupname){
	$.post("/assets/deleteAsset/", {id:assetid}, function(){
		resetAssetListing(groupname);
	});
}