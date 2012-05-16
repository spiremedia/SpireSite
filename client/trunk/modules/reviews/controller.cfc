<cfcomponent name="reviews controller" output="false" extends="resources.abstractController">
	
	<cffunction name="myReviews">
		<cfset var lcl = structnew()>
		<cfset lcl.s.sort = "created">
		<cfset lcl.uid = requestObject.getUserObject().getUserId()>
		<cfset variables.reviewsModel = createObject("component","modules.reviews.models.reviews").init(requestObject)>
		<cfset variables.reviews = variables.reviewsModel.getMyReviews(lcl.uid, 'created', 'DESC')>
		<cfreturn this>
	</cffunction>
	
	<!--- 
	<cffunction name="init">
		<cfargument name="data">
		<cfargument name="requestObject">
        <cfargument name="parameterlist" default="">
		<cfargument name="pageRef">

		<cfset variables.requestObject = arguments.requestObject>
		<cfset variables.pageref = arguments.pageRef>
		<cfset variables.data = arguments.data>		
		<cfset variables.vdtr = getUtility('datavalidator').init()> 
		<cfset variables.qryReviews = queryNew('dummy')>
		<cfset variables.mdl = this.getReviewsModel("reviews")>
		<cfset variables.moduleitemid = ''>
		<cfset variables.moduleitemtitle = ''>
		
		<!--- variables for sortby --->	
		<cfset variables.sortfield = 'created'>
		<cfset variables.qrysortdirection = 'desc'>		
		<cfif requestObject.isformurlvarset('sortfield')>
			<cfset variables.sortfield = requestObject.getformurlvar('sortfield')>
		</cfif>			
		<cfset variables.qrysortfield = variables.sortfield>
		<cfif variables.sortfield eq 'oldest'>
			<cfset variables.qrysortfield = 'created'>
			<cfset variables.qrysortdirection = 'asc'>	
		</cfif>	
		
		<!--- handle review submission form --->	
		<cfif variables.requestObject.isformurlvarset('moduleitemid')>
			<cfset processReviewForm()>
		</cfif>
		<cfreturn this>
	</cffunction>

	

	<cffunction name="processReviewForm">		
		<cfset var lcl = structNew()>	

		<!--- form validation --->
		<cfset variables.mdl.validate(vdtr)>		
		<cfif NOT variables.vdtr.passValidation()>
			<cfreturn>
		</cfif>
				
		<!--- Add reviews --->
		<cfset lcl.info = variables.requestObject.getAllFormUrlVars()>
		<cfset lcl.reviews = structNew()>			
		<cfset lcl.reviews.id = createuuid()>	
		<cfset lcl.reviews.modulename = lcl.info.modulename>	
		<cfset lcl.reviews.moduleitemid = lcl.info.moduleitemid>	
		<cfset lcl.reviews.rating = lcl.info.rating>	
		<cfset lcl.reviews.comments = lcl.info.comments>	
		<cfif requestObject.getVar('reviewApprovalRequired')>
			<cfset lcl.reviews.active = 0>	
		<cfelse>
			<cfset lcl.reviews.active = 1>	
		</cfif>		
		<cfif session.user.isloggedin()>
			<cfset lcl.reviews.reviewerid = session.user.getUserID()>	
			<cfset lcl.reviews.reviewerName = session.user.getFullName()>
		<cfelse>
			<!--- Semi-annoymous post --->
			<cfset lcl.reviews.reviewerName = lcl.info.reviewerName>
		</cfif>
		<cfset variables.mdl.addReview(reviews=lcl.reviews)>	

		<!--- send email --->
		<cfif requestObject.getVar('reviewSendEmail')>
			<cfset lcl.reviews.moduleitemtitle = lcl.info.moduleitemtitle>
			<cfset variables.mdl.sendReviewEmail(reviews=lcl.reviews)>
		</cfif>
		<cfreturn>
	</cffunction>
	
	<cffunction name="products" output="false">
		<cfparam name="variables.data.pageing" default="10">
		<cfif structkeyexists(variables.pageref, "addtoheader")>
			<cfset variables.pageref.addtoheader('<link rel="stylesheet" href="/ui/css/reviews.css" type="text/css"/>')>
		</cfif>
		<cfset variables.moduleitemid = variables.data.moduleInfo.id>
		<cfset variables.moduleitemtitle = variables.data.moduleInfo.title>
		<cfset variables.moduleaction = arguments.moduleaction>		
		<cfset variables.qryReviews = variables.mdl.getReviews(moduleitemid = variables.moduleitemid,sortfield=variables.qrysortfield,sortdirection=variables.qrysortdirection)>
		<!--- paging --->
		<cfset variables.pager = this.getUtility("pager").init(requestObject)>
       	<cfset variables.pager.setItemsPerPage(variables.data.pageing)>
		<Cfset lcl.urlparams = structNew()>
		<Cfset lcl.urlparams.sortfield = variables.sortfield>
       	<cfset variables.pager.seturlparams(lcl.urlparams)>		
		<cfset variables.reviewslist = variables.pager.chopQuery(variables.qryReviews)>
        <cfset variables.pager.setTitlePattern("Your search returned {recordsfound} results")>
		<cfset variables.pager.setNoRecordsTitlePattern("No records were found")>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getReviewSortBy" output="false">
		<cfset var lcl = structNew()>			
		<cfsavecontent variable="lcl.html">
			<cfinclude template="templates/reviews_sortby.cfm">
		</cfsavecontent>		
		<cfreturn lcl.html>
	</cffunction>
	
	<cffunction name="getReviewComments" output="false">
		<cfset var lcl = structNew()>	
		<cfsavecontent variable="lcl.html">
			<cfinclude template="templates/reviews_comments.cfm">
		</cfsavecontent>			
		<cfreturn lcl.html>
	</cffunction>
	
	<cffunction name="getReviewForm" output="false">
		<cfset var lcl = structNew()>	
		<cfsavecontent variable="lcl.html">
			<cfif variables.requestObject.isformurlvarset('moduleitemid') AND variables.vdtr.passValidation()>
				<cfinclude template="templates/reviews_formconfirmation.cfm">
			<cfelseif requestObject.getVar('reviewLoginRequired') AND NOT session.user.isloggedin()>
				<cfinclude template="templates/reviews_login.cfm">
			<cfelse>
				<cfinclude template="templates/reviews_form.cfm">
			</cfif>			
		</cfsavecontent>			
		<cfreturn lcl.html>
	</cffunction>
	
	<cffunction name="getCacheLength">
		<cfreturn 0>
	</cffunction>
	
	<cffunction name="dump" output="False">
		<cfdump var=#variables#>
	</cffunction> --->
</cfcomponent>