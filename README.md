# iVoz

**Private, on-device voice dictation for macOS. Hold a key, speak, release, and your words appear in the app you’re using.**

iVoz is free and open source. There are no subscriptions, activation codes, word limits, accounts, or telemetry. Audio and transcripts stay on your Mac. The speech and cleanup models download once from their model hosts; after that, dictation and cleanup run locally.

## What it does

- Dictates into other Mac apps with a configurable global hotkey.
- Transcribes speech locally with WhisperKit and Core ML on Apple Silicon.
- Optionally cleans up filler words and grammar with a local Qwen model through llama.cpp/Metal.
- Supports English, Spanish, Portuguese, and other Whisper languages.
- Includes custom vocabulary, snippets, searchable history, export, input-device selection, and launch-at-login.
- Uses a clipboard-and-paste strategy to insert text, with clipboard restoration and safeguards for password fields.

## Requirements

- macOS 14 Sonoma or later
- Apple Silicon Mac (M1 or later)
- Xcode 16 or later with the Swift 6.1 toolchain
- About 1.5 GB of free disk space for downloaded models

## Build

```sh
git clone https://github.com/hikaribrandan3-code/ivoz-macos.git
cd ivoz-macos
make app
open dist/iVoz.app
```

The first build downloads Swift package dependencies. The first app launch downloads the speech model; enabling Smart Cleanup downloads its local language model. macOS will ask for microphone and Accessibility permissions so iVoz can capture speech and insert text into other apps.

The Makefile includes a workaround for a known-broken Command Line Tools setup. It writes the helper files under `~/.hikari-swiftpm-libs` and leaves the system toolchain untouched. Developers with a working Xcode installation can use Swift Package Manager directly.

## Download

Prebuilt Apple Silicon app bundles are published on the [GitHub Releases page](https://github.com/hikaribrandan3-code/ivoz-macos/releases). The app is ad-hoc signed, so macOS may ask you to confirm the first launch in Privacy & Security.

## Privacy

iVoz does not send recorded audio or transcripts to a server. Transcriptions, vocabulary, snippets, and settings are stored locally in the app’s Application Support folder. Model files are downloaded from their upstream model repositories when needed.

## License

The iVoz source code is released under the MIT License. Third-party packages keep their own licenses; see their respective repositories for details.

## Project

- Product page: [ivoz.vercel.app](https://ivoz.vercel.app)
- Source and issue tracker: [github.com/hikaribrandan3-code/ivoz-macos](https://github.com/hikaribrandan3-code/ivoz-macos)
