# iVoz development notes

## Project origin

iVoz grew from a desire to dictate directly into everyday Mac apps while keeping speech processing local and allowing optional cleanup of spoken text.

## Initial development

The app uses an AI-assisted development workflow: product choices, coding-agent implementation, hands-on usage, debugging, and source review. The SwiftUI app coordinates AVFoundation recording, WhisperKit/Core ML transcription, optional local LLM cleanup, and macOS text insertion.

## Hands-on usage reported by the creator

iVoz worked very well initially. The creator later experienced lag and stopped using it regularly. The cause and timing of that lag have not been established.

## Source audit — September 30, 2026

The source has clear components for recording, model loading, dictation orchestration, text insertion, settings, and history. Its permissions and local-model dependencies are visible. The audit identified a clipboard restoration edge case, a paste path that could report success when event creation failed, and a Makefile that always used a workaround for one developer machine.

## Improvements in this pass

- Restore an originally empty clipboard and avoid overwriting a clipboard change made during paste.
- Report a paste failure if the required synthetic keyboard events cannot be created.
- Use a standard Xcode build by default; keep the Command Line Tools workaround explicit.
- Explain the build, permissions, architecture, model storage, and current limitations in the README.

## Verification

On September 30, 2026, `make app` completed with the standard Xcode toolchain and produced an arm64 iVoz 1.1.1 app. `codesign --verify --deep --strict` passed, the app bundle was packaged as a ZIP, `git diff --check` passed, and a source scan found no apparent credentials or generated build files tracked in Git. The package has no test target, so no automated application tests ran. The creator's earlier hands-on usage is separate from this source verification. The final 1.1.1 bundle has not yet been smoke-tested by the creator.

## Known limitations

The reported lag is not diagnosed by this pass. Text insertion depends on Accessibility behavior of the target app. Models require an initial download. The app is ad-hoc signed rather than notarized.

## Current status

Portfolio Ready with a verified build and a pending creator smoke test. A new demo recording should follow that hands-on check.
