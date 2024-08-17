<cfinclude template="inc/globals.cfm" />
<cfscript>
  EVENT_INDEX = 0;
  req = new http(method = "POST", charset = "UTF-8", url = API_URL & "/public/createReservation", accept = "application/json");
  req.addParam(name = "address", type = "formfield", value = structKeyExists(form, "address") ? form.address : "");
  req.addParam(name = "cell", type = "formfield", value = structKeyExists(form, "cell") ? form.cell : "");
  req.addParam(name = "city", type = "formfield", value = structKeyExists(form, "city") ? form.city : "");
  req.addParam(name = "firstname", type = "formfield", value = form.firstname);
  req.addParam(name = "lastname", type = "formfield", value = form.lastname);
  req.addParam(name = "email", type = "formfield", value = form.email);
  req.addParam(name = "memo", type = "formfield", value = form.memo);
  req.addParam(name = "parents", type = "formfield", value = form.parents);
  req.addParam(name = "phone", type = "formfield", value = structKeyExists(form, "phone") ? form.phone : "");
  req.addParam(name = "postShow", type = "formfield", value = form.postshow);
  req.addParam(name = "school", type = "formfield", value = form.school);
  req.addParam(name = "schoolId", type = "formfield", value = form.schoolId);
  req.addParam(name = "special_needs", type = "formfield", value = 0);
  req.addParam(name = "state", type = "formfield", value = "Texas");
  req.addParam(name = "students", type = "formfield", value = form.students);
  req.addParam(name = "taxable", type = "formfield", value = 1);
  req.addParam(name = "teachers", type = "formfield", value = form.teachers);
  req.addParam(name = "zip", type = "formfield", value = form.zip);
  arrayEach(listToArray(form.show_id), function (id, i) {
    d = listToArray(form.eventdate)[i]
    if (id != "0") {
      req.addParam(name = "events[" & EVENT_INDEX & "][show_id]", type = "formfield", value = id)
      req.addParam(name = "events[" & EVENT_INDEX & "][date]", type = "formfield", value = d)
      EVENT_INDEX++;
    }
  });
  res = req.send();
</cfscript>
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

      <cfif res.getPrefix().status_code GT 299>
        <div class="alert alert-danger" role="alert">
          An error occurred while saving your reservation. Please <a href="/">try again</a> in a few minutes.
        </div>
      <cfelse>
        <h1>#$.content('title')#</h1>
      
        #$.dspBody(body=$.content('body')
          , pageTitle=''
          , crumbList=false
          , showMetaImage=false
        )#
        
        #$.dspObjects(2)#
      </cfif>
    </div>

    <cfinclude  template="inc/footer.cfm" />
    <cfinclude  template="inc/html_foot.cfm" />
  </body>
</html>
</cfoutput>