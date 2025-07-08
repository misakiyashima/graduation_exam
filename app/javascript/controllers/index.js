// app/javascript/controllers/index.js
import { application } from "./application"

// import.meta.globEager で _controller.js をまとめて読み込み
const controllers = import.meta.globEager("./**/*_controller.js")

// ファイル名からコントローラ名を生成して登録
Object.entries(controllers).forEach(([path, mod]) => {
  // "./hello_controller.js" → "hello"
  const name = path
    .split("/")
    .pop()
    .replace(/_controller\.js$/, "")
  application.register(name, mod.default)
})
