<cfoutput>
<div class="container">
  <header class="d-flex flex-wrap justify-content-center py-3 mb-4 border-bottom">
    <a href="/" class="d-flex align-items-center mb-3 mb-md-0 me-md-auto link-body-emphasis text-decoration-none">
      <img src="#$.siteConfig('themeAssetPath')#/images/logo.png" style="height:2.5rem;margin-right:1rem" />
      <!--- <span class="fs-4">Simple header</span> --->
    </a>
    <ul class="nav nav-pills">
      <cfif (len(m.content('filename')) eq 0)>
        <li><a href="/" class="nav-link px-2 link-secondary">Home</a></li>
        <cfelse>
        <li><a href="/" class="nav-link px-2">Home</a></li>
      </cfif>
      <cfset i = m.getBean('content').loadBy(title='Home').getKidsIterator() />
      <cfif i.hasNext()>
        <cfloop condition="i.hasNext()">
          <cfset item = i.next() />
          <cfif (FindNoCase(m.content('filename'), item.getURLTitle()) eq 0)>
          <li><a href="#item.getUrl()#" class="nav-link px-2">#item.getMenuTitle()#</a></li>
          <cfelse>
          <li><a href="#item.getUrl()#" class="nav-link px-2 link-secondary">#item.getMenuTitle()#</a></li>
          </cfif>
        </cfloop>
      </cfif>
    </ul>
  </header>
</div>
</cfoutput>