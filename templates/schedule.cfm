<cfinclude template="inc/globals.cfm" />
<cfscript>
  start = dateFormat(now(), "yyyy-mm-dd")
  end = dateFormat(now().add("d", 30), "yyyy-mm-dd")
  req = new http(method = "GET", charset = "UTF-8", url = API_URL & "/events/by-date")
  req.addParam(name = "start", type = "url", value = start)
  req.addParam(name = "end", type = "url", value = end)
  data = deserializeJSON(req.send().getPrefix().filecontent).data
  #setTimezone('America/Chicago')#
</cfscript>
<cfoutput>
<!doctype html>
<html lang="en">
  <head>
    <cfinclude template="inc/html_head.cfm" />
  </head>
  <body>
    <cfinclude template="inc/navbar.cfm" />

    <section class="py-5 text-center container">
      <div class="row py-lg-5">
        <div class="col-lg-6 col-md-8 mx-auto">
          <h1 class="fw-light">Schedule</h1>
          #$.dspBody(
            body=$.content('body'), 
            pageTitle='', 
            crumbList=false, 
            showMetaImage=false
          )#
        </div>
      </div>
    </section>

    <div class="album py-5">
      <div class="container">
        <cfloop item="item" array="#data#">
          <cfif arrayLen(item.events) GT 0>
            <h5 class="d-flex align-items-center gap-2">
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-calendar-event" viewBox="0 0 16 16">
                <path d="M11 6.5a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5z"/>
                <path d="M3.5 0a.5.5 0 0 1 .5.5V1h8V.5a.5.5 0 0 1 1 0V1h1a2 2 0 0 1 2 2v11a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V3a2 2 0 0 1 2-2h1V.5a.5.5 0 0 1 .5-.5M1 4v10a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1V4z"/>
              </svg>
              #dateFormat(parseDateTime(item.date), "dddd, mmmm d")#
              (#arrayLen(item.events)# events)
            </h5>
            <hr />
            <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 g-3">
              <cfloop item="e" array="#item.events#">
              <div class="col">
                <a href="/events?id=#e.id#" class="card mb-3" style="max-width:540px;text-decoration:none">
                  <div class="row g-0">
                    <div class="col-md-4">
                      <img src="/sites/#$.siteConfig('siteId')#/assets/shows/#listLast(e.show.cover, '/\')#" class="card-img-top" alt="#e.show.name# cover">
                    </div>
                    <div class="col-md-8">
                      <div class="card-body">
                        <h5 class="card-title text-truncate">#e.show.name#</h5>
                        <div class="card-text">
                          <span class="badge text-bg-dark">#e.type.name#</span>
                          <span class="badge text-bg-primary">#e.show.type#</span>
                        </div>
                        <p class="card-text">
                          <small class="text-body-secondary">
                            #dateTimeFormat(parseDateTime(e.start), "ddd, mmm d @ h:nn tt")#
                          </small>
                        </p>
                      </div>
                    </div>
                  </div>
                </a>
              </div>
              </cfloop>
            </div>
          </cfif>
          <br />
        </cfloop>
        <div class="d-flex flex-row-reverse">
          <a href="https://astral.anderfernandes.com" target="_blank" class="badge text-bg-dark d-flex gap-1" style="text-decoration:none"><i class="bi bi-brightness-high-fill"></i>Powered by Astral</a>
        </div>
      </div>
    </div>

    <cfinclude  template="inc/footer.cfm" />
    <cfinclude  template="inc/html_foot.cfm" />
  </body>
</html>
</cfoutput>