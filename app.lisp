(ql:quickload '(:websocket-driver :clack :cl-who :cl-json) :silent t)

(in-package :cl-user)
(defpackage echo-server
  (:use :cl
   :websocket-driver
	:cl-who)
  (:export *echo-handler*))
(in-package :echo-server)

;; set html5 mode
(setf (html-mode) :html5)

  (defun echo-server (env)
    (format t "~a~%" env)
    (cond
      ((string= "/echo" (getf env :request-uri))
       (let ((ws (make-server env)))
         (on :message ws
             (lambda (message)
               (send ws
		     (format nil "<div id='chat-echo-area'>~a</div>" (cdr (car (cl-json:decode-json-from-string message)))))))
         (lambda (responder)
           (declare (ignore responder))
           (start-connection ws))))
      (T
       `(200 (:content-type "text/html")
         (,(with-html-output (*standard-output* nil :indent t :prologue t)
	     (:html
	      (:head
	       (:meta :charset "UTF-8")
	       (:title "LISP Echo Server"))
	      (:body
(:div :hx-ws "connect:/echo" :style "position: fixed; top:20px;"
		     (:div :id "chat-echo-area")
		     (:form :hx-ws "send:submit"
			    (:p (:label :for "txt-message" "Message:" ))
			    (:input :id "txt-message" :name "chat-input" :placeholder "say something")))
	       (:script :src "https://unpkg.com/htmx.org@1.4.1")))))))))


(defvar *echo-handler* (clack:clackup #'echo-server :port 8080))
