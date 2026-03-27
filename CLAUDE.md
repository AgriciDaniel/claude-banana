# CLAUDE.md -- Development context for banana-claude

This file is read by Claude Code when working inside this repository.

## What this repo is

`banana-claude` is a Claude Code skill that enables AI image generation
using Google's Gemini Nano Banana models via MCP. Claude acts as a Creative
Director: it interprets intent, selects domain expertise, constructs
optimized prompts, and orchestrates Gemini API calls.

## Model status (as of March 2026)

- `gemini-3.1-flash-image-preview` -- **Active default.** Nano Banana 2.
- `gemini-2.5-flash-image` -- **Active.** Nano Banana original. Budget/free tier.
- `gemini-3-pro-image-preview` -- **DEAD.** Shut down March 9, 2026. Do not use.

## How to test changes

1. Install the skill locally: `bash install.sh`
2. Start Claude Code: `claude`
3. Test basic generation: `/banana generate "a red apple on a white table"`
4. Test domain routing: `/banana generate "product shot for headphones"`
5. Test editing: `/banana edit [path] "make the background blurry"`
6. Verify output image files exist at the logged path
7. Check cost log if cost_tracker.py is active

## File responsibilities

| File | Purpose |
|---|---|
| `banana/SKILL.md` | Main orchestrator. Edit to change Claude's behavior. |
| `banana/references/gemini-models.md` | Model roster, routing table, resolution defaults. Update when Google releases new models. |
| `banana/references/prompt-engineering.md` | The prompt construction system. Update when Google publishes new guidance. |
| `banana/references/mcp-tools.md` | API parameter reference. Update when Google changes the API. |
| `banana/scripts/generate.py` | Direct Gemini API fallback for generation. Uses urllib.request (stdlib). |
| `banana/scripts/edit.py` | Direct Gemini API fallback for editing. Uses urllib.request (stdlib). |
| `banana/scripts/replicate_generate.py` | Replicate API fallback for generation. Uses urllib.request (stdlib). |
| `banana/scripts/replicate_edit.py` | Replicate API fallback for editing. Uses urllib.request (stdlib). |
| `banana/references/replicate.md` | Replicate backend reference doc (google/nano-banana-2). |
| `.claude/agents/brief-constructor.md` | Subagent for prompt construction. |

## Scripts use stdlib only

The fallback scripts (`generate.py`, `edit.py`, `replicate_generate.py`,
`replicate_edit.py`) use Python's `urllib.request` to call APIs directly.
They have ZERO pip dependencies by design. Do NOT add `google-genai`,
`requests`, or `replicate` as dependencies -- the stdlib approach ensures
the skill works on any system with Python 3.6+.

## Key constraints

- `imageSize` parameter values must be UPPERCASE: "1K", "2K", "4K". Lowercase fails silently.
- Gemini generates ONE image per API call. There is no batch parameter.
- No negative prompt parameter exists. Use semantic reframing in the prompt.
- `responseModalities` must explicitly include "IMAGE" or the API returns text only.
- NEVER use banned keywords in prompts: "8K", "masterpiece", "ultra-realistic", "high resolution" -- these degrade output quality. Use prestigious context anchors instead (see prompt-engineering.md).
