<cfcomponent displayname="PermissionLevelUserTest" extends="mxunit.framework.TestCase">
	
	<cffunction name="setup">
		<cfset teardown()>
		<cfset variables.httpObj = createObject('component','login.logintest').getLoggedInSAUser()>
	</cffunction>
	
	<cffunction name="teardown">
		<cfset d = structnew()>
		
		<cfset d.temp = createObject('component','permissionLevel.permissionLeveltest').teardown()>
		<cfset d.temp = createObject('component','users.usertest').teardown()>
		<cfset d.temp = createObject('component','login.logintest').teardown()>
		<cfset d.temp = createObject('component','contentGroups.contentGroupTest').teardown()>
	</cffunction>
	
    <cffunction name="InterfaceTest">
		<cfset var iT = structnew()>
		<cfset var response = "">
		<cfset var data = structnew()>
		<cfset var lcl = structnew()>
		<cfset variables.httpObj.clear()>
		
		<!--- add user --->
		<cfset variables.httpObj.setPath('/Users/AddUser/')>
		<cfset response = variables.httpObj.load()>
		<cfset l.formFields = response.getESMFormFields()>
		<cfset l.submitsto = response.getESMSubmitsTo()>
		<cfset variables.httpObj.setPath(l.submitsto)>
		<cfset variables.httpObj.clear('formfield,urlfields')>
		<cfset l.fields = structnew()>
		<cfloop list="#l.formfields#" index="l.idx">
			<cfset l.fields[l.idx] = createuuid()>
		</cfloop>
		<cfset l.fields['country'] = 'USA'>
		<cfset l.fields['id'] = ''>
		<cfset l.fields['active'] = 1>
		<cfset lcl.username = "gazook#randrange(340,1000)#@lklklk#randrange(340,1000)#.com">
		<cfset lcl.password = left(l.fields['password'],10)>
		<cfset l.fields['username'] = lcl.username>
		<cfset l.fields['password'] = lcl.password>
		<cfloop collection="#l.fields#" item="l.idx">
			<cfset variables.httpObj.addFormField(l.idx, l.fields[l.idx])>
		</cfloop>		
		<cfset response = variables.httpObj.load()>
		<cfset lcl.userid = response.getByPattern('[a-zA-Z0-9\-]{35}')>
		<cfset asserttrue(condition=(response.existsByPattern("""user added")),message="Did not confirm that a user was added")>
		
		<!--- Add Permission Levels for User --->
		<cfset variables.httpObj.setPath('/PermissionLevel/AddPermissionLevel/')>
		<cfset response = variables.httpObj.load()>
		<cfset iT.formFields = response.getESMFormFields()>
		<cfset iT.submitsto = response.getESMSubmitsTo()>
		<cfset variables.httpObj.setPath(iT.submitsto)>
		<cfset variables.httpObj.clear('formfield,urlfields')>
		<cfset iT.fields = structnew()>
		<cfloop list="#iT.formfields#" index="iT.idx">
			<cfset iT.fields[iT.idx] = "">
		</cfloop>
     	<cfset iT.fields['id'] = "">     
		<cfset iT.fields['name'] = "unittesting">
		<cfset iT.fields['description'] = "ut desc">
		<cfset iT.fields['userids'] = lcl.userid>
		<cfloop collection="#iT.fields#" item="iT.idx">
		<cfset variables.httpObj.addFormField(iT.idx, iT.fields[iT.idx])>
		</cfloop>
		<cfset response = variables.httpObj.load()>
		<cfset lcl.permissionlevelid = response.getByPattern('[a-zA-Z0-9\-]{35}')>
		<cfset asserttrue(condition=(response.existsByPattern("permission level added")),message="The system did not confirm that the item was added")>

		<!--- login as test user --->
		<cfset variables.httpObj = createObject('component','login.logintest').getLoggedInTestUser(username=lcl.username,password=lcl.password)>
		
		<!--- loop through modules and check pemissions --->
		<cfloop list="Login,Users,PermissionLevel,ContentGroups,Assets,Pages,News,Forms,Galleries" index="moduleName">
			<cfset lcl.arrMethod = arrayNew(1)>
			<cfset lcl.arrMethod[1] = "#moduleName#">
			<cfswitch expression="#moduleName#">
				<cfcase value="Login">
					<cfset lcl.arrMethod[1]="Announcement">
				</cfcase>
				<cfcase value="Users">
					<cfset lcl.arrMethod[1]="User">
				</cfcase>
				<cfcase value="ContentGroups">
					<cfset lcl.arrMethod[1]="ContentGroup">
				</cfcase>
				<cfcase value="Assets">
					<cfset lcl.arrMethod[1]="AssetGroup">
					<cfset lcl.arrMethod[2]="Asset">
				</cfcase>
				<cfcase value="Pages">
					<cfset lcl.arrMethod[1]="Page">
				</cfcase>
				<cfcase value="Forms">
					<cfset lcl.arrMethod[1]="Form">
				</cfcase>
				<cfcase value="Galleries">
					<cfset lcl.arrMethod[1]="GalleryImage">
					<cfset lcl.arrMethod[2]="GalleryGroup">
				</cfcase>
				<cfcase value="News">
					<cfset lcl.arrMethod[1]="News">
					<cfset lcl.arrMethod[1]="NewsType">
				</cfcase>
			</cfswitch>

			<!--- view permissions --->
			<!--- <cfset variables.httpObj.setPath('/#moduleName#/StartPage/')>
			<cfset response = variables.httpObj.load()>
			<cfset assertfalse(condition=(response.getStatus() EQ '200'),message="View Permission Failure for #moduleName#.")> --->
			<!--- add permissions --->
			<cfloop from="1" to="#arrayLen(lcl.arrMethod)#" index="i">
				<cfset variables.httpObj.setPath('/#moduleName#/Add#lcl.arrMethod[i]#/')>
				<cfset response = variables.httpObj.load()>
				<cfset assertfalse(condition=(findNoCase("<input type=""submit"" value=""Save""", response.getHTML())),message="Add Permission Failure for #moduleName# Add#lcl.arrMethod[i]# - save button found.")>
				<cfset assertfalse(condition=(refindNoCase("<input type=""button"" (id=""deleteBtn""|value=""Delete"")", response.getHTML())),message="Delete Permission Failure for #moduleName# add#lcl.arrMethod[i]# - delete button found.")>
			</cfloop>			
		</cfloop>
		
		<!--- login as sa user --->
		<cfset variables.httpObj = createObject('component','login.logintest').getLoggedInSAUser()>
		
		<!--- Edit Permission Levels for User --->
		<cfset iT.fields['id'] = lcl.permissionlevelid>
		<cfset variables.httpObj.setPath("/PermissionLevel/editPermissionLevel/")>
		<cfset variables.httpObj.clear('formfields,urlfields')>
		<cfset variables.httpObj.addUrlField('id', iT.fields['id'])>
		<cfset iT.fields['Login_items'] = "View,Add_Announcement,Edit_Announcement,Delete_Announcement">
		<cfset iT.fields['Users_items'] = "View,Add_User,Edit_User,Delete_User">
		<cfset iT.fields['PermissionLevel_items'] = "View,Add_Permission_Level,Edit_Permission_Level,Delete_Permission_Level">
		<cfset iT.fields['ContentGroups_items'] = "View,Add_Content_Group,Edit_Content_Group,Delete_Content_Group">
		<cfset iT.fields['Assets_items'] = "View,Add_Asset,Edit_Asset,Delete_Asset,View_Asset_Groups,Add_Asset_Group,Edit_Asset_Group,Delete_Asset_Group">
		<cfset iT.fields['ContentGroups_items'] = "View,Add_Content_Group,Edit_Content_Group,Delete_Content_Group">
		<cfset iT.fields['Pages_items'] = "View,Add_Page,Edit_Page,Delete_Page,Publish_Page,Reviewable_Pages,Reviseable_Pages,Draft_Pages,Manage_Subsites">
		<cfset iT.fields['News_items'] = "View,Add_News,Edit_News,Delete_News,View_News_Types,Add_News_Type,Edit_News_Type,Delete_News_Type">
		<cfset iT.fields['Forms_items'] = "View,Add_Form,Edit_Form,Delete_Form">
		<cfset iT.fields['Galleries_items'] = "View,Add_Gallery_Image,Edit_Gallery_Image,Delete_Gallery_Image,View_Gallery_Groups,Add_Gallery_Group,Edit_Gallery_Group,Delete_Gallery_Group">

		<cfset iT.fieldsBackup = duplicate(iT.fields)>
		<cfset response = variables.httpObj.load()>
		<cfset iT.fieldsOut = response.getESMFormStruct()>
		<cfset variables.httpObj.clear('formfields,urlfields')>
		<cfloop collection="#iT.fieldsBackup#" item="iT.idx">
			<cfset variables.httpObj.addFormField(iT.idx, iT.fieldsBackup[iT.idx])>
		</cfloop>
		<cfset variables.httpObj.setPath("/PermissionLevel/savePermissionLevel/")>
		<cfset response = variables.httpObj.load()>
		<cfset asserttrue(condition=(response.existsByPattern("Permission Level Updated")),message="The system did not confirm the update.")>

		<!--- Add Content Group for User  --->
		<cfset variables.httpObj.setPath('/ContentGroups/AddContentGroup/')>
		<cfset response = variables.httpObj.load()>
		<cfset iT.formFields = response.getESMFormFields()>
		<cfset iT.submitsto = response.getESMSubmitsTo()>
		<cfset variables.httpObj.setPath(iT.submitsto)>
		<cfset variables.httpObj.clear('formfield,urlfields')>
		<cfset iT.fields = structnew()>
		<cfloop list="#iT.formfields#" index="iT.idx">
			<cfset iT.fields[iT.idx] = "">
		</cfloop>
     	<cfset iT.fields['id'] = 0>    
		<cfset iT.fields['name'] = "unittesting">
		<cfset iT.fields['description'] = "ut desc">
		<cfset iT.fields['usersingroup'] = lcl.userid>
		<!--- get homepage --->
		<cfquery name="data.getsomepagesquery" datasource="#request.requestObject.getVar('dsn')#">
		SELECT id FROM sitepages WHERE status = 'Published' AND parentid = ''
		</cfquery>
		<cfset iT.fields['sitepages'] = data.getsomepagesquery.id>
		<cfloop collection="#iT.fields#" item="iT.idx">
			<cfset variables.httpObj.addFormField(iT.idx, iT.fields[iT.idx])>
		</cfloop>
		<cfset response = variables.httpObj.load()>
		<cfset asserttrue(condition=(response.existsByPattern("content group added")),message="The system did not confirm that the item was added")>
		
		<!--- login as test user --->
		<cfset variables.httpObj = createObject('component','login.logintest').getLoggedInTestUser(username=lcl.username,password=lcl.password)>
		
		<!--- loop through modules and check pemissions --->
		<cfloop list="Login,Users,PermissionLevel,ContentGroups,Assets,Pages,News,Forms,Galleries" index="moduleName">
			<cfset lcl.arrMethod = arrayNew(1)>
			<cfset lcl.arrMethod[1] = "#moduleName#">
			<cfswitch expression="#moduleName#">
				<cfcase value="Login">
					<cfset lcl.arrMethod[1]="Announcement">
				</cfcase>
				<cfcase value="Users">
					<cfset lcl.arrMethod[1]="User">
				</cfcase>
				<cfcase value="ContentGroups">
					<cfset lcl.arrMethod[1]="ContentGroup">
				</cfcase>
				<cfcase value="Assets">
					<cfset lcl.arrMethod[1]="AssetGroup">
					<cfset lcl.arrMethod[2]="Asset">
				</cfcase>
				<cfcase value="Pages">
					<cfset lcl.arrMethod[1]="Page">
				</cfcase>
				<cfcase value="Forms">
					<cfset lcl.arrMethod[1]="Form">
				</cfcase>
				<cfcase value="Galleries">
					<cfset lcl.arrMethod[1]="GalleryImage">
					<cfset lcl.arrMethod[2]="GalleryGroup">
				</cfcase>
				<cfcase value="News">
					<cfset lcl.arrMethod[1]="News">
					<cfset lcl.arrMethod[1]="NewsType">
				</cfcase>
			</cfswitch>

			<!--- view permissions --->
			<cfset variables.httpObj.setPath('/#moduleName#/StartPage/')>
			<cfset response = variables.httpObj.load()>
			<cfset asserttrue(condition=(response.getStatus() EQ '200'),message="View Permission Failure for #moduleName#.")>
			<!--- edit / delete permissions --->
			<cfloop from="1" to="#arrayLen(lcl.arrMethod)#" index="i">
				<cfset variables.httpObj.setPath('/#moduleName#/edit#lcl.arrMethod[i]#/?id=#lcl.userid#')>
				<cfset response = variables.httpObj.load()>
				<cfset assertTrue(condition=(findNoCase("<input type=""submit"" value=""Save""", response.getHTML())),message="Edit Permission Failure for #moduleName# edit#lcl.arrMethod[i]# - save button not found.")>
				<cfset assertTrue(condition=(refindNoCase("<input type=""button"" (id=""deleteBtn""|value=""Delete"")", response.getHTML())),message="Delete Permission Failure for #moduleName# edit#lcl.arrMethod[i]# - delete button not found.")>
			</cfloop>			
		</cfloop>
	</cffunction>
	
</cfcomponent>