(defsystem "echo-server"
  :version "0.0.0"
  :author "Rajasegar Chandran"
  :license "MIT"
  :depends-on ("clack"
	       "websocket-driver"
	       "cl-who"
	       "cl-json")
  :components ((:file "app"))
  :description "An echo server using clack and websocket-driver")
