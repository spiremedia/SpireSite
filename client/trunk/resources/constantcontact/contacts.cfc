<cfcomponent displayname="Contacts" output="false">

<cffunction name="init"	
	output="false" 
	access="public" 
	hint="Return this object">
		<cfargument name="requestObject" required="true">
		<cfset variables.requestObject = arguments.requestObject>
		
		<!--- Set Login Credentials --->
		<cfset variables.Username  = variables.requestObject.getVar('ccUsername')> 		<!--- Username for  your account --->
		<cfset variables.Password  = variables.requestObject.getVar('ccPassword')>		<!--- Password for your account --->
		<cfset variables.ApiKey    = variables.requestObject.getVar('ccApiKey')>			<!--- Api Key for your account --->
			
		<!--- Opt In Source (who is performing these actions?) --->
		<cfset variables.optInSource = variables.requestObject.getVar('ccOptInSource')>
		<!--- 
			ACTION_BY_CUSTOMER - Constant Contact account holder. Used in internal applications.
			ACTION_BY_CONTACT - Site visitor. Used in web site sign-up forms. 
		--->
		
		<!--- Typical modifications end here --->
		<cfset variables.apiPath = "https://api.constantcontact.com/ws/customers/#variables.requestObject.getVar('ccUsername')#">
		<!--- apiPath - Used for server calls --->
		<cfset variables.doNotInclude = "Active,Do Not Mail,Removed">
		<!--- doNotInclude - Lists that should not be returned throughout the application --->
				
		<cfreturn this>	
	<cfreturn this>
</cffunction>

<!--- Function: doServerCall --->
<cffunction 
	name="doServerCall" 
	access="public" 
	output="false" 
	hint="HTTP Utility Function for all server calls"> 
	
	<cfargument 
		name="type" 
		required="true"
		type="string"
		hint="Type of request to make (ie: get, post, put, delete)">
	
	<cfargument 
		name="address" 
		required="true"
		type="string"
		hint="Address to call (ie: https://api.constantcontact.com/customers/{user-name}/)">
		
	<cfargument 
		name="requestValue"
		type="string"
		hint="XML for http request body">
	
	<cfset address=replace("#address#", "http://", "https://")>
	
	<cfhttp 
		url="#ARGUMENTS.address#" 
		method="#ARGUMENTS.type#" 
		username="#variables.ApiKey#%#variables.Username#" 
		password="#variables.Password#">
		
		<cfswitch expression="#ARGUMENTS.type#">
		<cfcase value="POST">
			<cfhttpparam type="header" name="Content-type" value="application/atom+xml" />
		    <cfhttpparam value="#ARGUMENTS.requestValue#" type="body" />
		</cfcase>
		<cfcase value="PUT">
			<cfhttpparam type="header" name="Content-type" value="application/atom+xml" />
		    <cfhttpparam value="#ARGUMENTS.requestValue#" type="body" />	
		</cfcase>
		<cfcase value="GET"></cfcase>
		<cfcase value="DELETE"></cfcase>
		</cfswitch>
	</cfhttp>
	
	<cfreturn cfhttp.filecontent> 
</cffunction>
	
<cffunction 
	name="searchContact" 
	access="public" 
	output="false" 
	hint="Check if a subscriber already exists. Returns subscriber id if found, else false.">
	
	<cfargument 
		name="emailAddress" 
		required="true" 
		type="string"
		hint="Contact's email address (ie: test_100@example.com)"
		/>
		
	<cfset LOCAL.contactXml = xmlParse(doServerCall("get", "#variables.apiPath#/contacts?email=#ARGUMENTS.emailAddress#"))>
		
	<cfif isdefined('LOCAL.contactXml.feed.entry')>
		<cfreturn LOCAL.contactXml.feed.entry.id.XmlText>
	<cfelse>
		<cfreturn false>
	</cfif>	
	
</cffunction>

