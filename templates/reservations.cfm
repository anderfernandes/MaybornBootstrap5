<cfinclude template="inc/globals.cfm" />
<cfscript>
  data = structNew()
  seats = structKeyExists(form, 'date') && structKeyExists(form, 'students') && structKeyExists(form, 'teachers') && structKeyExists(form, 'parents') 
    ? (toNumeric(form.students) + toNumeric(form.teachers) + toNumeric(form.parents)) 
    : 0
  shows = []
  organizations = []
  events = []
  mocked_events = array()
  fetched_events = []
  
  if (structKeyExists(form, 'date') && seats <= 180) {
    req = new http(method = "GET", charset = "UTF-8", url = API_URL & "/shows")
    shows = deserializeJSON(req.send().getPrefix().filecontent).data
    shows = arrayFilter(shows, function(s) { return s.active != "0" })
    req = new http(method = "GET", charset = "UTF-8", url = API_URL & "/organizations" )
    organizations = deserializeJSON(req.send().getPrefix().filecontent)
    mocked_events = array(
      [ title = "Available", start = form.date & " 09:30:00", end = form.date & " 10:30:00", type_id = 5],
      [ title = "Available", start = form.date & " 10:30:00", end = form.date & " 11:30:00", type_id = 5],
      [ title = "Available", start = form.date & " 11:30:00", end = form.date & " 12:30:00", type_id = 5],
      [ title = "Available", start = form.date & " 12:30:00", end = form.date & " 13:30:00", type_id = 5]
    )
    req = new http(method = "GET", chartset = "UTF-8", url = API_URL & "/public/findAvailableEvents")
    req.addParam(name = "date", type = "url", value = form.date)
    req.addParam(name="seats", type = "url", value = seats)
    fetched_events = deserializeJSON(req.send().getPrefix().filecontent).data
    
    events = arrayFilter(mocked_events, function(e) {
      return !arrayContains(fetched_events, [ 
        title = "Not Available", start = e.start, end = e.end, type_id = e.type_id 
      ])
    })
    
  }
  
  if (structKeyExists(form, "firstname")) {
    data.address = structKeyExists(form, "address") ? form.address : ""
    data.cell = structKeyExists(form, "cell") ?form.cell : ""
    data.city = structKeyExists(form, "city") ? form.city : ""
    data.email = form.email
    // map a "list" to array, loop through the array and build the object below, using indexes
    data.events = arrayMap(listToArray(form.eventdate), function (item, i) {
      return { date: item, show_id: listToArray(form.show_id)[i] }
    }) 
    data.firstname = form.firstname
    data.lastname = form.lastname
    data.email = form.email
    data.memo = form.memo
    data.parents = form.parents
    data.phone = structKeyExists(form, "phone") ? form.phone : ""
    data.postShow = form.postshow
    data.school = form.school
    data.schoolId = structKeyExists(form, "schoolId") ? form.schoolId : ""
    data.special_needs = false //form.special_needs
    data.state = "Texas"
    data.students = form.students
    data.taxable = true
    data.teachers = form.teachers
    data.zip = form.zip
  }
