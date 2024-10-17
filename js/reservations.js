const { createApp, ref, computed, reactive } = Vue

const Attendance = {
  setup() {
    const url = new URL(window.location.href)
    const students = ref(url.searchParams.has('students') ? parseInt(url.searchParams.get('students')) : 20)
    const teachers = ref(2)
    const parents = ref(0)
    /**
     * 
     * @param {Event} e 
     * @returns 
     */
    const handleDateChange = (e) => {
      const date = new Date(e.currentTarget.value)
      if (date.getDay() === 5 || date.getDay() === 6) {
        alert(`Field Trips are not available on weekends.`)
        e.currentTarget.value = ""
        return
      }
    }
    const date = url.searchParams.has('date') ? url.searchParams.get('date') : ''
    const min = new Date()
    min.setDate(min.getDate() + 8)

    const hasAttendanceData = computed(() => url.searchParams.has('students') && url.searchParams.has('date'))
    const hasValidAttendance = computed(() => students.value + teachers.value + parents.value <= 180)

    return {
      students, teachers, parents, hasValidAttendance, min, hasAttendanceData, date, handleDateChange
    }
  },
  template: `
    <form class="container-fluid" method="get" action="#reservation">
      <div class="col d-flex flex-column align-items-center gap-2 text-center">
        <h2 class="fw-bold text-body-emphasis text-center">Date and Attendance</h2>
        <p class="text-body-secondary text-center">
          Tell us the date you want for your field trip and how many people total will be attending, number may not be more than 180 people.
        </p>
      </div>
      <div class="row mb-3 justify-content-center">
        <div class="col col-md-4">
          <input type="date" name="date" :min="min.toISOString().split('T')[0]" @change="handleDateChange" :value="date" :disabled="hasAttendanceData" class="form-control" placeholder="Date" required />
          <label for="date" class="text-body-secondary">The date of your field trip. Minimum date is 7 days ahead.</label>
        </div>
      </div>
      <div class="row row-cols-1 row-cols-md-3 mb-3 text-center">
        <div class="col">
          <div class="card mb-4 rounded-3 shadow-sm">
            <div class="card-header py-3">
              <h4 class="my-0 fw-normal">Students</h4>
            </div>
            <div class="card-body">
              <h1 class="card-title pricing-card-title">{{ students }}</h1>
              <ul class="list-unstyled mt-3 mb-4">
                <li class="text-body-secondary">Minimum is 20 paying kids.</li>
              </ul>
              <input name="students" v-model.number="students" :disabled="hasAttendanceData" type="range" class="form-range" id="students" min="20" max="180" required />
            </div>
          </div>
        </div>
        <div class="col">
          <div class="card mb-4 rounded-3 shadow-sm">
            <div class="card-header py-3">
              <h4 class="my-0 fw-normal">Teachers</h4>
            </div>
            <div class="card-body">
              <h1 class="card-title pricing-card-title">{{ teachers }}</h1>
              <ul class="list-unstyled mt-3 mb-4">
                <li class="text-body-secondary">For every 10 kids, 1 teacher or chaperone is free.</li>
              </ul>
              <input name="teachers" v-model.number="teachers" :disabled="hasAttendanceData" type="range" class="form-range" id="teachers" min="2" max="180" required />
            </div>
          </div>
        </div>
        <div class="col">
          <div class="card mb-4 rounded-3 shadow-sm">
            <div class="card-header py-3">
              <h4 class="my-0 fw-normal">Parents</h4>
            </div>
            <div class="card-body">
              <h1 class="card-title pricing-card-title">{{ parents }}</h1>
              <ul class="list-unstyled mt-3 mb-4">
                <li class="text-body-secondary">Parents included in the invoice.</li>
              </ul>
              <input name="parents" v-model.number="parents" :disabled="hasAttendanceData" type="range" class="form-range" id="parents" min="0" max="180" />
            </div>
          </div>
        </div>
      </div>
      <div v-if="!hasValidAttendance" class="alert alert-danger" role="alert">
        Too many people, we only have 180 seats.
      </div>
      <div class="col d-grid gap-2 d-md-flex justify-content-md-end">
        <a href="" class="btn btn-outline-secondary btn-lg" :disabled="hasAttendanceData">Clear</a>
        <button class="btn btn-primary btn-lg" :disabled="!hasValidAttendance || hasAttendanceData" type="submit">Check availability</button>
      </div>
    </form>
  `
}

