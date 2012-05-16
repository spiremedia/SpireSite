<cfcomponent name="datavalidator">
	<cfset variables.default_messages = structnew()>
	<cffunction name="init">
		<cfset variables.errors = arraynew(1)>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="addError">
		<cfargument name="field">
		<cfargument name="text">
		<cfset var item = structnew()>
		<cfset var lcl = structnew()>
		
		<cfif not structkeyexists(variables, "errors")>
			<cfthrow message="Please call the init function of validator before using it.">
		</cfif>
		
		<cfloop array="#variables.errors#" index="lcl.idx">
			<cfif lcl.idx.field EQ arguments.field AND lcl.idx.text EQ arguments.text>
				<cfreturn>
			</cfif>
		</cfloop>
		
		<cfset item.field = arguments.field>
		<cfset item.text = arguments.text>

		<cfset arrayappend(variables.errors, item)>
	</cffunction>
	
	<cffunction name="fieldHasError">
		<cfargument name="field">
		<cfloop from="1" to="#arraylen(variables.errors)#" index="i">
			<cfif variables.errors[i].field EQ arguments.field>
				<cfreturn 1>
			</cfif>
		</cfloop>
		<cfreturn 0>
	</cffunction>
	
	<cffunction name="getErrors">
		<cfreturn variables.errors>
	</cffunction>
	
	<cffunction name="getErrorStruct">
		<cfset var es = structnew()>
		<cfset var i = "">
		<cfloop from="1" to="#arraylen(variables.errors)#" index="i">
			<cfset es[variables.errors[i].field] = variables.errors[i].text>
		</cfloop>
		<cfreturn es>
	</cffunction>
	
	<cffunction name="getErrorlist">
		<cfset var str = "">
		<cfif arraylen(variables.errors)>
			<cfloop from="1" to="#arraylen(variables.errors)#" index="i">
				<cfset str = str & "," & variables.errors[i].field>
			</cfloop>	
		</cfif>
		<cfreturn str>
	</cffunction>
	
	<cffunction name="passvalidation">
		<cfreturn NOT arraylen(variables.errors)>
	</cffunction>
	
	<cffunction name="getFormattedErrors">
		<cfargument name="ulclass" default="errors">
		<cfset var errorstring = "">
		<cfif arraylen(variables.errors)>
			<cfsavecontent variable="errorstring">
				<cfoutput>
				<ul class="#arguments.ulclass#">
					<cfloop from="1" to="#arraylen(variables.errors)#" index="i">
						<li>#variables.errors[i].text#</li>
					</cfloop>
				</ul>
				</cfoutput>
			</cfsavecontent>
			<cfreturn errorstring>
		</cfif>
		<cfreturn "">
	</cffunction>
	
	<cfset default_messages['validemail'] = " must be a valid email	.">
	
	<cffunction name="validemail">
		<cfargument name="field">
		<cfargument name="val">
		<cfargument name="text">

		<cfif NOT refindnocase("^[\w-]+(\.[\w-]+)*@([a-z0-9-]+(\.[a-z0-9-]+)*?\.[a-z]{2,6}|(\d{1,3}\.){3}\d{1,3})(:\d{4})?$", arguments.val)>
			<cfset addError(arguments.field, arguments.text)>
		</cfif>
	</cffunction>
	
	<cfset default_messages['notblank'] = " may not be blank.">
	
	<cffunction name="notblank">
		<cfargument name="field">
		<cfargument name="val">
		<cfargument name="text">

		<cfif trim(arguments.val) EQ "">
			<cfset addError(arguments.field, arguments.text)>
		</cfif>
	</cffunction>
	
	<cfset default_messages['isinteger'] = " must be an integer.">
	
	<cffunction name="isinteger">
		<cfargument name="field" required="true">
		<cfargument name="val" required="true">
		<cfargument name="text">
		
		<cfif NOT structkeyexists(arguments,"text")>
			<cfset arguments.text = field & "must be an integer.">
		</cfif>
		
		<cfif refindnocase("[^0-9]", arguments.val)>
			<cfset addError(arguments.field, arguments.text)>
		</cfif>
	</cffunction>
	
	<cfset default_messages['isvalidpassword'] = " must be avalid password.">
	
	<cffunction name="isvalidpassword">
		<cfargument name="field">
		<cfargument name="val">
		<cfargument name="text">
		<cfif NOT refindnocase("^[0-9a-zA-Z\!\@\##\$\%\^\&\*\-]{5,15}$", arguments.val)>
			<cfset addError(arguments.field, arguments.text)>
		</cfif>
	</cffunction>
	
	<cfset default_messages['regexmatchtest'] = " is not valid.">
	
	<cffunction name="regexmatchtest">
		<cfargument name="field">
		<cfargument name="regex">
		<cfargument name="val">
		<cfargument name="text">
		<cfif refindnocase(arguments.regex, arguments.val)>
			<cfset addError(arguments.field, arguments.text)>
		</cfif>
	</cffunction>
	
	<cfset default_messages['regexnomatchtest'] = " is not valid.">
	
	<cffunction name="regexnomatchtest">
		<cfargument name="field">
		<cfargument name="regex">
		<cfargument name="val">
		<cfargument name="text">
		<cfif NOT refindnocase(arguments.regex, arguments.val)>
			<cfset addError(arguments.field, arguments.text)>
		</cfif>
	</cffunction>
	
	<cfset default_messages['isnumber'] = " is a number.">
	
	<cffunction name="isnumber">
		<cfargument name="field">
		<cfargument name="val">
		<cfargument name="text">
		<cfif val(arguments.val) NEQ trim( arguments.val )>
			<cfset addError(arguments.field, arguments.text)>
		</cfif>
	</cffunction>
	
	<cfset default_messages['lengthbetween'] = " invalid length.">
	
	<cffunction name="lengthbetween">
		<cfargument name="field">
		<cfargument name="len1">
		<cfargument name="len2">
		<cfargument name="val">
		<cfargument name="text">

		<cfif len(arguments.val) LT len1 OR len(arguments.val) GT len2>
			<cfset addError(arguments.field, arguments.text)>
		</cfif>
	</cffunction>
	
	<cfset default_messages['maxlength'] = " is too long.">
	
	<cffunction name="maxlength">
		<cfargument name="field">
		<cfargument name="len">
		<cfargument name="val">
		<cfargument name="text">

		<cfif  len(arguments.val) GT len>
			<cfset arguments.text = arguments.text & ' (currently #len(arguments.val)#)'>
			<cfset addError(arguments.field, arguments.text)>
		</cfif>
	</cffunction>
	
	<cffunction name="iszip">
		<cfargument name="field">
		<cfargument name="len">
		<cfargument name="val">
		<cfargument name="text">

		<cfif NOT refindnocase("^[0-9]{5}(\-[0-9]{5})?$", arguments.val)>
			<cfset addError(arguments.field, arguments.text)>
		</cfif>
	</cffunction>
	
	<cfset default_messages['alphanumeric'] = " is not alphanumeric.">
	
	<cffunction name="alphanumeric">
		<cfargument name="field">
		<cfargument name="val">
		<cfargument name="text">
		<cfif refindnocase("[^A-Za-z0-9]", arguments.val)>
			<cfset addError(arguments.field, arguments.text)>
		</cfif>
	</cffunction>
	
	<cfset default_messages['sameas'] = " is not the same as ">
	
	<cffunction name="sameas">
		<cfargument name="field">
		<cfargument name="val">
		<cfargument name="val1">
		<cfargument name="text">
		<cfif arguments.val NEQ arguments.val1>
			<cfset addError(arguments.field, arguments.text)>
		</cfif>
	</cffunction>
	
	<cfset default_messages['islink'] = " is not a valid link.">
	
	<cffunction name="islink">
		<cfargument name="field">
		<cfargument name="val">
		<cfargument name="text">
		
		<cfset var re = "^(http|ftp|https):\/\/([[:alnum:]\-_]+\.)+[a-zA-Z]{2,4}[\/]?[\?]?(\??[a-zA-Z0-9\,\-\_=\.\%&\?*@!^\/]+?)?$">
		
		<cfset regexnomatchtest(arguments.field,
								re,
									arguments.val, 
										arguments.text)>
	</cffunction>
	
	<cfset default_messages['isvaliddate'] = " is not a valid date.">
	
	<cffunction name="isvaliddate">
		<cfargument name="field">
		<cfargument name="val">
		<cfargument name="text">
		
		<cfif NOT lsisdate(arguments.val)>
			<cfset addError(arguments.field, arguments.text)>
			<cfreturn>
		</cfif>
		
		<cftry>
			<cfset createOdbcdate(arguments.val)>
			<cfcatch>
				<cfset addError(arguments.field, arguments.text)>
				<cfreturn>
			</cfcatch>
		</cftry>
		
		<cfif not refind("[0-1][0-9]/[0-3][0-9]/[1-2][0-9][0-9][0-9]", arguments.val)>
			<cfset addError(arguments.field, arguments.text)>
			<cfreturn>
		</cfif>
			
	</cffunction>

	<cfset default_messages['isvalidcreditcard'] = " is not valid.">

	<cffunction name="isvalidcreditcard">
		<cfargument name="field">
		<cfargument name="strCardNumber">
		<cfargument name="strCardType">
		<cfargument name="text">
		<cfscript>
			var rv = "";
			var str = "";
			var chk = 0;
			var ccln = 0;
			var strln = 0;
			var i = 1;
			var arrCCTestNumbers = arraynew(1);
			
			arrCCTestNumbers[1] = "370000000000002,AMEX";
			arrCCTestNumbers[2] = "6011000000000012,DISCOVER";
			arrCCTestNumbers[3] = "5424000000000015,MASTERCARD";
			arrCCTestNumbers[4] = "4007000000027,VISA";

			for (i=1; i lte arraylen(arrCCTestNumbers); i=i+1) {
				if (listfirst(arrCCTestNumbers[i],",") eq arguments.strCardNumber) {
					if(arrayLen(Arguments) lt 2) {
						return;
					} else {
						if (listlast(arrCCTestNumbers[i],",") eq arguments.strCardType) {
							return;	
						} else {
							addError(arguments.field, arguments.text);
							return;
						}			
					}	
				}		
			}	
			
			if(reFind("[^[:digit:]]",arguments.strCardNumber)) return FALSE;
		        arguments.strCardNumber = replace(arguments.strCardNumber," ","","ALL");
			rv = Reverse(arguments.strCardNumber);
			ccln = Len(arguments.strCardNumber);
			if(ccln lt 12){
				addError(arguments.field, arguments.text);
				return;
			}
			for(i = 1; i lte ccln;  i = i + 1) {
				if(i mod 2 eq 0) {
					str = str & Mid(rv, i, 1) * 2;
				} else {
					str = str & Mid(rv, i, 1);
				}
			}
			strln = Len(str);
			for(i = 1; i lte strln; i = i + 1) chk = chk + Mid(str, i, 1);
			if((chk neq 0) and (chk mod 10 eq 0)) {
				if(ArrayLen(Arguments) lt 2) return TRUE;
				switch(UCase(Arguments[2])) {
				case "AMEX":		if ((ccln eq 15) and (((Left(arguments.strCardNumber, 2) is "34")) or ((Left(arguments.strCardNumber, 2) is "37")))) return TRUE; break;
				case "DINERS":		if ((ccln eq 14) and (((Left(arguments.strCardNumber, 3) gte 300) and (Left(arguments.strCardNumber, 3) lte 305)) or (Left(arguments.strCardNumber, 2) is "36") or (Left(arguments.strCardNumber, 2) is "38"))) return TRUE; break;
				case "DISCOVER":	if ((ccln eq 16) and (Left(arguments.strCardNumber, 4) is "6011")) return TRUE; break;
				case "MASTERCARD":	if ((ccln eq 16) and (Left(arguments.strCardNumber, 2) gte 51) and (Left(arguments.strCardNumber, 2) lte 55)) return TRUE; break;
				case "VISA":		if (((ccln eq 13) or (ccln eq 16)) and (Left(arguments.strCardNumber, 1) is "4")) return TRUE; break;
				default: return;
				}
			}
			addError(arguments.field, arguments.text);
		</cfscript>
	</cffunction>
	
	<cffunction name="getDefaultMessage">
		<cfargument name="fn">
		<cfif structkeyexists(variables.default_messages, fn)>
			<cfreturn variables.default_messages[fn]>
		</cfif>
		<cfreturn " not valid.">
	</cffunction>
	
	<cfset default_messages['isvalidcurrency'] = " must be in a valid currency format. Please no commas or dollar signs.">
	
	<cffunction name="isvalidcurrency">
		<cfargument name="field">
		<cfargument name="val">
		<cfargument name="text">

		<cfif len(arguments.val) AND not refind("^\d+(\.\d\d(\d\d)?)?$", arguments.val)>
			<cfset addError(arguments.field, arguments.text)>
		</cfif>
	</cffunction>
	
	<cffunction name="merge">
		<cfargument name="vdtr">
		
		<cfset var items = vdtr.getErrorStruct()>
		<cfset var item = "">
		
		<cfloop collection="#items#" item="item">
			<cfset adderror(item, items[item])>
		</cfloop>
	</cffunction>
	
	<cffunction name="dump">
		 <cfdump var=#variables.errors#>
		 <cfabort>
	</cffunction>
</cfcomponent>