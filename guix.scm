; SPDX-License-Identifier: AGPL-3.0-or-later
;; guix.scm — GNU Guix package definition for canonical-ums
;; Usage: guix shell -f guix.scm

(use-modules (guix packages)
             (guix build-system gnu)
             (guix licenses)
             (gnu packages rust)
             (gnu packages zig)
             (gnu packages rust-apps))

(package
  (name "canonical-ums")
  (version "0.1.0")
  (source #f)
  (build-system gnu-build-system)
  ;; NOTE: idris2 is intentionally not listed here — there is no idris2 (or
  ;; idris) package in upstream Guix as of this writing, so it cannot be
  ;; resolved without a channel/overlay. Install it out-of-band until an
  ;; upstream or third-party Guix package exists.
  (native-inputs
   (list rust zig just))
  (synopsis "Development environment for the canonical Universal Modding Studio")
  (description "Provides toolchains required by canonical-ums, the stable
generalised core of the Universal Modding Studio: Rust crates, Zig FFI,
and Nickel schema generation. Idris2 ABI proofs require a toolchain
installed out-of-band (see NOTE above).")
  (home-page "https://github.com/metadatastician/canonical-ums")
  (license agpl3+))
