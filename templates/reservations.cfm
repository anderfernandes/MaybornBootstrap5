<cfinclude template="inc/globals.cfm" />
<cfscript>
  shows = []
  organizations = []
  events = []
  mocked_events = []
  fetched_events = []

  if (structKeyExists(url, 'date') && structKeyExists(url, 'students') && structKeyExists(url, 'teachers') && structKeyExists(url, 'parents')) {
    seats = toNumeric(url.students) + toNumeric(url.teachers) + toNumeric(url.parents)
    date = url.date
    // TODO: ENSURE DATE >= 7 DAYS FROM NOW, ATTENDANCE RULES
    req = new http(method = "GET", chartset = "UTF-8", url = API_URL & "/public/findAvailableEvents")
    req.addParam(name = "date", type = "url", value = url.date)
    req.addParam(name="seats", type = "url", value = seats)
    fetched_events = deserializeJSON(req.send().getPrefix().filecontent).data
    
    mocked_events = array(
      [ "title" = "Available", "start" = date & " 09:30:00", "end" = date & " 10:30:00", "type_id" = 5],
      [ "title" = "Available", "start" = date & " 10:30:00", "end" = date & " 11:30:00", "type_id" = 5],
      [ "title" = "Available", "start" = date & " 11:30:00", "end" = date & " 12:30:00", "type_id" = 5],
      [ "title" = "Available", "start" = date & " 12:30:00", "end" = date & " 13:30:00", "type_id" = 5]
    )
    
    events = arrayFilter(mocked_events, function(e) {
      return !arrayContains(fetched_events, [ 
        "title" = "Not Available", "start" = e.start, "end" = e.end, "type_id" = e.type_id 
      ])
    })

    if (arrayLen(arrayFilter(events, function (e) { return e.title == "Available"})) > 0) {
      req = new http(method = "GET", charset = "UTF-8", url = API_URL & "/shows")
      shows = deserializeJSON(req.send().getPrefix().filecontent).data
      shows = arrayFilter(shows, function(s) { return s.active != "0" })
      req = new http(method = "GET", charset = "UTF-8", url = API_URL & "/organizations" )
      organizations = deserializeJSON(req.send().getPrefix().filecontent)
      //writeDump(shows)
      //writeDump(organizations)
    }

    //writeDump(events)
  }
