#!/bin/sh
set -eu

#region logging setup
if [ "${MISE_DEBUG-}" = "true" ] || [ "${MISE_DEBUG-}" = "1" ]; then
	debug() {
		echo "$@" >&2
	}
else
	debug() {
		:
	}
fi

if [ "${MISE_QUIET-}" = "1" ] || [ "${MISE_QUIET-}" = "true" ]; then
	info() {
		:
	}
else
	info() {
		echo "$@" >&2
	}
fi

error() {
	echo "$@" >&2
	exit 1
}
#endregion

#region environment setup
get_os() {
	os="$(uname -s)"
	if [ "$os" = Darwin ]; then
		echo "macos"
	elif [ "$os" = Linux ]; then
		echo "linux"
	else
		error "unsupported OS: $os"
	fi
}

get_arch() {
	musl=""
	if type ldd >/dev/null 2>/dev/null; then
		libc=$(ldd /bin/ls | grep 'musl' | head -1 | cut -d ' ' -f1)
		if [ -n "$libc" ]; then
			musl="-musl"
		fi
	fi
	arch="$(uname -m)"
	if [ "$arch" = x86_64 ]; then
		echo "x64$musl"
	elif [ "$arch" = aarch64 ] || [ "$arch" = arm64 ]; then
		echo "arm64$musl"
	elif [ "$arch" = armv7l ]; then
		echo "armv7$musl"
	else
		error "unsupported architecture: $arch"
	fi
}

shasum_bin() {
	if command -v shasum >/dev/null 2>&1; then
		echo "shasum"
	elif command -v sha256sum >/dev/null 2>&1; then
		echo "sha256sum"
	else
		error "mise install requires shasum or sha256sum but neither is installed. Aborting."
	fi
}

get_checksum() {
	version=$1
	os="$(get_os)"
	arch="$(get_arch)"
	url="https://github.com/jdx/mise/releases/download/${version}/SHASUMS256.txt"

	# For current version use static checksum otherwize
	# use checksum from releases
	if [ "$version" = "v2024.6.6" ]; then
		checksum_linux_x86_64="74b534481ca05b9462c6373c55056ae5caff9a4c34cdbc1e68285fd9a9a252fc  ./mise-v2024.6.6-linux-x64.tar.gz"
		checksum_linux_x86_64_musl="75e46943fc311330c55e27d243049091766d9e1fcd46408cd8df884354893f73  ./mise-v2024.6.6-linux-x64-musl.tar.gz"
		checksum_linux_arm64="40a53f6548d0341b2c963042b6a362f8411baadf93761874b922caa20955ba7f  ./mise-v2024.6.6-linux-arm64.tar.gz"
		checksum_linux_arm64_musl="332edabbe2c8cd2d19db6ba44ba0e8ff48609d2578cce60a61d8116a8fec86eb  ./mise-v2024.6.6-linux-arm64-musl.tar.gz"
		checksum_linux_armv7="51fb9c06b0beba5a87ed819fbfcc6bae8077c80d441ac1ee3d049b16d14ee7e6  ./mise-v2024.6.6-linux-armv7.tar.gz"
		checksum_linux_armv7_musl="10e704ae030c25d4333407a373b9e1024012424e6e0bcf94c3a19406bd61f66b  ./mise-v2024.6.6-linux-armv7-musl.tar.gz"
		checksum_macos_x86_64="321547336e4eb5033fd80469595e94f0ba0ef5c730413438a53b04275dc181b6  ./mise-v2024.6.6-macos-x64.tar.gz"
		checksum_macos_arm64="d97fd60fcc13bd672bcb95c2f9dcfe484401ae51be5b1a00b09feed5213173d0  ./mise-v2024.6.6-macos-arm64.tar.gz"

		if [ "$os" = "linux" ]; then
			if [ "$arch" = "x64" ]; then
				echo "$checksum_linux_x86_64"
			elif [ "$arch" = "x64-musl" ]; then
				echo "$checksum_linux_x86_64_musl"
			elif [ "$arch" = "arm64" ]; then
				echo "$checksum_linux_arm64"
			elif [ "$arch" = "arm64-musl" ]; then
				echo "$checksum_linux_arm64_musl"
			elif [ "$arch" = "armv7" ]; then
				echo "$checksum_linux_armv7"
			elif [ "$arch" = "armv7-musl" ]; then
				echo "$checksum_linux_armv7_musl"
			else
				warn "no checksum for $os-$arch"
			fi
		elif [ "$os" = "macos" ]; then
			if [ "$arch" = "x64" ]; then
				echo "$checksum_macos_x86_64"
			elif [ "$arch" = "arm64" ]; then
				echo "$checksum_macos_arm64"
			else
				warn "no checksum for $os-$arch"
			fi
		else
			warn "no checksum for $os-$arch"
		fi
	else
		if command -v curl >/dev/null 2>&1; then
			debug ">" curl -fsSL "$url"
			checksums="$(curl -fsSL "$url")"
		else
			if command -v wget >/dev/null 2>&1; then
				debug ">" wget -qO - "$url"
				stderr=$(mktemp)
				checksums="$(wget -qO - "$url")"
			else
				error "mise standalone install specific version requires curl or wget but neither is installed. Aborting."
			fi
		fi

		checksum="$(echo "$checksums" | grep "$os-$arch.tar.gz")"
		if ! echo "$checksum" | grep -Eq "^([0-9a-f]{32}|[0-9a-f]{64})"; then
			warn "no checksum for mise $version and $os-$arch"
		else
			echo "$checksum"
		fi
	fi
}