const Reservation = {
  setup() {
    const attendance = Object.fromEntries(new URL(window.location).searchParams)
    const selectedDates = ref([])
    const selectedShows = reactive([0, 0, 0, 0])
    const selectedOrganization = ref("")
    const selectedPostShow = ref()

    const showOptions = shows.map(s => ({ ...s, cover: `${base}/${s.cover.split('/')[s.cover.split('/').length - 1]}` }))

    /**
     * @type {Intl.DateTimeFormatOptions}
     */
    const dateTimeFormatOptions = { weekday: "short", year: "numeric", month: "short", day: "numeric" };

    const isValid = computed(() => selectedDates.value.length === 0 || selectedShows.filter(s => s !== 0).length === 0 || selectedPostShow.value === undefined || selectedOrganization.value === '')

    /**
     * 
     * @param {Event} e 
     */
    const handleOnSubmit = (e) => {
      if (!confirm('Is all the field trip information correct? Are you sure?')) e.preventDefault()
    }

    return { attendance, events, organizations, showOptions, selectedShows, selectedDates, dateTimeFormatOptions, selectedOrganization, selectedPostShow, isValid, handleOnSubmit }
  },
  template: `
    <form method="POST" action="/index.cfm/thank-you/" @submit="handleOnSubmit">
      <input type="hidden" name="date" :value="attendance.date" />
      <input type="hidden" name="students" :value="attendance.students" />
      <input type="hidden" name="teachers" :value="attendance.teachers" />
      <input type="hidden" name="parents" :value="attendance.parents" />
      <div class="col d-flex flex-column align-items-center gap-2 text-center">
        <h2 class="fw-bold text-body-emphasis text-center">Times and Shows</h2>
        <p class="text-body-secondary text-center">
          We have {{ events.length }} time {{ events.length === 1 ? 'slot' : 'slots' }} available for 
          {{ Intl.DateTimeFormat("en-US", dateTimeFormatOptions).format(new Date(events[0].start)) }}.
          Check the time slot(s) you want and a select a show for each.
        </p>
      </div>
      <div class="row row-cols-1 row-cols-md-2 g-2">
        <div class="col" v-for="(event, i) in events">
          <div class="card">
            <div class="row g-0">
              <div class="col-md-4">
                <svg v-if="selectedShows[i] === 0" class="bd-placeholder-img img-fluid" width="100%" height="224" xmlns="http://www.w3.org/2000/svg" role="img" aria-label="Placeholder: Image" preserveAspectRatio="xMidYMid slice" focusable="false"><title>Placeholder</title><rect width="100%" height="100%" fill="#868e96"></rect><text x="50%" y="50%" fill="#dee2e6" dy=".3em">Image</text></svg>
                <img v-else :src="showOptions.find(s => s.id === selectedShows[i]).cover" width="100%" height="224" class="object-fit-cover" />
              </div>
              <div class="col-md-8">
                <div class="card-body">
                  <div class="form-check">
                    <input name="eventdate" class="form-check-input" type="checkbox" v-model="selectedDates" :value="event.start" :id="event.start">
                    <label class="form-check-label fw-bold" :for="event.start">
                      {{ Intl.DateTimeFormat("en-US", dateTimeFormatOptions).format(new Date(event.start)) }}
                      @ {{ Intl.DateTimeFormat("en-US", { timeStyle: "short" }).format(new Date(event.start)) }}
                    </label>
                  </div>
                  <hr />
                  <h5 class="card-title">
                    <select name="show_id" v-model="selectedShows[i]" :disabled="!selectedDates.includes(events[i].start)" class="form-select" aria-label="Select a show">
                      <option :value="0" selected>Select one</option>
                      <option v-for="(show) in showOptions" :value="show.id">{{ show.name }} ({{ show.type }}, {{ show.duration }} mins)</option>
                    </select>
                  </h5>
                  <p class="card-text text-body-secondary text-truncate" v-if="selectedShows[i] !== 0">
                    {{ showOptions.find(s => s.id === selectedShows[i])?.description }}
                  </p>
                  <p class="card-text" v-if="selectedShows[i] !== 0">
                    <small class="text-body-secondary">
                      {{ showOptions.find(s => s.id === selectedShows[i]).type }} &middot; {{ showOptions.find(s => s.id === selectedShows[i]).duration }} mins
                    </small>
                  </p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="col d-flex flex-column align-items-center gap-2 text-center my-3">
        <h2 class="fw-bold text-body-emphasis text-center">Post Show</h2>
        <p class="text-body-secondary text-center">
          Please select one option below.
        </p>
      </div>
      <div class="list-group list-group-radio d-grid gap-2 border-0">
        <div class="position-relative">
          <input name="postshow" class="form-check-input position-absolute top-50 end-0 me-3 fs-5" type="radio" id="startalk" value="Star Talk" v-model="selectedPostShow" />
          <label class="list-group-item py-3 pe-5" for="startalk">
            <strong class="fw-semibold">Star Talk</strong>
            <span class="d-block small opacity-75">A tour of the current evening sky including constelations and planets.</span>
          </label>
        </div>
        <div class="position-relative">
          <input name="postshow" class="form-check-input position-absolute top-50 end-0 me-3 fs-5" type="radio" id="uniview" value="Uniview" v-model="selectedPostShow" />
          <label class="list-group-item py-3 pe-5" for="uniview">
            <strong class="fw-semibold">Uniview</strong>
            <span class="d-block small opacity-75">A flight through our solar system and beyond.</span>
          </label>
        </div>
      </div>
      <div class="col d-flex flex-column align-items-center gap-2 text-center my-3">
        <h2 class="fw-bold text-body-emphasis text-center">School or Group Information</h2>
        <p class="text-body-secondary text-center">
          Tell us about your school or group.
        </p>
      </div>
      <div class="row gap-1 g-1">
        <div class="col-md-12">
          <label for="schoolId" class="form-label">School, Organization or Group</label>
          <select id="schoolId" name="schoolId" required class="form-select" v-model="selectedOrganization">
            <option value="" disabled selected>Select one</option>
            <option v-for="(organization) in organizations" :value="organization.id">{{ organization.name }} ({{ organization.type.name }})</option>
            <option value="0">My school, organization or group is not on the list</option>
          </select>
          <small class="text-body-secondary">If you can't find your school, organization or group, select the last option.</small>
        </div>
      </div>
      <div class="row gap-1 g-1 my-3" v-if="selectedOrganization === '0'">
        <div class="col-md-12">
          <label for="school" class="form-label">School, Organization or Group Name</label>
          <input name="school" value="" type="text" class="form-control" id="school" placeholder="School, Organization or Group Name" required />
        </div>
        <div class="col-md-12">
          <label for="address" class="form-label">Address</label>
          <input name="address" type="text" class="form-control" id="address" placeholder="Address" minlength="2" maxlength="255" required />
        </div>
        <div class="row g-1">
          <div class="col-md-5">
            <label for="city" class="form-label">City</label>
            <input name="city" type="text" class="form-control" id="city" placeholder="Address" minlength="2" maxlength="127" required />
          </div>
          <div class="col-md-4">
            <label for="state" class="form-label">State</label>
            <select name="state" class="form-select" id="state" disabled>
              <option default>Texas</option>
            </select>
          </div>
          <div class="col-md-3">
            <label for="zip" class="form-label">Zip</label>
            <input name="zip" type="text" class="form-control" id="zip" placeholder="ZIP" minlength="5" maxlength="5" required />
          </div>
        </div>
        <div class="col-md-6">
          <label for="phone" class="form-label">Phone</label>
          <input name="phone" type="text" class="form-control" id="address" placeholder="Phone" minlength="10" maxlength="10" required />
          <small class="text-body-secondary">Phone number with area code, numbers only</small>
        </div>
      </div>
      <div class="col d-flex flex-column align-items-center gap-2 text-center my-3">
        <h2 class="fw-bold text-body-emphasis text-center">Group Leader Information</h2>
        <p class="text-body-secondary text-center">
          Who is organizing this Field Trip?
        </p>
      </div>
      <div class="row">
        <div class="col-sm-6">
          <label for="firstName" class="form-label">First name</label>
          <input name="firstname" type="text" class="form-control" id="firstName" placeholder="First Name" minlength="2" maxlength="127" required />
        </div>
        <div class="col-sm-6">
          <label for="lastName" class="form-label">Last name</label>
          <input name="lastname" type="text" class="form-control" id="lastName" placeholder="Last Name" minlength="2" maxlength="255" required />
        </div>
      </div>
      <div class="row my-3">
        <div class="col-sm-6">
          <label for="email" class="form-label">Email</label>
          <input name="email" type="email" class="form-control" id="email" placeholder="Email" minlength="2" maxlength="255" required />
        </div>
        <div class="col-sm-6">
          <label for="cell" class="form-label">Phone</label>
          <input name="cell" type="text" class="form-control" id="cell" placeholder="Phone" minlength="10" maxlength="10" required />
          <small class="text-body-secondary">Phone number with area code, numbers only</small>
        </div>
      </div>
      <hr />
      <div class="col-md-12">
        <label for="memo" class="form-label">Notes</label>
        <textarea name="memo" class="form-control" placeholder="Write anything that will help us with your reservation. Optional."></textarea>
      </div>
      <br />
      <div v-if="selectedDates.length === 0" class="alert alert-danger" role="alert">
          You need to check at least one of the dates shown.
      </div>
      <div v-if="selectedShows.filter(s => s !== 0).length === 0" class="alert alert-danger" role="alert">
          You need to select a show for the date(s) selected.
      </div>
      <div v-if="!selectedPostShow" class="alert alert-danger" role="alert">
          Select a post show.
      </div>
      <div v-if="selectedOrganization === ''" class="alert alert-danger" role="alert">
          You must select an organization. If yours is not on the list, select the last option.
      </div>
      <div class="col d-grid gap-2 d-md-flex justify-content-md-end">
        <a href="" class="btn btn-outline-secondary btn-lg">Start Over</a>
        <button class="btn btn-primary btn-lg" :disabled="isValid" type="submit">Submit</button>
      </div>
    </form>
  `
}

if (document.getElementById('attendance')) createApp(Attendance).mount('#attendance')

if (document.getElementById('reservation')) createApp(Reservation).mount('#reservation')