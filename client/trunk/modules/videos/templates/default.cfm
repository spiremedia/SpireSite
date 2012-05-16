<div id="videos">
	<div class="videoplayertop"></div>
	<div class="videoplayercontent">
        <table style="background-image:url('/ui/images/poleft.png');width:612px;" border=0>
        	<tr>
            	<td style="width:295px;">
                    <div id="videoplayer">
                        <div id="player">
                            <a href="http://get.adobe.com/flashplayer/" target="_blank">
                            	<img src="/ui/images/videos/FlashPlayer.gif" alt="Get Flash Player" />
                             </a>
                        </div>
                        <div id="currenttitle">
            
                        </div>
                        <div id="currentdescription">

                        </div>
                    </div>
                </td>
                <td>
                    <div id="videolistwrap">
                        <div id="videolist">
                            <cfoutput query="variables.videolist">
                                <table class="video bclear" width="235px" style="table-layout: fixed;"  ref="/docs/videos/#id#/#videofilename#">
                                    <tr>
                                        <td style="width:100px;">
                                        	<img src="/docs/videos/#id#/#thmbfilename#" border=0 alt="#HTMLEditFormat(title)#" ref="/docs/videos/#id#/#videofilename#"/>
                                        </td>
                                        <td style="width:135px;">
                                            <div class="vid_titlearea">
                                                <h4>#title#</h4>
                                                <cfif vidlength NEQ "">
                                                	<p><strong>Duration : #vidlength#</strong></p>
                                                </cfif>
                                        	</div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan=2 width="215px">
                                            <p class="videodescription">
                                                #description#
                                            </p>
                                        	<img src="/ui/images/videos/dotted_seperator.png"/>
                                        </td>
                                	</tr>
                                </table>
                            </cfoutput>
                        </div>
                    </div>
        		</td>
        	</tr>
        </table>
        <div id="vidcontrols">
            <a class="videobutton"><span style="padding-right:3px">&laquo; PREVIOUS VIDEO&nbsp;</span></a>
            <a class="videobutton"><span style="padding-right:10px">NEXT VIDEO &raquo;&nbsp;&nbsp;</span></a>
        </div>
	</div>
	<div class="videoplayerbot"></div>
</div>

<script type="text/javascript">
	jQuery.noConflict();
	jQuery(function(){
		jQuery("#videos").videos();
	});

	var flashvars = {video: "/docs/videos/<cfoutput>#variables.videolist.id[1]#/#variables.videolist.videofilename[1]#</cfoutput>"};
	var params = {allowScriptAccess: "sameDomain", autoplay: "false"};
	var attributes = {};
	attributes.id = "player2";
	swfobject.embedSWF("/ui/swf/player.swf", "player", "320", "277", "9.0.0", "/ui/swf/expressInstall.swf", flashvars, params, attributes);
</script> 












