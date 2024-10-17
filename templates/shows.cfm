<cfinclude template="inc/globals.cfm" />
<cfscript>
  if (structKeyExists(url, 'id')) {
    // TODO: HANDLE IDS OF SHOWS THAT DON'T EXIST
    req = new http(method = "GET", chartset = "UTF-8", url = API_URL & "/shows")
    req = new http(method = "GET", charset = "UTF-8", url = API_URL & "/shows/" & url.id)
    show = deserializeJSON(req.send().getPrefix().filecontent)
  } else  {
    req = new http(method = "GET", chartset = "UTF-8", url = API_URL & "/shows")
    shows = deserializeJSON(req.send().getPrefix().filecontent).data
    shows = arrayFilter(shows, function(s) { return s.active != "0" })
    
    
    if (structKeyExists(url, 'name') AND stringLen(url.name) GT 0) {
      shows = arrayFilter(shows, function (s) { return findNoCase(url.name, s.name, 0) != 0 })
    }
    
    if (structKeyExists(url, 'type') AND stringLen(url.type) GT 0) {
      shows = arrayFilter(shows, function (s) { return lCase(s.type) == lCase(url.type) })
    }
  }
</cfscript>
<cfoutput>
<!doctype html>
<html lang="en">
  <head>
    <cfinclude template="inc/html_head.cfm" />
  </head>
  <body>
    <cfinclude template="inc/navbar.cfm" />

    <cfif structKeyExists(url, 'id')>

    <div class="container">
      <div class="row">
        <a href="/shows" class="text-dark">
          <svg style="height: 24px; width: 24px;" viewBox="0 0 24 24"><path fill="currentColor" d="M20,11V13H8L13.5,18.5L12.08,19.92L4.16,12L12.08,4.08L13.5,5.5L8,11H20Z"></path></svg>
        </a>
        <br /><br />
        <div class="col-12">
          <div class="py-5 text-center">
            <img class="d-block mx-auto mb-4" src="/sites/#$.siteConfig('siteId')#/assets/shows/#listLast(show.cover, '/\')#" alt="" width="248" />
            <h2>#show.name#</h2>
            <h4 class="d-flex gap-2 justify-content-center">
              <span class="badge text-bg-primary">#show.type#</span> &middot; #show.duration# mins
            </h4>
            <p class="lead">#show.description#</p>
          </div>
          
        </div>
        <div class="d-flex flex-row-reverse">
          <a href="https://astral.anderfernandes.com" target="_blank" class="badge text-bg-dark" style="text-decoration:none">Powered by Astral</a>
        </div>
      </div>
    </div>

    <cfelse>
    
    <div class="container">
      <div class="row">
        <h1>Shows</h1>
        #$.dspBody(
          body=$.content('body'), 
          pageTitle='', 
          crumbList=false, 
          showMetaImage=false
        )#
      </div>
      <div class="row">
        <div>
          <label for="exampleFormControlInput1" class="form-label">Search</label>
        </div>
      </div>
      <form class="row">
        <div class="col-12 col-md-3 mb-3">
          <input class="form-control" type="text" placeholder="Name" name="name" value="#structKeyExists(url, 'name') ? url.name : ''#" />
        </div>
        <div class="col-12 col-md-3 mb-3">
          <select class="form-select" aria-label="Type" name="type">
            <option selected value="">Type</option>
            <option value="Planetarium" #structKeyExists(url, 'type') AND lCase(url.type) == 'planetarium' ? 'selected' : ''#>Planetarium</option>
            <option value="Laser Light" #structKeyExists(url, 'type') AND lCase(url.type) == 'laser light' ? 'selected' : ''#>Laser Light</option>
          </select>
        </div>
        <div class="col-12 col-md-3 mb-3">
          <button type="submit" class="btn btn-primary">Search</button>
        </div>
      </form>
      <hr />
    </div>

    <div class="container">
      <div class="row">
        <cfloop item="show" array="#shows#">
          <div class="col col-md-3 gy-3">
            <a href="?id=#show.id#" class="card" style="text-decoration:none">
              <img src="/sites/#$.siteConfig('siteId')#/assets/shows/#listLast(show.cover, '/\')#" class="card-img-top" alt="#show.name#">
              <div class="card-body">
                <h5 class="card-title text-truncate">#show.name#</h5>
                <div class="d-flex gap-2 align-items-center">
                  <span class="badge text-bg-primary">#show.type#</span> &middot;
                  <p class="card-text">#show.duration# mins</p>
                </div>
              </div>
            </a>
          </div>
        </cfloop>
      </div>
      <div class="d-flex flex-row-reverse">
        <a href="https://astral.anderfernandes.com" target="_blank" class="badge text-bg-dark d-flex gap-1" style="text-decoration:none"><i class="bi bi-brightness-high-fill"></i>Powered by Astral</a>
      </div>
    </div>

    </cfif>

    <cfinclude  template="inc/footer.cfm" />
    <cfinclude  template="inc/html_foot.cfm" />
  </body>
</html>
</cfoutput>