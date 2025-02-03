;; PetSphere - Pet Profile Contract

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-not-found (err u404))
(define-constant err-already-exists (err u409))

;; Data structures
(define-map pet-profiles
  principal
  {
    name: (string-utf8 64),
    species: (string-utf8 32),
    birth-date: uint,
    registration-date: uint
  }
)

;; Public functions
(define-public (register-pet (name (string-utf8 64)) (species (string-utf8 32)) (birth-date uint))
  (let ((profile {
    name: name,
    species: species,
    birth-date: birth-date,
    registration-date: block-height
  }))
    (if (is-none (map-get? pet-profiles tx-sender))
      (ok (map-set pet-profiles tx-sender profile))
      err-already-exists
    )
  )
)

(define-public (update-pet (name (string-utf8 64)) (species (string-utf8 32)) (birth-date uint))
  (if (is-some (map-get? pet-profiles tx-sender))
    (ok (map-set pet-profiles tx-sender {
      name: name,
      species: species, 
      birth-date: birth-date,
      registration-date: (get registration-date (unwrap-panic (map-get? pet-profiles tx-sender)))
    }))
    err-not-found
  )
)

;; Read only functions
(define-read-only (get-pet-profile (owner principal))
  (ok (map-get? pet-profiles owner))
)