</cfscript>
<cfoutput>
<!doctype html>
<html lang="en" data-bs-theme="auto">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <title>Online Reservation Form - #esapiEncode('html', $.siteConfig('site'))#</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="#$.siteConfig('themeAssetPath')#/css/styles.css">

    <!-- Favicons -->
    <meta name="theme-color" content="##712cf9">

    <style>
      .bd-placeholder-img {
        font-size: 1.125rem;
        text-anchor: middle;
        -webkit-user-select: none;
        -moz-user-select: none;
        user-select: none;
      }

      @media (min-width: 768px) {
        .bd-placeholder-img-lg {
          font-size: 3.5rem;
        }
      }

      .b-example-divider {
        width: 100%;
        height: 3rem;
        background-color: rgba(0, 0, 0, .1);
        border: solid rgba(0, 0, 0, .15);
        border-width: 1px 0;
        box-shadow: inset 0 .5em 1.5em rgba(0, 0, 0, .1), inset 0 .125em .5em rgba(0, 0, 0, .15);
      }

      .b-example-vr {
        flex-shrink: 0;
        width: 1.5rem;
        height: 100vh;
      }

      .bi {
        vertical-align: -.125em;
        fill: currentColor;
      }

      .nav-scroller {
        position: relative;
        z-index: 2;
        height: 2.75rem;
        overflow-y: hidden;
      }

      .nav-scroller .nav {
        display: flex;
        flex-wrap: nowrap;
        padding-bottom: 1rem;
        margin-top: -1px;
        overflow-x: auto;
        text-align: center;
        white-space: nowrap;
        -webkit-overflow-scrolling: touch;
      }

      .btn-bd-primary {
        --bd-violet-bg: ##712cf9;
        --bd-violet-rgb: 112.520718, 44.062154, 249.437846;

        --bs-btn-font-weight: 600;
        --bs-btn-color: var(--bs-white);
        --bs-btn-bg: var(--bd-violet-bg);
        --bs-btn-border-color: var(--bd-violet-bg);
        --bs-btn-hover-color: var(--bs-white);
        --bs-btn-hover-bg: ##6528e0;
        --bs-btn-hover-border-color: ##6528e0;
        --bs-btn-focus-shadow-rgb: var(--bd-violet-rgb);
        --bs-btn-active-color: var(--bs-btn-hover-color);
        --bs-btn-active-bg: ##5a23c8;
        --bs-btn-active-border-color: ##5a23c8;
      }

      .bd-mode-toggle {
        z-index: 1500;
      }

      .bd-mode-toggle .dropdown-menu .active .bi {
        display: block !important;
      }

      .list-group {
        width: 100%;
      }

      .form-check-input:checked + .form-checked-content {
        opacity: .5;
      }

      .form-check-input-placeholder {
        border-style: dashed;
      }
      [contenteditable]:focus {
        outline: 0;
      }

      .list-group-checkable .list-group-item {
        cursor: pointer;
      }
      .list-group-item-check {
        position: absolute;
        clip: rect(0, 0, 0, 0);
      }
      .list-group-item-check:hover + .list-group-item {
        background-color: var(--bs-secondary-bg);
      }
      .list-group-item-check:checked + .list-group-item {
        color: ##fff;
        background-color: var(--bs-primary);
        border-color: var(--bs-primary);
      }
      .list-group-item-check[disabled] + .list-group-item,
      .list-group-item-check:disabled + .list-group-item {
        pointer-events: none;
        filter: none;
        opacity: .5;
      }

      .list-group-radio .list-group-item {
        cursor: pointer;
        border-radius: .5rem;
      }
      .list-group-radio .form-check-input {
        z-index: 2;
        margin-top: -.5em;
      }
      .list-group-radio .list-group-item:hover,
      .list-group-radio .list-group-item:focus {
        background-color: var(--bs-secondary-bg);
      }

      .list-group-radio .form-check-input:checked + .list-group-item {
        background-color: var(--bs-body);
        border-color: var(--bs-primary);
        box-shadow: 0 0 0 2px var(--bs-primary);
      }
      .list-group-radio .form-check-input[disabled] + .list-group-item,
      .list-group-radio .form-check-input:disabled + .list-group-item {
        pointer-events: none;
        filter: none;
        opacity: .5;
      }

    </style>
    <script src="https://unpkg.com/vue@3/dist/vue.global.prod.js"></script>
    <script>
      const organizations = #serializeJSON(organizations)#
      const shows = #serializeJSON(shows)#
      const events = #serializeJSON(events)#
      const base = "/sites/#$.siteConfig('siteId')#/assets/shows"
    </script>
  </head>
  <body class="bg-body-tertiary mb-5">
    <div class="container px-md-5">
      <main>
        <div class="py-5 text-center">
          <a href="/" style="display:contents">
            <img class="d-block mx-auto mb-4" src="#$.siteConfig('themeAssetPath')#/images/logo.png" alt="" width="63" height="84">
          </a>
          <h2>Online Reservation Form</h2>
          <p class="lead">Make sure you <a target="_blank" href="/field-trips">read field trip information page</a> beforehand.</p>
        </div>
        <section id="attendance">Loading...</section>
        <cfif arrayLen(organizations) GT 0>
          <hr />
          <section id="reservation"></section>
        </cfif>
      </main>
    </div>
    #$.dspBody(
      body=$.content('body'), 
      pageTitle='', 
      crumbList=false, 
      showMetaImage=false
    )#
  </body>
</html>
</cfoutput>