<cfset lcl.editableModel = getDataItem('editableModel')>
<cfset lcl.items = lcl.editableModel.getInfo()>
<cfset lcl.id = lcl.editableModel.getId()>
<cfset lcl.itemsjson = getDataItem('itemsjson')>
<cfset lcl.form = createWidget("formcreator")>
<cfset lcl.plist = lcl.editableModel.getParsedParameterList()>

<style>
	ul#pageItemList { 
		list-style:none;
		margin:0;
		padding:0;
	}
	ul#pageItemList li{
		list-style:none;
		padding:3px;
		margin:0;
	}
	div#msg2 {
		font-weight:bold;
		color:red;
		padding:4px;
		font-size:11px;
	}
</style>
<div id="msg2">

</div>
<table width="100%">
<tr>
<td valign="top">
	<div id="itemListDiv">
    	<ul id="pageItemList">
    	
        </ul>
        
    </div>

    <p>(drag drop for order)</p>
</td>
<td valign="top">

	<div id="itemForm">
        <table class='formtable'>
        <tr>
        <td class='label'>
        <label for='Title'>
        Title
        </label>
        </td>
        <td>
        <input type='text'  name='frmTitle' id='frmTitle' size="50" value=""   >
        </td>
        </tr>
        <input type='hidden' name='id' id='id' value="">
        <tr>
        <td class='label'>
        <label for='Content'>
        Content
        </label>
        </td>
        <td>
        <textarea class="myconfig" name="frmContent" id="frmContent" style='width:500px;height:200px;'></textarea>
        <br /><br />
		<input type="button" value="Save Item" onClick="myFormMgr.saveItem()"/>
        <input type="button" value="Clear for New" onClick="myFormMgr.startadd()"/>
        </td>
        </tr>
        </table>
    </div>
    
</td>
</tr>
</table>


<script language="javascript" type="text/javascript" src="/ui/tiny_mce/tiny_mce.js"></script>