</cfscript>
<cfoutput>
<!doctype html>
<html lang="en" data-bs-theme="auto">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="Mark Otto, Jacob Thornton, and Bootstrap contributors">
    <meta name="generator" content="Hugo 0.122.0">
    
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

      .container {
        /*max-width: 960px;*/
      }

      .list-group {
        width: 100%;
        /*max-width: 460px;
        margin-inline: 1.5rem;*/
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

  </head>

  <body class="bg-body-tertiary">

    <div class="container">
      
      <main>

        <div class="py-5 text-center">
          <img class="d-block mx-auto mb-4" src="#$.siteConfig('themeAssetPath')#/images/logo.png" alt="" width="63" height="84">
          <h2>Online Reservation Form</h2>
          <p class="lead">Make sure you <a target="_blank" href="/field-trips">read field trip information page</a> beforehand.</p>
        </div>
        
        <cfif structKeyExists(form, 'date') AND arrayLen(events) <= 0>
          <div class="alert alert-danger d-flex align-items-center d-flex gap-2" role="alert">
            <i class="bi bi-exclamation-triangle-fill"></i>
            <div>
              No events with #seats# seats available were found for #dateFormat(form.date, "full")#.
            </div>
          </div>
        </cfif>

        <cfif seats GT 180>
          <div class="alert alert-danger d-flex align-items-center d-flex gap-2" role="alert">
            <i class="bi bi-exclamation-triangle-fill"></i>
            <div>
              The maximum number of seats is 180.
            </div>
          </div>
        </cfif>

        <div class="row row-cols-1 row-cols-md-2 align-items-md-center gy-5 py-5">
          <div class="col d-flex flex-column align-items-start gap-2">
            <h2 class="fw-bold text-body-emphasis">Date and Attendance</h2>
            <p class="text-body-secondary">Tell us the date you want for your field trip and how many people total will be attending, number may not be more than 180 people.</p>
          </div>

          <form class="col" method="POST" id="availability" action="##overview">
            <div class="row row-cols-1 g-4">
              <div class="col d-flex flex-column gap-2">
                <div class="feature-icon-small d-inline-flex align-items-center justify-content-center text-bg-primary bg-gradient fs-4 rounded-3">
                  <i class="bi bi-calendar-check"></i>
                </div>
                <h4 class="fw-semibold mb-0 text-body-emphasis">Date</h4>
                <label for="date" class="text-body-secondary">The date of your field trip. Minimum date is 7 days ahead.</label>
                
                <cfif structKeyExists(form, 'date')>
                <input type="date" class="form-control" placeholder="Date" value="#form.date#" name="date" required placeholder="Date" />
                <cfelse>
                <input type="date" class="form-control" placeholder="Date" name="date" min="#dateFormat(dateAdd('d', 7, now()), "yyyy-mm-dd")#" required class="text-sm rounded-lg border border-zinc-300 w-full md:w-1/3" />
                </cfif>
              </div>

              <div class="col d-flex flex-column gap-2">
                <div class="feature-icon-small d-inline-flex align-items-center justify-content-center text-bg-primary bg-gradient fs-4 rounded-3">
                  <i class="bi bi-people"></i>
                </div>
                <h4 class="fw-semibold mb-0 text-body-emphasis">Students: <span id="students-count">20</span></h4>
                <label for="students" class="text-body-secondary">How many students?</label>
                <input class="form-range" type="range" name="students" min="20" max="180" value="#structKeyExists(form, 'students') ? form.students : 20#" required #arrayLen(events) GT 0 ? 'disabled' : ''# />
              </div>

              <div class="col d-flex flex-column gap-2">
                <div class="feature-icon-small d-inline-flex align-items-center justify-content-center text-bg-primary bg-gradient fs-4 rounded-3">
                  <i class="bi bi-people"></i>
                </div>
                <h4 class="fw-semibold mb-0 text-body-emphasis">Teachers: <span id="teachers-count">2</span></h4>
                <label for="teachers" class="text-body-secondary">Every 10 paying students, 1 teacher/chapaerone is free.</label>
                <input class="form-range" type="range" class="text-blue-900" name="teachers" min="2" max="180" value="#structKeyExists(form, 'teachers') ? form.teachers : 2#" required #arrayLen(events) GT 0 ? 'disabled' : ''# />
              </div>

              <div class="col d-flex flex-column gap-2">
                <div class="feature-icon-small d-inline-flex align-items-center justify-content-center text-bg-primary bg-gradient fs-4 rounded-3">
                  <i class="bi bi-people"></i>
                </div>
                <h4 class="fw-semibold mb-0 text-body-emphasis">Parents: <span id="parents-count">0</span></h4>
                <label for="parents" class="text-body-secondary">Parents included in the field trip's invoice.</label>
                <input class="form-range" type="range" name="parents" min="0" max="180" value="#structKeyExists(form, 'parents') ? form.parents : 0#" required #arrayLen(events) GT 0 ? 'disabled' : ''# />
                <br />
                <cfif arrayLen(events) GT 0 && structKeyExists(form, 'date') && seats <= 180 && seats GT 0>
                <button type="submit" class="btn btn-primary btn-lg" disabled>
                  Check Availability
                </button>
                <cfelse>
                <button type="submit" class="btn btn-primary btn-lg" >
                  Check Availability
                </button>
                </cfif>
              </div>
            </div>
          </form>
        </div>

        <hr class="my-4" />

        <cfif arrayLen(events) GT 0 && structKeyExists(form, 'date') && seats <= 180 && seats GT 0>
        <div class="row gy-5" id="overview">
          <div class="col-md-5 col-lg-4 order-md-last">
            <h4 class="d-flex justify-content-between align-items-center mb-3">
              <span class="text-primary">Overview</span>
            </h4>
            <ul class="list-group mb-3">
              <li class="list-group-item d-flex justify-content-between lh-sm">
                <div>
                  <h6 class="my-0">Students</h6>
                </div>
                <span class="text-body-secondary">#form.students#</span>
              </li>
              <li class="list-group-item d-flex justify-content-between lh-sm">
                <div>
                  <h6 class="my-0">Teachers</h6>
                </div>
                <span class="text-body-secondary">#form.teachers#</span>
              </li>
              <li class="list-group-item d-flex justify-content-between lh-sm">
                <div>
                  <h6 class="my-0">Parents</h6>
                </div>
                <span class="text-body-secondary">#form.parents#</span>
              </li>
              <li class="list-group-item d-flex justify-content-between">
                <span>Total</span>
                <strong>#form.students + form.teachers + form.parents#</strong>
              </li>
            </ul>
            <div class="d-grid gap-2">
              <a href="/reservations" class="btn btn-secondary btn-lg" >Start Over</a>
            </div>
          </div>

          <div class="col-md-7 col-lg-8">
            <h4 class="mb-3">Dates, shows and post shows</h4>
            <form method="POST" action="/index.cfm/thank-you/">
              <cfif structKeyExists(form, 'date')>
                <input type="hidden" name="date" value="#form.date#" />
              </cfif>
              <cfif structKeyExists(form, 'students')>
                <input type="hidden" name="students" value="#form.students#"/>
              </cfif>
              <cfif structKeyExists(form, 'teachers')>
                <input type="hidden" name="teachers" value="#form.teachers#" />
              </cfif>
              <cfif structKeyExists(form, 'parents')>
                <input type="hidden" name="parents" value="#form.parents#" />
              </cfif>
              <label class="form-label">Date(s) and Show(s)</label>
              <div class="list-group list-group-radio d-grid gap-2 border-0">
                <cfloop array="#events#" index="i" item="item">
                <div class="position-relative">
                  <input class="form-check-input position-absolute top-50 end-0 me-3 fs-5" type="checkbox" name="eventdate" id="eventdate-#i#" value="#item.start#">
                  <label class="list-group-item py-3 pe-5" for="listGroupRadioGrid#i#">
                    <strong class="fw-semibold">#dateTimeFormat(item.start, "EEE mmm d @ h:nn tt")#</strong>
                    <div class="d-block small opacity-75">
                      <select class="form-select" name="show_id" id="show_id">
                        <option value="">Choose a show...</option>
                        <cfloop array="#shows#" item="show">
                          <option value="#show.id#">#show.name# (#show.type#, #show.duration# mins)</option>
                        </cfloop>
                      </select>
                    </div>
                  </label>
                </div>
                </cfloop>
              </div>
              <br />
              <div class="col-12">
                <label class="form-label">Post Show Presentation</label>
                <div class="list-group list-group-radio d-grid gap-2 border-0">
                  <div class="position-relative">
                    <input class="form-check-input position-absolute top-50 end-0 me-3 fs-5" type="radio" name="postshow" id="startalk" value="Star Talk" checked>
                    <label class="list-group-item py-3 pe-5" for="startalk">
                      <strong class="fw-semibold">Star Talk</strong>
                      <span class="d-block small opacity-75">We will show your group in our dome constellations of the current evening sky.</span>
                    </label>
                  </div>

                  <div class="position-relative">
                    <input class="form-check-input position-absolute top-50 end-0 me-3 fs-5" type="radio" name="postshow" id="uniview" value="Uniview">
                    <label class="list-group-item py-3 pe-5" for="uniview">
                      <strong class="fw-semibold">Uniview</strong>
                      <span class="d-block small opacity-75">We will take your group on a tour of the solar system and beyond.</span>
                    </label>
                  </div>
                </div>
              </div>
              <br />

              <h4 class="mb-3">School Information</h4>
              <div class="col-md-12">
                <label for="country" class="form-label">School, Organization or Group Name</label>
                <select class="form-select" id="organization" name="schoolId" required="">
                  <option value="">Choose...</option>
                  <cfloop array="#organizations#" item="organization">
                  <option value="#organization.id#">#organization.name#</option>
                  </cfloop>
                  <option value="0">My school is not on the list</option>
                </select>
                <span class="form-text">
                  Schools are ordered alphabetically. If your school is not on the list, select the last option.
                </span>
              </div>
              <br />

              <div id="organization-details" class="row g-3" style="display:none">
                <div class="col-sm-12">
                  <label for="school" class="form-label">School, Organization or Group Name</label>
                  <input type="text" name="school" class="form-control" id="school" name="school" placeholder="School, Organization or Group Name" min="2" max="255" value="">
                </div>
                <div class="col-sm-12">
                  <label for="address" class="form-label">Address</label>
                  <input type="text" name="address" class="form-control" id="address" placeholder="Address" min="2" maxlength="255" value="">
                </div>
                <div class="col-sm-6">
                  <label for="city" class="form-label">City</label>
                  <input type="text" name="city" class="form-control" id="city" placeholder="City" min="2" max="63" value="">
                </div>
                <div class="col-sm-6">
                  <label for="state" class="form-label">State</label>
                  <select class="form-select" name="state" id="state" required="" disabled>
                    <option>Texas</option>
                  </select>
                </div>
                <div class="col-sm-6">
                  <label for="school-zip" class="form-label">ZIP</label>
                  <input type="text" name="zip" class="form-control" id="school-zip" placeholder="5 digit zip code" minlength="5" maxlength="5" value="">
                </div>
                <div class="col-sm-6">
                  <label for="phone" class="form-label">Phone</label>
                  <input type="text" name="phone" class="form-control" id="phone" placeholder="Phone with area code, numbers only" minlength="10" maxlength="10" value="">
                </div>
              </div>
              <br />

              <h4 class="mb-3">Group Leader Information</h4>
              
              <div class="row g-3">
                <div class="col-sm-6">
                  <label for="firstname" class="form-label">First name</label>
                  <input type="text" name="firstname" class="form-control" id="firstname" placeholder="First Name" minlength="2" maxlength="128" required>
                </div>
                <div class="col-sm-6">
                  <label for="lastname" class="form-label">Last name</label>
                  <input type="text" name="lastname" class="form-control" id="lastname" placeholder="Last Name" minlength="2" maxlength="128" value="" required>
                </div>
                <div class="col-sm-6">
                  <label for="email" class="form-label">Email</label>
                  <input type="email" name="email" class="form-control" id="email" placeholder="you@example.com" required>
                </div>
                <div class="col-sm-6">
                  <label for="cell" class="form-label">Phone</label>
                  <input type="text" name="cell" name="cell" class="form-control" id="cell" placeholder="Phone with area code, numbers only" minlength="10" maxlength="10" required>
                </div>
              </div>
              
              <hr class="my-4">

              <div class="col-sm-12">
                <label for="memo" class="form-label">Notes</label>
                <textarea name="memo" class="form-control" id="memo" placeholder="Write us anything that will help with your reservation. Optional." value="" required=""></textarea>
              </div>
              <br />

              <button class="w-100 btn btn-primary btn-lg" type="submit" onclick="return confirm('Are you sure you want to submit?')">
                Submit
              </button>
            </form>

          </div>
        </div>
        </cfif>
        <cfinclude  template="inc/footer.cfm" />
      </main>
      <cfinclude  template="inc/html_foot.cfm" />
      <script src="#$.siteConfig('themeAssetPath')#/js/reservations.js"></script>
    </div>

  </body>
</html>
</cfoutput>