<!--- Function: getContacts --->
<cffunction 
	name="getContacts" 
	access="public" 
	output="false" 
	hint="Retrieve all contacts thats exist">
		
	<cfargument
		name="page"
		type="string"
		default="#APPLICATION.apipath#/contacts">
			
	<cfset LOCAL.contactsXml = XmlParse(doServerCall("get", page))>
	
	<cfset LOCAL.contactsStruct = ArrayNew(1)>
	<cfset LOCAL.contactArray = ArrayNew(1)>
	
	<cfloop from="1" to="#ArrayLen(LOCAL.contactsXml.feed.entry)#" index="i">
		<cfset LOCAL.contact = StructNew()>
		<cfset LOCAL.contact.id = #LOCAL.contactsXml.feed.entry[i].id.XmlText#>
		<cfset LOCAL.contact.name = #LOCAL.contactsXml.feed.entry[i].Content.contact.Name.XmlText#>
		<cfset LOCAL.contact.emailaddress = #LOCAL.contactsXml.feed.entry[i].Content.contact.EmailAddress.XmlText#>
		<cfset LOCAL.contact.status = #LOCAL.contactsXml.feed.entry[i].Content.contact.Status.XmlText#>
		<cfset LOCAL.contact.updated = #LOCAL.contactsXml.feed.entry[i].Updated.XmlText#>
	
		<cfset LOCAL.temp = arrayAppend(LOCAL.contactArray, LOCAL.contact)>
	</cfloop>
	
	<cfset LOCAL.temp = ArrayAppend(LOCAL.contactsStruct, LOCAL.contactArray)>
	<cfset LOCAL.nextLinkSearch = xmlSearch (LOCAL.contactsXml, "//*[@rel='next']") >
	<cfif ArrayIsEmpty(LOCAL.nextLinkSearch)>
		<cfset LOCAL.nextAddress = "">
	<cfelse>
		<cfset LOCAL.nextAddress = "https://api.constantcontact.com#LOCAL.nextLinkSearch[1].XmlAttributes["href"]#" >
	</cfif>
		<cfset LOCAL.linkArray = ArrayNew(1)>
		<cfset LOCAL.linkArray[1] = LOCAL.nextAddress>

	<cfset LOCAL.temp = ArrayAppend (LOCAL.contactsStruct, LOCAL.linkArray)>
	
	<cfreturn LOCAL.contactsStruct>
</cffunction>

