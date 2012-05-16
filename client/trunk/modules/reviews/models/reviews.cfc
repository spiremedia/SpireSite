<cfcomponent name="reviews" extends="resources.abstractmodel">

	<cffunction name="init">
		<cfargument name="requestObject" required="true">
		<cfset variables.requestObject = arguments.requestObject>
		<cfset startOrm("reviews")>
		<cfreturn this>
	</cffunction>

	<cffunction name="getReviews">
    	<cfargument name="moduleitemid" required="true">
    	<cfargument name="sortfield" default="created">
    	<cfargument name="sortdirection" default="desc">
	
		<cfset var lcl = structNew()>

		<cfif NOT listfindnocase("created,rating", arguments.sortfield)>
			<cfset sortfield = 'created'>
		</cfif>
		
		<cfif NOT listfindnocase("asc,desc", arguments.sortdirection)>
			<cfthrow message="invalid sort dir #arguments.sortdirection#"><cfabort>
		</cfif>
		
		<cfquery name="lcl.q" datasource="#requestObject.getVar('dsn')#" result="r">
			SELECT r.id, r.moduleitemid, r.siteid, r.created, r.modulename, r.moduleitemid, 
				r.rating, r.comments, r.reviewerid, r.reviewername
			FROM reviews r
			WHERE r.deleted = 0	
				AND moduleitemid = <cfqueryparam value="#arguments.moduleitemid#" cfsqltype="CF_SQL_VARCHAR">
				AND r.active = 1
				AND r.mode like 'product%'
				AND r.siteid = <cfqueryparam value="#requestObject.getVar('siteid')#" cfsqltype="CF_SQL_VARCHAR">
			ORDER BY [#arguments.sortfield#] #arguments.sortdirection#
		</cfquery>
		
		
		
		<cfreturn lcl.q>
	</cffunction>
	
	<cffunction name="getMyReviews">
    	<cfargument name="reviewerid" required="true">
    	<cfargument name="sortfield" default="created">
    	<cfargument name="sortdirection" default="desc">
	
		<cfset var lcl = structNew()>

		<cfif NOT listfindnocase("created,rating", arguments.sortfield)>
			<cfset sortfield = 'created'>
		</cfif>
		
		<cfif NOT listfindnocase("asc,desc", arguments.sortdirection)>
			<cfthrow message="invalid sort dir #arguments.sortdirection#"><cfabort>
		</cfif>
		
		<cfquery name="lcl.q" datasource="#requestObject.getVar('dsn')#" result="r">
			SELECT DISTINCT r.id, r.moduleitemid, r.siteid, r.created, r.modulename, r.moduleitemid, 
				r.rating, r.comments, r.reviewerid, r.reviewername, p.title, p.urlname, r.active, ti.safename pathfirst
			FROM reviews r
			INNER JOIN products p ON p.id = r.moduleitemid
			INNER JOIN taxonomyRelations tr ON tr.relationid = p.id
			INNER JOIN taxonomyItems ti ON ti.id = tr.taxonomyitemid AND taxonomyid = 'product_categories'
			WHERE r.deleted = 0	
				AND r.reviewerid = <cfqueryparam value="#arguments.reviewerid#" cfsqltype="CF_SQL_VARCHAR">
				AND r.mode like '%notes'
				AND r.siteid = <cfqueryparam value="#requestObject.getVar('siteid')#" cfsqltype="CF_SQL_VARCHAR">
			ORDER BY [#arguments.sortfield#] #arguments.sortdirection#
		</cfquery>
				
		<cfreturn lcl.q>
	</cffunction>
	
	<!--- <cffunction name="validate">
		<cfargument name="vdtr" required="true">
		<cfset var info = variables.requestObject.getAllFormUrlVars()>

        <cfset vdtr.notblank('comments', info.comments, 'Please enter a comment.')>
        <cfset vdtr.maxlength('comments', 1000, info.comments, 'The comment may not be longer than 1000 chars. It is currently #len(info.comments)#')>
        <cfset vdtr.notblank('rating', info.rating, 'Please select a rating.')>
		<cfif structKeyExists(info, 'title')>
			<cfset vdtr.lengthbetween('title', 1, 100, info.title, 'Title may not be longer than 255 chars')>
		</cfif>
		<cfif NOT session.user.isloggedin()>
			<cfif requestObject.getVar("reviewLoginRequired")>
				<cfset vdtr.addError('moduleitemid','Please log into your account before posting a review.')>
			<cfelse>
				<cfset vdtr.lengthbetween('reviewerName', 1, 100, info.reviewerName, 'Name is required and may not be longer than 100 chars')>
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="addReview">		
    	<cfargument name="reviews" required="yes" type="struct">
		
		<cfparam name="arguments.reviews.active" default="0" type="boolean">	
		<cfparam name="arguments.reviews.modulename" default="" type="string">	
		<cfparam name="arguments.reviews.moduleitemid" default="" type="string">	
		<cfparam name="arguments.reviews.reviewerid" default="" type="string">	
		<cfparam name="arguments.reviews.reviewername" default="" type="string">	
		<cfparam name="arguments.reviews.rating" default="0" type="numeric">	
		<cfparam name="arguments.reviews.title" default="" type="string">	
		<cfparam name="arguments.reviews.comments" default="" type="string">	
		
		<cfquery datasource="#requestObject.getVar('dsn')#" result="r">
			INSERT INTO reviews ( [id],[siteid],[active],[modulename],[moduleitemid],[reviewerid],[reviewername],[rating],[title],[comments] )
			VALUES (
				<cfqueryparam value="#arguments.reviews.id#" cfsqltype="CF_SQL_VARCHAR">,
				<cfqueryparam value="#requestObject.getVar('siteid')#" cfsqltype="CF_SQL_VARCHAR">,
				<cfqueryparam value="#arguments.reviews.active#" cfsqltype="cf_sql_bit">,
				<cfqueryparam value="#arguments.reviews.modulename#" cfsqltype="CF_SQL_VARCHAR">,
				<cfqueryparam value="#arguments.reviews.moduleitemid#" cfsqltype="CF_SQL_VARCHAR">,
				<cfqueryparam value="#arguments.reviews.reviewerid#" cfsqltype="CF_SQL_VARCHAR">,
				<cfqueryparam value="#arguments.reviews.reviewername#" cfsqltype="CF_SQL_VARCHAR">,
				<cfqueryparam value="#arguments.reviews.rating#" cfsqltype="cf_sql_integer">,
				<cfqueryparam value="#arguments.reviews.title#" cfsqltype="CF_SQL_VARCHAR">,
				<cfqueryparam value="#arguments.reviews.comments#" cfsqltype="cf_sql_longvarchar">
			)  
		</cfquery>

		<cfreturn>
	</cffunction> --->
	<!--- 
	<cffunction name="sendReviewEmail">	
    	<cfargument name="reviews" required="yes" type="struct">
		<cfset var lcl = structNew()>
		<cfparam name="reviews.moduleitemtitle" default="" >

		<cfscript> 
			lcl.body = '';
			lcl.email = createObject('component', 'resources.email').init(requestObject = variables.requestObject);
			lcl.recipient = variables.requestObject.getVar('reviewEmailTo');
			
			// Mail the form if the recipient attribte is present
			if ( lcl.recipient neq '' )
			{
				lcl.body = lcl.body & 'Review Submission Date: <br />' & DateFormat(now(), 'mmm d, yyyy ') & timeformat(now(), 'h:mm tt') & '<br /><br />';
				lcl.body = lcl.body & 'Reviewer Name: <br />' & reviews.reviewerName & '<br /><br />';
				lcl.body = lcl.body & 'Item: <br />' & reviews.moduleitemtitle & '<br /><br />';
				lcl.body = lcl.body & 'Reviewer Rating: <br />' & reviews.rating & ' Star#iif((reviews.rating eq 1),DE(''),DE('s'))#<br /><br />';
				lcl.body = lcl.body & 'Reviewer Comment: <br />' & reviews.comments & '<br /><br />';
				// set email parameters and send mail
				lcl.email.setRecipient(recipient = lcl.recipient);
				lcl.email.setSubject(subject = variables.requestObject.getVar('siteurl') & ': New Review Submission');
				lcl.email.setbody(body = lcl.body);
				lcl.email.setSender(sender = variables.requestObject.getVar('systememailfrom'));
				lcl.email.setMailServer(mailserver = variables.requestObject.getVar('mailsmtp'));
				lcl.email.sendMessage();
			}
		</cfscript>		

		<cfreturn>
	</cffunction>
	 --->
	
</cfcomponent>
