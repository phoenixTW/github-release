#!/bin/bash
set -e

function tag_or_release() {
    if [ "$INPUT_TAG_ONLY" = "true" ]; then
        git tag "$1"
        git push origin --tags
    else
        export GITHUB_TOKEN="$INPUT_ACCESS_TOKEN"

        ARGS=()

        # Check draft/pre-release flag
        if [ "$INPUT_DRAFT" = "true" ] && [ "$INPUT_PRERELEASE" = "true" ]; then
            echo "Release can be either 'draft' or 'prerelease', but not both"
            exit 1
        fi

        # Apply draft/pre-release flag
        if [ "$INPUT_DRAFT" = "true" ]; then
            ARGS+=(--draft)
        elif [ "$INPUT_PRERELEASE" = "true" ]; then
            ARGS+=(--prerelease)
        fi

        # Check notes/notes-file input
        if [ -n "$INPUT_NOTES" ] && [ -n "${INPUT_NOTES_FILE}" ]; then
            echo "Notes can be added either using 'notes' or 'notes-file', but not both"
            exit 1
        fi

        # Apply notes/notes-file input
        if [ -n "${INPUT_NOTES}" ]; then
            ARGS+=(--notes "${INPUT_NOTES}")
        elif [ -n "${INPUT_NOTES_FILE}" ]; then
            ARGS+=(--notes-file "${INPUT_NOTES_FILE}")
        elif [ -n "${INPUT_GENERATE_NOTES}" ]; then
            ARGS+=(--generate-notes)
        fi

        if [ -n "${INPUT_GENERATE_NOTES}" ] && [ -n "${INPUT_NOTES_START_TAG}" ]; then
            ARGS+=(--notes-start-tag "${INPUT_NOTES_START_TAG}")
        fi

        ARGS+=(--target "$(git rev-parse HEAD)")

        gh release create "$1" --title "$1" "${ARGS[@]}" ${INPUT_ASSETS}
    fi
}

tag_or_release "$INPUT_TAG"
