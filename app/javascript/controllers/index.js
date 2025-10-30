// app/javascript/controllers/index.js
import { application } from "./application"

// フォールバック付きで _controller.js をまとめて読み込み
let controllers = {};
try {
  if (typeof import !== 'undefined' && typeof import.meta !== 'undefined' && typeof import.meta.globEager === 'function') {
    // Vite や同等が有効な環境
    controllers = import.meta.globEager("./**/*_controller.js");
  } else if (typeof require === 'function' && typeof require.context === 'function') {
    // Webpack の場合のフォールバック
    const ctx = require.context("./", true, /_controller\.js$/);
    ctx.keys().forEach((key) => { controllers[key] = ctx(key); });
  } else {
    // esbuild / other 環境では自動登録できないので空にして警告
    console.warn('No import.meta.globEager or require.context available; controllers will be empty. Register controllers manually if needed.');
    controllers = {};
  }
} catch (e) {
  console.error('Error initializing controllers via glob fallback:', e);
  controllers = {};
}

// ファイル名からコントローラ名を生成して登録（mod.default がある場合のみ）
Object.entries(controllers).forEach(([path, mod]) => {
  const name = path.split("/").pop().replace(/_controller\.js$/, "");
  if (mod && mod.default) {
    application.register(name, mod.default);
  } else {
    console.warn(`Skipping controller registration for ${name}: module has no default export.`);
  }
});