#endregion

download_file() {
	url="$1"
	filename="$(basename "$url")"
	cache_dir="$(mktemp -d)"
	file="$cache_dir/$filename"

	info "mise: installing mise..."

	if command -v curl >/dev/null 2>&1; then
		debug ">" curl -#fLo "$file" "$url"
		curl -#fLo "$file" "$url"
	else
		if command -v wget >/dev/null 2>&1; then
			debug ">" wget -qO "$file" "$url"
			stderr=$(mktemp)
			wget -O "$file" "$url" >"$stderr" 2>&1 || error "wget failed: $(cat "$stderr")"
		else
			error "mise standalone install requires curl or wget but neither is installed. Aborting."
		fi
	fi

	echo "$file"
}

install_mise() {
	version="${MISE_VERSION:-v2024.6.6}"
	os="$(get_os)"
	arch="$(get_arch)"
	install_path="${MISE_INSTALL_PATH:-$HOME/.local/bin/mise}"
	install_dir="$(dirname "$install_path")"
	tarball_url="https://github.com/jdx/mise/releases/download/${version}/mise-${version}-${os}-${arch}.tar.gz"

	cache_file=$(download_file "$tarball_url")
	debug "mise-setup: tarball=$cache_file"

	debug "validating checksum"
	cd "$(dirname "$cache_file")" && get_checksum "$version" | "$(shasum_bin)" -c >/dev/null

	# extract tarball
	mkdir -p "$install_dir"
	rm -rf "$install_path"
	cd "$(mktemp -d)"
	tar -xzf "$cache_file"
	mv mise/bin/mise "$install_path"
	info "mise: installed successfully to $install_path"
}

after_finish_help() {
	case "${SHELL:-}" in
	*/zsh)
		info "mise: run the following to activate mise in your shell:"
		info "echo \"eval \\\"\\\$($install_path activate zsh)\\\"\" >> \"${ZDOTDIR-$HOME}/.zshrc\""
		info ""
		info "mise: this must be run in order to use mise in the terminal"
		info "mise: run \`mise doctor\` to verify this is setup correctly"
		;;
	*/bash)
		info "mise: run the following to activate mise in your shell:"
		info "echo \"eval \\\"\\\$($install_path activate bash)\\\"\" >> ~/.bashrc"
		info ""
		info "mise: this must be run in order to use mise in the terminal"
		info "mise: run \`mise doctor\` to verify this is setup correctly"
		;;
	*/fish)
		info "mise: run the following to activate mise in your shell:"
		info "echo \"$install_path activate fish | source\" >> ~/.config/fish/config.fish"
		info ""
		info "mise: this must be run in order to use mise in the terminal"
		info "mise: run \`mise doctor\` to verify this is setup correctly"
		;;
	*)
		info "mise: run \`$install_path --help\` to get started"
		;;
	esac
}

install_mise
after_finish_help
