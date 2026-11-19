# Caucho: Codex Buddy

A personal VS Code extension with a 32-frame pixel-art dog. The animated pet lives in the **Caucho** view in the Explorer, under your files, and cycles through thinking, laptop, dance, and celebration animations while Codex works.

The kit selector switches between the dog's default uniform, Atlético 26/27, Chivas 26/27, and Manchester United 26/27 home shirts. The cap, trousers, reflective bands, and boots stay the same. Your selection is saved between VS Code sessions.

The extension is local-only. It does not call an AI service or need an API key or usage tokens. On Windows, choose **R Mascot: Connect Codex Auto-Sync** once to connect it to Codex lifecycle hooks. The local hook stores only the session ID, event type, timestamp, and working/idle state; it never stores prompt text or transcripts.

## Try it in VS Code

1. Open this repository in VS Code.
2. Press **F5** to open an Extension Development Host window.
3. To show the pet, run **R Mascot: Show Explorer Pet** from the Command Palette. It will appear in the **Caucho** view in Explorer. Run **R Mascot: Hide Explorer Pet** when you want to tuck it away.
4. Use the selector at the top of the pet view to choose the default uniform, Atlético 26/27, Chivas 26/27, or Manchester United 26/27 shirt.
5. Choose **Connect Codex** in the pet view, or run **R Mascot: Connect Codex Auto-Sync** from the Command Palette.
6. In Codex, review and trust the R Mascot hooks using `/hooks`. Restart Codex if the new hooks are not picked up right away.

The pet view stays hidden until you show it yourself. Codex activity still drives the animation whenever the pet is open. You can also use **R Mascot: Start Codex Work Animation**, **R Mascot: Take a Break**, the pet view button, or the status-bar icon for manual control.

Choose **R Mascot: Disconnect Codex Auto-Sync** to remove only the mascot hooks from your Codex `hooks.json`; other hooks are preserved. Codex requires a one-time review and trust of local hooks before they run.

See the [Codex hooks documentation](https://developers.openai.com/codex/hooks) for hook events and trust behavior.

## Install it locally

From this folder, package the extension and install the generated `.vsix`:

```powershell
npx @vscode/vsce package
code --install-extension .\radial-mascot-codex-buddy-0.2.4.vsix
```

Packaging may prompt `npx` to download `@vscode/vsce` if it is not already available. That is the VS Code packaging tool; it is not an API token. You only need Marketplace publisher credentials if you later choose to publish the extension publicly.

## Included files

- `extension.js` — Explorer view, animation player, kit selector, status-bar controls, and Codex auto-sync.
- `media/radial-mascot-atlas.png` — default-uniform 8 by 4 atlas with 32 animation frames.
- `media/radial-mascot-atleti-26-27.png` — Atlético shirt 8 by 4 atlas with matching animation frames.
- `media/radial-mascot-chivas-26-27.png` — Chivas shirt 8 by 4 atlas with matching animation frames.
- `media/radial-mascot-man-utd-26-27.png` — Manchester United shirt 8 by 4 atlas with matching animation frames.
- `media/codex-hook.ps1` — local hook that writes only session state.
- `.vscode/launch.json` — F5 launch configuration.