<script language="javascript" type="text/javascript">
    tinyMCE.init({
        mode : "textareas", 
        editor_selector : "myconfig", 
        theme : "advanced",  
        
        theme_advanced_buttons1 : "bold,italic,underline,strikethrough,|,justifyleft,justifycenter,justifyright,styleselect,formatselect",
        theme_advanced_buttons2 : "cut,copy,paste,pastetext,pasteword,|,bullist,numlist,|,outdent,indent,blockquote,|,undo,redo,|,link,unlink,anchor,image,cleanup,help,code",
        theme_advanced_buttons3 : "hr,removeformat,visualaid,sub,sup,|,charmap",
        plugins : "paste,table,advimage",
		<cfif isdefined("lcl.plist.css")>
			<cfoutput>content_css : "/ui/css/tmce.css,/tinymce/getStyle/?file=#urlencodedformat(lcl.plist.css)#",</cfoutput>
		<cfelse>
			content_css : "/ui/css/tmce.css",
		</cfif>
        add_form_submit_trigger : true,
        
        external_link_list_url : "/tinymce/showJSPageList/",
        
        external_image_list_url : "/tinymce/showJSImageList/",
        
        convert_urls : false,
        theme_advanced_buttons3_add : "tablecontrols",
		file_browser_callback : 'fileBrowser'

    });
	function fileBrowser (field_name, url, type, win) {
		// alert("Field_Name: " + field_name + "\nURL: " + url + "\nType: " + type + "\nWin: " + win); // debug/testing
		var cmsURL = window.location.toString();    // script URL - use an absolute path!				
		var mgrURL = cmsURL.substr(0, cmsURL.indexOf("/", 7)) + '/assets/tinymceUpload/';
		
		tinyMCE.activeEditor.windowManager.open({
			file : mgrURL,
			title : 'My File Browser',
			width : 600,  // Your dimensions may differ - toy around with them!
			height : 190,
			resizable : "yes",
			inline : "yes",  // This parameter only has an effect if you use the inlinepopups plugin!
			close_previous : "no"
		}, {
			window : win,
			input : field_name
		});
		return false;
	}


	function submitAjaxForm(){
		
		var myForm = 'id=<cfoutput>#lcl.id#</cfoutput>';
		myForm += '&startsopen=' + document.myForm.startsopen.value;
		myForm += '&moduleaction=' + document.myForm.moduleaction.value;
		myForm += "&items=" + escape(itemList.getItems());
		if (document.myForm.view) myForm += '&view=' + document.myForm.view.value;
		$('#trace').attr("innerHTML", myForm);
		ajaxWResponseJsCaller('/dhtmlpager/saveClientModule/',myForm);
		return false;
	}

	function Items() {
		this.init = function(itms){
				
			itms = eval(itms);
			for (var i = 0; i < itms.length; i++){
				this.addItm(itms[i]);
			}
			$("#pageItemList").sortable({});
			
			//Sortable.create('pageItemList',{ghosting:true});
		}
		this.getItems = function(){
			var a = new Array();

			var links = document.getElementById('pageItemList').childNodes;
			for (var i = 0; i < links.length; i++){
				if (links[i].childNodes.length == 2){
					var itmObj = new Object();
					itmObj.title = links[i].childNodes[0].innerHTML;
		
					itmObj.title = itmObj.title.replace(new RegExp(String.fromCharCode(8212), "g"), "&mdash;")
												.replace(new RegExp(String.fromCharCode(8211), "g"), "&ndash;")
												.replace(new RegExp(String.fromCharCode(174), "g"), "&reg;")
												.replace(new RegExp(String.fromCharCode(169), "g"), "&copy;")
												.replace(new RegExp(String.fromCharCode(8482), "g"), "&trade;")
												.replace(new RegExp(String.fromCharCode(8220), "g"), '"')
												.replace(new RegExp(String.fromCharCode(8221), "g"), '"')
												.replace(new RegExp(String.fromCharCode(8216), "g"), "'")
												.replace(new RegExp(String.fromCharCode(8217), "g"), "'");
					itmObj.content = links[i].childNodes[0].content;
					a.push(itmObj);
				}
			}
			return $.toJSON(a);
		}
		
		this.addItm = function(itm) {
			var myli = document.createElement('LI');
			var mya = document.createElement('A');
			itm.title = itm.title.toString();
			var titlestring = itm.title.replace(/&lt;br[/]?&gt;/g,"<br>");
			titlestring = titlestring.replace(/&mdash;/g, String.fromCharCode(8212))
										.replace(/&ndash;/g, String.fromCharCode(8211))
										.replace(/&reg;/g, String.fromCharCode(174))
										.replace(/&copy;/g, String.fromCharCode(169))
										.replace(/&trade;/g, String.fromCharCode(8482));
			var txt = document.createTextNode(titlestring);

			mya.setAttribute('href', "");
			mya.onclick = function(){
				myFormMgr.startedit(this);
				return false;
			};
			mya.content = itm.content;
			mya.appendChild(txt); 
			myli.appendChild(mya);
			var mydelbtn = document.createElement('IMG');
			mydelbtn.setAttribute('src', '/ui/images/button/delete.gif');
			mydelbtn.onmouseup = function(){itemList.removeItm(mydelbtn);};
			mydelbtn.style.marginLeft = '10px';
			myli.appendChild(mydelbtn); 
			document.getElementById("pageItemList").appendChild(myli);
			
			$("#pageItemList").sortable("refresh");

			//'Sortable.create('pageItemList');//destroy and recreate sorting so that items stay working
			//Sortable.create('pageItemList',{ghosting:true});
			
		}
		this.editItm = function(data) {
			var link = $('#id').attr("linkRef");
			link.content = data.content;
			
			link.innerHTML = data.title;
		}
		this.removeItm = function(itm) {
			myFormMgr.startadd();
			$('#msg2').html("Item \""+itm.parentNode.childNodes[0].innerHTML+"\" Deleted");
			itm.parentNode.parentNode.removeChild(itm.parentNode);
			$("#pageItemList").sortable("refresh");
			
		}
		this.validate = function(itm) {
			if (itm.title == "" || itm.content == ""){
				alert("Both a Title and Content are required");
				return false;
			}
			return true;
		}
	}

	function FormMgr() {
		this.show = function(data) {
			this.items = items;
		}
		this.startadd = function() {
			$('#frmTitle').attr("value", "");
			$('#frmContent').attr("value", "");
			tinyMCE.activeEditor.setContent('');

			document.getElementById("id").linkRef = "";
		}
		this.saveItem = function() {
			var mitem = new Object();
			tinyMCE.triggerSave()

			mitem.title = $('#frmTitle').attr("value");
			mitem.content = $('#frmContent').attr("value");

			if (!itemList.validate(mitem)) return;
			
			var lr = document.getElementById("id").linkRef;
			if (typeof(lr) == 'object'){
				itemList.editItm(mitem);
				$('#msg2').html( "Item \""+mitem.title+"\" Updated");
			} else {
				itemList.addItm(mitem);
				$('#msg2').html("Item \""+mitem.title+"\" Added");
				this.startadd();
			}
		}
		this.startedit = function(itm) {
			$('#frmTitle').attr("value", itm.innerHTML.replace(/&lt;br[/]?&gt;/g,"<br/>").replace("&amp;","&") );
			$('#frmContent').attr("value", itm.content);
			tinyMCE.activeEditor.setContent(itm.content);
			document.getElementById("id").linkRef = itm;
		}
	}

	myFormMgr = new FormMgr();
	
	itemList = new Items();
	itemList.init(<cfoutput>#replace(lcl.itemsJson,"&amp;","&","all")#</cfoutput>);
	window.resizeTo(880, 630);
</script>