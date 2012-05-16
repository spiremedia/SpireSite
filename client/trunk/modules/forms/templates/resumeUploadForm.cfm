       		<div class="si-message">           
				<cfoutput>#createUUID()#</cfoutput>
				<cfform name="myUpload"  action="" method="post" accept-charset="utf-8" class="example_form" enctype="multipart/form-data"> 
                <!--- <form> --->
                	<cfinput type="hidden" name="formid" value="9505301D-F464-7712-F32AB0AD9A0A2A84"/>
					
					
					<div class="simBox">
                    	<div class="simLeft">			
							<label for="field_1">First Name</label>
							<cfinput type="hidden" name="field_label_1" value="Contact First Name"/>
		                    <cfinput name="field_1" type="text" id="field_1" tabindex="1"/>
		                    
							<label for="field_2">Last Name</label>
							<cfinput type="hidden" name="field_label_2" value="Contact Last Name"/>
		                    <cfinput name="field_2" type="text" id="field_2" tabindex="2"/>
		                    
							<label for="field_3">Email</label>
							<cfinput type="hidden" name="field_label_3" value="Contact Email"/>
		                    <cfinput name="field_3" type="text" id="field_3" tabindex="3"/>
		                    
		                    <label for="field_4">Phone</label>
							<cfinput type="hidden" name="field_label_4" value="Contact Phone"/>
		                    <cfinput name="field_4" type="text" id="field_4" tabindex="4"/>
		                        
		                    <label for="field_5">Portfolio URL</label>
							<cfinput type="hidden" name="field_label_5" value="Portfolio URL"/>
		                    <cfinput name="field_5" type="text" id="field_5" tabindex="5"/>
		                    
		                    <label for="field_6">Which position are you applying for?</label>
							<cfinput type="hidden" name="field_label_6" value="Desired Position"/>
		                    <cfinput name="field_6" type="text" id="field_6" tabindex="6"/>
		                    
		                    <label for="field_7">Upload your resume:  (Supported formats: .doc, .docx, .pdf, .txt, .rtf)</label>
							<cfinput type="hidden" name="field_label_7" value="Resume"/>
		                    <cfinput name="field_7" type="text" id="field_7" tabindex="7"/>
		                    <cfinput type="file" name="fileData">
		                   <!---  <cfif isdefined("form.fileData")> 
							      <cfscript>  
							            hello = FileUpload("<path>","<mime type>","unique"); 
							      </cfscript> 
							      <cfdump var="#hello#"> 
							<cfelse> 
							      <cfform name="myUpload" enctype="multipart/form-data"> 
							            <cfinput type="file" name="fileData"><br> 
							            <cfinput type="submit" name="submit"> 
							      </cfform> 
							</cfif> --->
							<cffileupload  
							    url="uploadFiles.cfm" 
							    progressbar="true" 
							    name="myupload" 
							    addButtonLabel = "Add File" 
							    clearButtonlabel = "Clear it" 
							    hideUploadButton = "true" 
							    width=600 
							    height=400 
							    title = "File Upload" 
							    maxuploadsize="30" 
							    extensionfilter="*.jpg, *.png, *.flv, *.txt, *.doc, *.docx" 
							    BGCOLOR="##FFFFFF" 
							    MAXFILESELECT=10 
							    UPLOADBUTTONLABEL="Upload now"/><!---  --->
		                    
		               	</div>
		               	<div class="simRight">
		               		<label for="field_9">What type of work do you do?</label>
							<cfinput type="hidden" name="field_label_9" value="Resume"/>
		                    <cftextarea name="field_9" type="textarea" id="field_9" tabindex="9"></cftextarea>
		                    
		                    <label for="field_10">How can you add value to our team?</label>
							<cfinput type="hidden" name="field_label_10" value="Resume"/>
		                    <cftextarea name="field_10" type="textarea" id="field_10" tabindex="10"></cftextarea>
		               	</div>
		               	 <div class="clearfloat"></div>
		            </div>
		             <div class="clearfloat"></div>
		                    <div class="submit0"><input type="image" value="submit" src="/ui/images/btn_sisubmit.png" tabindex="2"/></div>                   
                </cfform>                   
            </div>
