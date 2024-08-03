<cfinclude template="inc/globals.cfm" />
<cfscript>
  //API_URL = "https://astral.ctcd.org/api"
  //API_URL = "http://127.0.0.1:8000/api"
  try {
    req = new http(method = "GET", charset = "UTF-8", url= API_URL & "/event/" & url.id)
    data = deserializeJSON(req.send().getPrefix().filecontent)
    tickets = data.allowedTickets.filter(function (t) { return t.public })
  } catch (any e) {
    data = nullValue()
  }
  #setTimezone('America/Chicago')#
</cfscript>
<cfoutput>
<!doctype html>
<html lang="en">
  <head>
    <cfinclude template="inc/html_head.cfm" />
    <script type="application/ld+json">
      {
        "@context": "https://schema.org",
        "@type": "Event",
        "name": "#data.show.name#",
        "startDate": "#data.start#",
        "endDate": "#data.end#",
        "eventAttendanceMode": "https://schema.org/OfflineEventAttendanceMode",
        "eventStatus": "https://schema.org/EventScheduled",
        "location": {
          "@type": "Place",
          "name": "Mayborn Science Theater",
          "address": {
            "@type": "PostalAddress",
            "streetAddress": "On the Campus of Central Texas College, Bldg No. 267, Bell Tower Drive, 6200 W Central Texas Expy",
            "addressLocality": "Killeen",
            "postalCode": "76549",
            "addressRegion": "TX",
            "addressCountry": "US"
          }
        },
        "image": [
          "https://#$.siteConfig('domain')#/sites/#$.siteConfig('siteId')#/assets/Image/covers/#data.show.id#.jpg",
        ],
        "description": "#data.show.description#",
      }
    </script>
  </head>
  <body>
    <cfinclude template="inc/navbar.cfm" />

    <div class="container">
      <a href="/schedule" class="text-dark">
        <svg style="height: 24px; width: 24px;" viewBox="0 0 24 24"><path fill="currentColor" d="M20,11V13H8L13.5,18.5L12.08,19.92L4.16,12L12.08,4.08L13.5,5.5L8,11H20Z"></path></svg>
      </a>
      <cfif parseDateTime(data.start) LT now()>
          <br /><br />
          <div class="alert alert-warning" role="alert">
            This event already happened.
          </div>
      </cfif>
    </div>

    <div class="container col-xxl-8 px-4 py-5">
      <div class="row align-items-center g-5">
        <div class="col-sm-4 col-lg-4">
          <img src="/sites/#$.siteConfig('siteId')#/assets/shows/#listLast(data.show.cover, '/\')#" class="d-block mx-lg-auto img-fluid" alt="#data.show.name#" width="450" height="800" loading="lazy">
        </div>
        <div class="col-sm-8 col-lg-8">
          <h1 class="display-5 fw-bold text-body-emphasis lh-1 mb-3">#data.show.name#</h1>
          <h4 class="d-flex gap-1">
            <span class="badge text-bg-dark">#data.type#</span>
            <span class="badge text-bg-primary">#data.show.type#</span>
          </h4>
          <p class="lead">#dateTimeFormat(parseDateTime(data.start), "dddd, mmm d yyyy @ h:nn tt")# &middot; #data.seats# seats left</p>
          <p>#data.show.description#</p>
          <div class="row row-cols-2 row-cols-md-4 g-3">
            <cfloop item="ticket" array="#tickets#">
              <div class="col">
                <div class="card">
                  <div class="card-body">
                    <h5 class="card-title">#ticket.name#</h5>
                    <p class="card-text">$#ticket.price# each</p>
                  </div>
                </div>
              </div>
            </cfloop>
          </div>
        </div>
      </div>
      <br />
      <div class="d-flex flex-row-reverse">
        <a href="https://astral.anderfernandes.com" target="_blank" class="badge text-bg-dark d-flex gap-1" style="text-decoration:none"><i class="bi bi-brightness-high-fill"></i>Powered by Astral</a>
      </div>
    </div>
    

    <cfinclude  template="inc/footer.cfm" />
    <cfinclude  template="inc/html_foot.cfm" />
  </body>
</html>
</cfoutput>