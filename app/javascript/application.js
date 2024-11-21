// Entry point for the build script in your package.json
//= require rails-ujs
import Rails from "@rails/ujs"
Rails.start()
import "@hotwired/turbo-rails"
import "./controllers"
import * as bootstrap from "bootstrap"

import { Application } from "@hotwired/stimulus"
import { Autocomplete } from 'stimulus-autocomplete' // コンポーネントを読み込むための記述

const application = Application.start()
application.register('autocomplete', Autocomplete) // コンポーネントにあるAutocompleteコントローラを使えるようにするための記述

// Configure Stimulus development experience
application.debug = false
window.Stimulus = application

export { application }