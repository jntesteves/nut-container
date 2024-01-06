#!/usr/bin/env sh
# shellcheck disable=SC2046,SC2086
. ./dot-slash-make.sh

param TAG=nut
param USERNAME=guest
param PASSWORD=guest
script_files=$(wildcard ./*.sh ./make)
engine=podman
command -v "${engine}" >/dev/null || engine=docker

for __target in $(list_targets); do
	case "${__target}" in
	build | -)
		run "${engine}" build -t "${TAG}" .
		;;
	run)
		run "${engine}" run \
			--name nut \
			-it --rm \
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