<!--- Function: getContactDetails --->
<cffunction 
	name="getContactDetails" 
	access="public" 
	output="false" 
	hint="Get details for a particular contact">
	
	<cfargument 
		name="contactId" 
		required="true" 
		type="string"
		hint="Full contact id URL">
		
	<cfset LOCAL.subscriberXml = XMLParse(doServerCall("get", ARGUMENTS.contactId))>

	<cfset LOCAL.subscriberDetails=StructNew()>
	<cfset LOCAL.subscriberDetails['id'] = #LOCAL.SubscriberXml.entry.id.XmlText#>
	<cfset LOCAL.subscriberDetails['status'] = #LOCAL.SubscriberXml.entry.content.Contact.Status.XmlText#>
	<cfset LOCAL.subscriberDetails['email'] = #LOCAL.SubscriberXml.entry.content.Contact.EmailAddress.XmlText#>
	<cfset LOCAL.subscriberDetails['firstName'] = #LOCAL.SubscriberXml.entry.content.Contact.FirstName.XmlText#>
	<cfset LOCAL.subscriberDetails['middleName'] = #LOCAL.SubscriberXml.entry.content.Contact.MiddleName.XmlText#>
	<cfset LOCAL.subscriberDetails['lastName'] = #LOCAL.SubscriberXml.entry.content.Contact.LastName.XmlText#>
	<cfset LOCAL.subscriberDetails['jobTitle'] = #LOCAL.SubscriberXml.entry.content.Contact.JobTitle.XmlText#>
	<cfset LOCAL.subscriberDetails['companyName'] = #LOCAL.SubscriberXml.entry.content.Contact.CompanyName.XmlText#>
	<cfset LOCAL.subscriberDetails['homePhone'] = #LOCAL.SubscriberXml.entry.content.Contact.HomePhone.XmlText#>
	<cfset LOCAL.subscriberDetails['workPhone'] = #LOCAL.SubscriberXml.entry.content.Contact.WorkPhone.XmlText#>
	<cfset LOCAL.subscriberDetails['addr1'] = #LOCAL.SubscriberXml.entry.content.Contact.Addr1.XmlText#>
	<cfset LOCAL.subscriberDetails['addr2'] = #LOCAL.SubscriberXml.entry.content.Contact.Addr2.XmlText#>
	<cfset LOCAL.subscriberDetails['addr3'] = #LOCAL.SubscriberXml.entry.content.Contact.Addr3.XmlText#>
	<cfset LOCAL.subscriberDetails['city'] = #LOCAL.SubscriberXml.entry.content.Contact.City.XmlText#>
	<cfset LOCAL.subscriberDetails['stateCode'] = #LOCAL.SubscriberXml.entry.content.Contact.StateCode.XmlText#>
	<cfset LOCAL.subscriberDetails['stateName'] = #LOCAL.SubscriberXml.entry.content.Contact.StateName.XmlText#>
	<cfset LOCAL.subscriberDetails['countryCode'] = #LOCAL.SubscriberXml.entry.content.Contact.CountryCode.XmlText#>
	<cfset LOCAL.subscriberDetails['postalCode'] = #LOCAL.SubscriberXml.entry.content.Contact.PostalCode.XmlText#>
	<cfset LOCAL.subscriberDetails['subPostalCode'] = #LOCAL.SubscriberXml.entry.content.Contact.SubPostalCode.XmlText#>
	<cfset LOCAL.subscriberDetails['customField1'] = #LOCAL.SubscriberXml.entry.content.Contact.CustomField1.XmlText#>
	<cfset LOCAL.subscriberDetails['customField2'] = #LOCAL.SubscriberXml.entry.content.Contact.CustomField2.XmlText#>
	<cfset LOCAL.subscriberDetails['customField3'] = #LOCAL.SubscriberXml.entry.content.Contact.CustomField3.XmlText#>
	<cfset LOCAL.subscriberDetails['customField4'] = #LOCAL.SubscriberXml.entry.content.Contact.CustomField4.XmlText#>
	<cfset LOCAL.subscriberDetails['customField5'] = #LOCAL.SubscriberXml.entry.content.Contact.CustomField5.XmlText#>
	<cfset LOCAL.subscriberDetails['customField6'] = #LOCAL.SubscriberXml.entry.content.Contact.CustomField6.XmlText#>
	<cfset LOCAL.subscriberDetails['customField7'] = #LOCAL.SubscriberXml.entry.content.Contact.CustomField7.XmlText#>
	<cfset LOCAL.subscriberDetails['customField8'] = #LOCAL.SubscriberXml.entry.content.Contact.CustomField8.XmlText#>
	<cfset LOCAL.subscriberDetails['customField9'] = #LOCAL.SubscriberXml.entry.content.Contact.CustomField9.XmlText#>
	<cfset LOCAL.subscriberDetails['customField10'] = #LOCAL.SubscriberXml.entry.content.Contact.CustomField10.XmlText#>
	<cfset LOCAL.subscriberDetails['customField11'] = #LOCAL.SubscriberXml.entry.content.Contact.CustomField11.XmlText#>
	<cfset LOCAL.subscriberDetails['customField12'] = #LOCAL.SubscriberXml.entry.content.Contact.CustomField12.XmlText#>
	<cfset LOCAL.subscriberDetails['customField13'] = #LOCAL.SubscriberXml.entry.content.Contact.CustomField13.XmlText#>
	<cfset LOCAL.subscriberDetails['customField14'] = #LOCAL.SubscriberXml.entry.content.Contact.CustomField14.XmlText#>
	<cfset LOCAL.subscriberDetails['customField15'] = #LOCAL.SubscriberXml.entry.content.Contact.CustomField15.XmlText#>
	<cfset LOCAL.subscriberDetails['Note'] = #LOCAL.SubscriberXml.entry.content.Contact.Note.XmlText#>
		
	<cfreturn LOCAL.subscriberDetails>
</cffunction>

<!--- Function: deleteContact --->
<cffunction 
	name="deleteContact" 
	access="public" 
	output="false" 
	hint="Modifies contact status to 'Do Not Mail' and should be used for contact opt-outs">
	
	<cfargument 
		name="contactId" 
		type="string" 
		required="true"
		hint="Full contact id URL">
		
	<cfset LOCAL.deleteResponse = doServerCall("delete", ARGUMENTS.contactId)>

	<cfreturn LOCAL.deleteResponse>
