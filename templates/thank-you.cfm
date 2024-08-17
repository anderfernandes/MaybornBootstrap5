<cfinclude template="inc/globals.cfm" />
<cfscript>
  data = {
    // Field trip data
    "students": form.students,
    "teachers": form.teachers,
    "parents": form.parents,
    "postShow": form.postshow,
    "events": [],
    "memo": form.memo,
    "special_needs": 0,
    "taxable": 1,
    "schoolId": form.schoolId,
    // New organization data
    "school": form.school,
    "address": structKeyExists(form, "address") ? form.address : "",
    "city": structKeyExists(form, "city") ? form.city : "",
    "phone": structKeyExists(form, "phone") ? form.phone : "",
    // Teacher data
    "firstname": form.firstname,
    "lastname": form.lastname,
    "email": form.email,
    "cell": structKeyExists(form, "cell") ? form.cell : "",
    "state": "Texas",
    "zip": form.zip,
  }
  arrayEach(listToArray(form.show_id), function (id, i) {
    d = listToArray(form.eventdate)[i]
    if (id != "0") {
      arrayAppend(data.events, { "show_id": id, "date": d })
    }
  });
  req = new http(method = "POST", charset = "UTF-8", url = API_URL & "/public/createReservation", accept = "application/json");
  req.addParam(type = "header", name= "content-type", value = "application/json")
  req.addParam(type = "body", value = "#serializeJSON(data)#")
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
      <!--- <cfdump var="#res#" />
      <cfdump var="#serializeJSON(data)#" /> --->

      <cfset pageTitle = $.content("type") neq "Page" ?  : "">

      <cfif res.getPrefix().status_code GT 299>
        <div class="alert alert-danger" role="alert">
          An error occurred while saving your reservation. Please <a href="/">try again</a> in a few minutes.
        </div>
      <cfelse>
        <h1>#$.content("title")#</h1>
      
        #$.dspBody(body=$.content("body")
          , pageTitle=""
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