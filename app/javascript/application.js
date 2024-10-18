// Entry point for the build script in your package.json
//= require rails-ujs
import Rails from "@rails/ujs"
Rails.start()
import "@hotwired/turbo-rails"
import "./controllers"
import * as bootstrap from "bootstrap"
