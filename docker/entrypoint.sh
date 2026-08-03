#!/bin/bash
set -euo pipefail

# -- Defaults --
RUNNER_DIR="${RUNNER_DIR:-/home/runner/actions-runner}"
GITHUB_URL="${GITHUB_URL:-https://github.com}"
RUNNER_NAME="${RUNNER_NAME:-$(hostname)}"
RUNNER_WORKDIR="${RUNNER_WORKDIR:-/home/runner/_work}"

# -- Cleanup handler --
cleanup() {
    echo "$(date) - Received shutdown signal. Deregistering runner..."
    if [ -f "${RUNNER_DIR}/.runner" ]; then
        if [ -n "${GITHUB_TOKEN:-}" ]; then
            "${RUNNER_DIR}/config.sh" remove --token "${GITHUB_TOKEN}" || \
                echo "$(date) - Warning: Failed to deregister runner"
        fi
    fi
    exit 0
}

trap cleanup SIGTERM SIGINT SIGHUP

cd "${RUNNER_DIR}"

# -- Configure if first run --
if [ ! -f "${RUNNER_DIR}/.runner" ]; then
    if [ -z "${GITHUB_TOKEN:-}" ]; then
        echo "ERROR: GITHUB_TOKEN is required for first-time runner registration"
        echo "Set the GITHUB_TOKEN environment variable and restart the container."
        exit 1
    fi

    echo "$(date) - Configuring runner: ${RUNNER_NAME}"
    echo "$(date) - GitHub URL: ${GITHUB_URL}"

    CONFIG_ARGS=(
        --url "${GITHUB_URL}"
        --token "${GITHUB_TOKEN}"
        --name "${RUNNER_NAME}"
        --work "${RUNNER_WORKDIR}"
        --unattended
        --replace
    )

    [ -n "${RUNNER_LABELS:-}" ] && CONFIG_ARGS+=(--labels "${RUNNER_LABELS}")
    [ -n "${RUNNER_GROUP:-}" ] && CONFIG_ARGS+=(--runnergroup "${RUNNER_GROUP}")
    [ -n "${EPHEMERAL:-}" ] && CONFIG_ARGS+=(--ephemeral)

    ./config.sh "${CONFIG_ARGS[@]}"
    echo "$(date) - Runner configured successfully"
else
    echo "$(date) - Runner already configured. Reusing existing registration."
fi

echo "$(date) - Starting runner..."

if [ -n "${RUNNER_ONCE:-}" ]; then
    exec ./run.sh --once
else
    exec ./run.sh
fi