</cffunction>

<!--- Function: removeContact --->
<cffunction name="removeContact" 
	access="public" 
	output="false" 
	hint="Modifies contact's status to 'Removed' and unsubscribes them from all contact lists">
	
	<cfargument 
		name="contactId"
		type="string" 
		required="true"
		hint="Full contact id url">
		
	
	<!--- Get contact XML from Constant Contact --->
	<cfset LOCAL.contactDetails = xmlParse(doServerCall("get", ARGUMENTS.contactId))>	
	
	<!--- Clear <ContactLists> element--->
	<cfset ArrayClear(LOCAL.contactDetails.entry.content.Contact.ContactLists.XmlChildren) >
	
	<!--- Send modified XML to Constant Contact --->
	<cfset LOCAL.putResponse = doServerCall("put", ARGUMENTS.contactId, LOCAL.contactDetails)>
			
	<cfreturn LOCAL.putResponse>
</cffunction>

<!--- Function: addContact --->
<cffunction 
	name="addContact" 
	access="public" 
	output="false"
	hint="Creates a contact using XML passed through the contactXML argument">
	
	<cfargument 
		name="addXml" 
		required="true"
		type="xml">
	
	<cfset LOCAL.postResponse = doServerCall("post", "#variables.apiPath#/contacts", ARGUMENTS.addXml)>
			
	<cfreturn LOCAL.postResponse>
</cffunction>


<!--- Function: editContact --->
<cffunction name="editContact" 
	access="public" 
	output="false"
	hint="Updates a contact's details">
	
	<cfargument 
		name="editXml" 
		required="true"
		type="xml"
		/>
		
	<cfargument 
		name="contactId" 
		required="true"
		type="string"
		/>
	
	<cfset LOCAL.editResponse = doServerCall("put", ARGUMENTS.contactId, ARGUMENTS.editXml)>
		
	<cfreturn LOCAL.editResponse>
	
</cffunction>

<!--- Function: createContactXml --->
<cffunction 
	name="createContactXml" 
	access="public" 
	output="false" 
	returntype="xml"
	hint="Basic XML for contact creation">
	
<cfoutput>
<cfxml variable="newContact">
<entry xmlns="http://www.w3.org/2005/Atom">
	<title type="text"> </title>
	<updated>#dateformat(now(), "yyyy-mm-dd")#T#TimeFormat(now(), "HH:mm:ss:l")#Z</updated>
	<author></author>
    <id>data:,none</id>
	<summary type="text">Contact</summary>
	<content type="application/vnd.ctct+xml">
		<Contact xmlns="http://ws.constantcontact.com/ns/1.0/">
			<EmailAddress></EmailAddress>
			<EmailType></EmailType>
			<FirstName></FirstName>						
			<MiddleName></MiddleName>
			<LastName></LastName>
			<JobTitle></JobTitle>
			<CompanyName></CompanyName>
			<WorkPhone></WorkPhone>
			<HomePhone></HomePhone>
			<Addr1></Addr1>
			<Addr2></Addr2>
			<Addr3></Addr3>
			<City></City>
			<StateCode></StateCode>
			<StateName></StateName>
			<CountryCode></CountryCode>
			<PostalCode></PostalCode>
			<SubPostalCode></SubPostalCode>
			<Note></Note>
			<CustomField1></CustomField1>
			<CustomField2></CustomField2>
			<CustomField3></CustomField3>
			<CustomField4></CustomField4>
			<CustomField5></CustomField5>
			<CustomField6></CustomField6>
			<CustomField7></CustomField7>
			<CustomField8></CustomField8>
			<CustomField9></CustomField9>
			<CustomField10></CustomField10>
			<CustomField11></CustomField11>
			<CustomField12></CustomField12>
			<CustomField13></CustomField13>
			<CustomField14></CustomField14>
			<CustomField15></CustomField15>
			<Note></Note>
			<OptInSource>#variables.OptInSource#</OptInSource>
			<ContactLists></ContactLists>
		</Contact>
  </content>
</entry>
</cfxml>
</cfoutput>

	<cfreturn newContact>
</cffunction>
</cfcomponent>

 