; SPDX-License-Identifier: AGPL-3.0-or-later
;; guix.scm — GNU Guix package definition for canonical-ums
;; Usage: guix shell -f guix.scm

(use-modules (guix packages)
             (guix build-system gnu)
             (guix licenses))

(package
  (name "canonical-ums")
  (version "0.1.0")
  (source #f)
  (build-system gnu-build-system)
  (native-inputs
   (list rust zig just idris2))
  (synopsis "Development environment for the canonical Universal Modding Studio")
  (description "Provides toolchains required by canonical-ums, the stable
generalised core of the Universal Modding Studio: Rust crates, Zig FFI,
Idris2 ABI proofs and Nickel schema generation.")
  (home-page "https://github.com/metadatastician/canonical-ums")
  (license agpl3+))
