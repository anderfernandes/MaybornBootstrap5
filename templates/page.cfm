<cfoutput>
<!doctype html>
<html lang="en">
  <head>
    <cfinclude template="inc/html_head.cfm" />
  </head>
  <body>
    <cfinclude template="inc/navbar.cfm" />

    <div class="container my-5">
      <cfset pageTitle = $.content('type') neq 'Page' ?  : ''>
      
      <h1>#$.content('title')#</h1>
      
      #$.dspBody(body=$.content('body')
        , pageTitle=''
        , crumbList=false
        , showMetaImage=false
      )#
      
      #$.dspObjects(2)#
    </div>

    <cfinclude  template="inc/footer.cfm" />
    <cfinclude  template="inc/html_foot.cfm" />
  </body>
</html>
</cfoutput>