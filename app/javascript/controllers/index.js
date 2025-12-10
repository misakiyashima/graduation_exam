// app/javascript/controllers/index.js
import { application } from "./application"

// 各コントローラを個別に import
import AutocompleteController from "stimulus-autocomplete"
// 他のコントローラも必要に応じて import
// import HelloController from "./hello_controller"

application.register("autocomplete", AutocompleteController)
// application.register("hello", HelloController)
