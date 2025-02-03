;; PetSphere - Post Contract

;; Constants
(define-constant err-not-found (err u404))
(define-constant err-unauthorized (err u401))

;; Data structures
(define-map posts 
  uint 
  {
    author: principal,
    content: (string-utf8 1024),
    timestamp: uint,
    likes: uint
  }
)

(define-map post-likes 
  { post-id: uint, user: principal }
  bool
)

(define-data-var post-id-counter uint u0)

;; Public functions
(define-public (create-post (content (string-utf8 1024)))
  (let ((post-id (var-get post-id-counter))
        (post {
          author: tx-sender,
          content: content,
          timestamp: block-height,
          likes: u0
        }))
    (var-set post-id-counter (+ post-id u1))
    (ok (map-set posts post-id post))
  )
)

(define-public (like-post (post-id uint))
  (let ((post (unwrap! (map-get? posts post-id) err-not-found)))
    (if (is-none (map-get? post-likes {post-id: post-id, user: tx-sender}))
      (begin
        (map-set post-likes {post-id: post-id, user: tx-sender} true)
        (ok (map-set posts post-id (merge post {likes: (+ (get likes post) u1)})))
      )
      (ok true)
    )
  )
)

;; Read only functions
(define-read-only (get-post (post-id uint))
  (ok (map-get? posts post-id))
)
