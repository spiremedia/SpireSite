<cfset lcl.user = requestObject.getUserObject()>
<cfif lcl.user.isLoggedIn()>
	<a id="myaccount" href="/user/">My Account</a>
	</li>
	<li>
	<a id="userlogoutlink" href="/user/logout/">Logout</a>
<cfelse>
	<a id="userloginlink" onclick="jQuery('.hiddenloginform').show();jQuery('#searchCriteriaSel').hide();return false;" href="/user/login/">My Applejack Sign-In</a>
	<div class="hiddenloginform">
		<form name="loginform" action="/forms2/users_loginform/" method="post">
			<input type="hidden" name="onfail" value="/user/login">
			<div class="col first">MY ACCOUNT:</div>
			<div class="col"><input id="huname" type="text" value="Username" name="username" size="12" style="width:130px;"></div>
			<div class="col"><input id="hpwd" type="password" value="password" name="password" size="12" style="width:130px;"></div>
			<div class="col last"><input type="image" src="/ui/images/buttons/headersignin.png" value="Sign In"></div>
			<br class="clear"/>
			<div class="headerloginfoot">
			<a href="/user/create">Create an Account</a>&nbsp;&nbsp;&nbsp;
			<a href="/user/forgot">Forgot your Password?</a>
			</div>
		</form>
	</div>
    <script>
		jQuery(function(){
			jQuery(".hiddenloginform #huname").click(function(){
				var t = this;
				if (t.value == "Username") t.value = '';
			});	
			jQuery(".hiddenloginform #hpwd").click(function(){
				var t = this;
				if (t.value == "password") t.value = '';
			});	
		});
	</script>
</cfif>

