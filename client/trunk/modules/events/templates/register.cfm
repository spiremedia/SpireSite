<cfparam name="variables.data.vdtr" default="#getUtility('datavalidator').init()#">

<cfset registerform = getUtility('formbuilder').init(variables.requestObject,"eventForm",'Post',variables.data.vdtr)>

<cfset registerform.addFormItem('email', 'Email*', 'text')>
<cfset registerform.addFormItem('fname', 'First Name*', 'text')>
<cfset registerform.addFormItem('lname', 'Last Name*', 'text')>
<cfset registerform.addFormItem('companyname', 'Company Name*', 'text')>
<cfset registerform.addFormItem('title', 'Title', 'text')>
<cfset registerform.addFormItem('add1', 'Street Address', 'text')>
<cfset registerform.addFormItem('add2', '&nbsp;', 'text')>
<cfset registerform.addFormItem('city', 'City', 'text')>
<cfset options = structnew()>
<cfset options.query = getUtility('worldinfo').init(variables.requestObject).getStates()>
<cfset options.labelskey = 'abbrev'>
<cfset options.valueskey = 'name'>
<cfset options.blankitem = 'Choose'>
<cfset registerform.addFormItem('state', 'State', 'select', "", options)>
<cfset registerform.addFormItem('zip', 'Zip', 'text')>
<cfset registerform.addFormItem('phone', 'Telephone*', 'text')>
<cfif variables.data.eventInfo.showaddtlattendees EQ 1>
	<cfset options = structnew()>
	<cfset options.list = '0,1,2,3,4,5,6,7,8,9'>
	<cfset registerform.addFormItem('addtlattendeescount', 'Additional Attendees', 'select', "", options)>
	<cfset registerform.addFormItem('addtlattendeesinfo', 'Additional Attendees Name(s) and Email(s)', 'textarea')>
</cfif>
<cfset options = structnew()>
<cfset options.query = querynew('value,label')>
<cfset queryaddrow(options.query)>
<cfset querysetcell(options.query, 'value', '1')>
<cfset querysetcell(options.query, 'label', '')>
<cfif variables.data.eventInfo.showmaterialsform EQ 1>
	<cfset registerform.addFormItem('materials', 'Materials Only', 'checkbox', "", options)>
</cfif>
<cfset registerform.addFormItem('comment', 'Comment', 'textarea')>
<!--- <cfset registerform.addSubmit('submit','', 'Submit')> --->
<cfset registerform.add('<input type="image" id="submit" style="border:0;" src="/ui/images/submitBtn.png" name="submit" value="SUBMIT" >')>
		
<cfoutput>
	<div id="registrationForm" style="<cfif variables.data.vdtr.passValidation()>display:none;</cfif>">
    
		Please R.S.V.P. by completing the form below.  You will receive a confirmation of your reservation after hitting "submit."<br /><br />
		#registerform.showHTML()#
	</div>
</cfoutput>