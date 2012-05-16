<cfoutput>
<div class="newsDetail">
    <p>
        <cfif StructKeyExists(variables.data,"newsinfo")>
			#rereplacenocase(variables.data.newsinfo.itemhtml, "^(<p>)?", "<b>" & getUtility('string').APDateFormat(variables.data.newsinfo.itemdate) & "</b>: ")#
			<br class="clear" />
			<p style="margin-top:30px;">
				<a href="javascript:history.go(-1);">&laquo; Back</a>
			</p>
        <cfelse>
           There are currently no items to show.
        </cfif>
    </p>
</div>
</cfoutput>