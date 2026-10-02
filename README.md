# iVoz

**Private, on-device voice dictation for macOS. Hold a key, speak, release, and your words appear in the app you’re using.**

iVoz is free and open source. There are no subscriptions, activation codes, word limits, accounts, or telemetry. Audio and transcripts stay on your Mac. The speech and cleanup models download once from their model hosts; after that, dictation and cleanup run locally.

I built it to make voice input practical inside the Mac apps I already use, with local processing and control over the final text.

## What it does

- Dictates into other Mac apps with a configurable global hotkey.
- Transcribes speech locally with WhisperKit and Core ML on Apple Silicon.
- Optionally cleans up filler words and grammar with a local Qwen model through llama.cpp/Metal.
- Supports English, Spanish, Portuguese, and other Whisper languages.
- Includes custom vocabulary, snippets, searchable history, export, input-device selection, and launch-at-login.
- Inserts text through Accessibility, simulated typing, or clipboard paste as a fallback. It restores the previous clipboard when it has not changed during the paste and refuses secure input fields.

## Architecture

`DictationController` coordinates recording, WhisperKit transcription, optional local cleanup, snippet expansion, and text insertion. `TextInjector` handles the target app and insertion methods. Settings, vocabulary, snippets, and searchable history are persisted locally. The Swift package pins its resolved dependencies in `Package.resolved`.

## Requirements

- macOS 14 Sonoma or later
- Apple Silicon Mac (M1 or later)
- Xcode 16 or later with the Swift 6.1 toolchain
- Free disk space for downloaded models: roughly 150 MB for the default speech model, with more needed if you choose a larger speech model or optional cleanup model

## Build

```sh
git clone https://github.com/hikaribrandan3-code/ivoz-macos.git
cd ivoz-macos
make app
open dist/iVoz.app
```

The first build downloads Swift package dependencies. The first app launch downloads the speech model; enabling Smart Cleanup downloads its local language model. macOS will ask for microphone and Accessibility permissions so iVoz can capture speech and insert text into other apps.

For the affected developer Command Line Tools installation only, use `make USE_TOOLCHAIN_FIX=1 app`. This creates helper files under `~/.hikari-swiftpm-libs` without changing system files. A normal Xcode installation uses `make app` with no workaround.

## Use

Grant microphone and Accessibility permissions, let the selected speech model finish downloading, then hold the configured hotkey while speaking and release it to transcribe. Smart Cleanup is optional and downloads a separate local model when enabled. Review or export transcripts from History.

## Download

Prebuilt Apple Silicon app bundles are published on the [GitHub Releases page](https://github.com/hikaribrandan3-code/ivoz-macos/releases). The app is ad-hoc signed, so macOS may ask you to confirm the first launch in Privacy & Security.

## Privacy

iVoz does not send recorded audio or transcripts to a server. Transcriptions, vocabulary, snippets, and settings are stored locally in the app’s Application Support folder. Model files are downloaded from their upstream model repositories when needed.

## Current status and limitations

An Apple Silicon release is available. It is ad-hoc signed and not notarized. Dictation into other apps depends on macOS Accessibility behavior and may vary by target app. The creator reports that iVoz worked well initially but later became laggy in regular use; that performance issue has not been diagnosed in this source cleanup.

Development: This project was built through an AI-assisted workflow combining product design, coding-agent implementation, hands-on testing, source review, debugging, and iteration. AI did not independently certify the app.

## License

The iVoz source code is released under the MIT License. Third-party packages keep their own licenses; see their respective repositories for details.

## Project

- Product page: [ivoz-macos-site.vercel.app](https://ivoz-macos-site.vercel.app)
- Source and issue tracker: [github.com/hikaribrandan3-code/ivoz-macos](https://github.com/hikaribrandan3-code/ivoz-macos)

## Portfolio evidence

[Mac app suite case study](https://hikari-brandan.vercel.app/projects/macos-app-suite) documents the product story and current limits.
