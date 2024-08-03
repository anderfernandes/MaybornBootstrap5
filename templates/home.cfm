<cfoutput>
<!doctype html>
<html lang="en">
  <head>
    <cfinclude template="inc/html_head.cfm" />
  </head>
  <body>
    <cfinclude template="inc/navbar.cfm" />
    #$.dspBody(
      body=$.content('body'), 
      pageTitle='', 
      crumbList=false, 
      showMetaImage=false
    )#
    <cfinclude  template="inc/footer.cfm" />
    <cfinclude  template="inc/html_foot.cfm" />
  </body>
</html>
</cfoutput>