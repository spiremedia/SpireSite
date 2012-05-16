<cfsavecontent variable="modulexml">
<moduleInfo>
	<postProcess replaceString="[postprocess-usershtml]" action="headerloginform"/>
	<postProcess replaceString="[postprocess-userflash]" action="userflash"/>
   	<action match="^user/Login/?$">
        <loadcfc>userLogin</loadcfc>
        <template>interior2column</template>
        <title>Login to your Account</title>
        <description>User Login</description>
		<pagename>User Login</pagename>
        <keywords>User Login</keywords>
		<breadcrumbs>Home~NULL~|User Login</breadcrumbs>
    </action>
	
	<action match="^user/create/?$">
        <loadcfc>userCreate</loadcfc>
        <template>interior2column</template>
        <title>Create an Account</title>
        <description>Create an Account</description>
		<pagename>Create your Account!</pagename>
        <keywords>User Login</keywords>
		<breadcrumbs>Home~NULL~|User Create</breadcrumbs>
    </action>
	
	<action match="^user/edit/?$">
        <loadcfc>userUpdate</loadcfc>
        <template>interior2column</template>
        <title>Update Your Account</title>
        <description>Update your account</description>
		<pagename>Update Your Account!</pagename>
        <keywords>Update Your Account</keywords>
		<breadcrumbs>Home~NULL~|User Update</breadcrumbs>
    </action>
	
	<action match="^user/editpassword/?$">
        <loadcfc>userUpdatePassword</loadcfc>
        <template>interior2column</template>
        <title>Change your Password</title>
        <description>Update your account</description>
		<pagename>Change Your Password!</pagename>
        <keywords>Update Your Account</keywords>
		<breadcrumbs>Home~NULL~|User Update</breadcrumbs>
    </action>
	
	<action match="^user/logout/?$">
        <loadcfc>userLogout</loadcfc>
        <template>interior2column</template>
        <title>User Logout</title>
        <description>You are now logged out.</description>
		<pagename>You are now logged out</pagename>
        <keywords>User Login</keywords>
		<breadcrumbs>Home~NULL~|Logout</breadcrumbs>
    </action>
	
	<action match="^user/?$">
        <loadcfc>user</loadcfc>
        <template>interior2column</template>
        <title>My Applejack Account</title>
        <description>HUMBUGGER</description>
		<pagename>My Applejack Account</pagename>
        <keywords>My Applejack Account</keywords>
		<breadcrumbs>Home~NULL~| My Applejack</breadcrumbs>
    </action>
	
	<action match="^user/forgot/?$">
        <loadcfc>userForgot</loadcfc>
        <template>interior2column</template>
        <title>Forgot Password</title>
        <description></description>
		<pagename>Email me my login info!</pagename>
        <keywords>Forgot password</keywords>
		<breadcrumbs>Home~NULL~|Email me my info</breadcrumbs>
    </action>
	
</moduleInfo>
</cfsavecontent>

<cfset modulexml = xmlparse(modulexml)>