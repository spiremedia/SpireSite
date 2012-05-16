<cfcomponent name="asset model" output="false" extends="resources.abstractmodel">

	<cffunction name="init">
		<cfargument name="request" required="true">
		<cfargument name="userobj" required="true">
		<cfset variables.request = arguments.request>
		<cfset variables.userobj = arguments.userobj>
		<cfreturn this>
	</cffunction>
    
    <cffunction name="getInfo">
		<cfargument name="imgfile" required="true">
        
        <cfset var lcl = structnew()>
		<cfset var local2 = structnew()>
        <cfimage
            action = "info"
            source = "#arguments.imgfile#"
            structname = "lcl.imginfo">
        
       	<cfset local2.w = lcl.imginfo.width>
		<cfset local2.h = lcl.imginfo.height>
        <cfset local2.found = 1>
        
		<cfreturn local2>
	</cffunction>
       
    <cffunction name="crop">
		<cfargument name="imgfile" required="true">
        <cfargument name="x" required="true">
        <cfargument name="y" required="true">
        <cfargument name="w" required="true">
        <cfargument name="h" required="true">
      
		<cfset var lcl = structnew()>
        
        <cfimage source="#imgfile#" name="lcl.myimg">
              
        <cfset ImageCrop(lcl.myimg, x, y, w, h)>
        
		<cfimage source="#lcl.myimg#" action="write" destination="#imgfile#" overwrite="yes">

		<cfimage
            action = "info"
            source = "#lcl.myimg#"
            structname = "lcl.imginfo">
        
       	<cfset local2.w = lcl.imginfo.width>
		<cfset local2.h = lcl.imginfo.height>
        <cfset local2.found = 1>
        
		<cfreturn local2>
	</cffunction>
    
    <cffunction name="rotate">
		<cfargument name="imgfile" required="true">
        <cfargument name="degrees" required="true">
      
		<cfset var lcl = structnew()>
        
        <!---<cfimage source="#imgfile#" name="lcl.myimg">--->
          
        <cfimage
            action = "rotate"
            angle = "#degrees#"
            source = "#imgfile#"
            destination="#imgfile#"
            overwrite = "yes">

		<cfimage
            action = "info"
            source = "#imgfile#"
            structname = "lcl.imginfo">
        
       	<cfset local2.w = lcl.imginfo.width>
		<cfset local2.h = lcl.imginfo.height>
        <cfset local2.found = 1>
        
		<cfreturn local2>
	</cffunction>
    
    <cffunction name="resize">
		<cfargument name="imgfile" required="true">
        <cfargument name="w" required="true">
        <cfargument name="h" required="true">
      
		<cfset var lcl = structnew()>
   
        <cfimage 
         	action="resize" 
            source="#imgfile#" 
            width="#w#"
   	 		height="#h#" 
            destination="#imgfile#"
            overwrite="yes">
   
		<cfimage
            action = "info"
            source = "#imgfile#"
            structname = "lcl.imginfo">
        
       	<cfset local2.w = lcl.imginfo.width>
		<cfset local2.h = lcl.imginfo.height>
        <cfset local2.found = 1>
        
		<cfreturn local2>
	</cffunction>
	
</cfcomponent>
	