#!/usr/bin/env sh
# shellcheck disable=SC2046,SC2086
. ./dot-slash-make.sh

param TAG=nut
param USERNAME=guest
param PASSWORD=guest
script_files=$(wildcard ./*.sh ./make)

set_engine() {
	engine=podman
	command -v "${engine}" >/dev/null || engine=docker
	command -v "${engine}" >/dev/null || abort 'No container engine found. Either Podman or Docker is required to build and run this app'
}

for __target in $(list_targets); do
	case "${__target}" in
	build | -)
		set_engine
		run "${engine}" build -t "${TAG}" .
		;;
	run)
		set_engine
		run "${engine}" run \
			-it --rm \
			--name nut \
			--security-opt=label=disable \
			-p 9000:9000 \
			-v nut-data:/app/titledb:noexec,rw \
			${ROMS_PATH:+--volume="${ROMS_PATH}":/roms:noexec,ro} \
			-e USERNAME="$USERNAME" \
			-e PASSWORD="$PASSWORD" \
			"${TAG}"
		;;
	lint)
		run shellcheck ${script_files}
		run shfmt -d ${script_files}
		;;
	format)
		run shfmt -w ${script_files}
		;;
	# dot-slash-make: This * case must be last and should not be changed
	*) abort "No rule to make target '${__target}'" ;;
	esac
done
