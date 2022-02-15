(in-package :net.html.generator)

;; html 5

(def-std-html :section		t nil)
(def-std-html :article		t nil)
(def-std-html :main		t nil)
(def-std-html :aside		t nil)
(def-std-html :hgroup		t nil)
(def-std-html :header		t nil)
(def-std-html :footer		t nil)
(def-std-html :nav		t nil)
(def-std-html :figure		t nil)
(def-std-html :figcaption 	t nil)

(def-std-html :video	 	t nil)
(def-std-html :audio	 	t nil)
(def-std-html :source	 	t nil)
(def-std-html :track	 	t nil)
(def-std-html :embed	 	t nil)
(def-std-html :mark	 	t nil)
(def-std-html :progress	 	t nil)
(def-std-html :meter	 	t nil)
(def-std-html :time	 	t nil)
(def-std-html :data	 	t nil)
(def-std-html :dialog	 	t nil)
(def-std-html :ruby	 	t nil)
(def-std-html :rt	 	t nil)
(def-std-html :rp	 	t nil)
(def-std-html :bdi	 	t nil)
(def-std-html :wbr		nil nil)
(def-std-html :canvas	 	t nil)
(def-std-html :menuitem	 	t nil)
(def-std-html :details	 	t nil)
(def-std-html :datalist	 	t nil)
(def-std-html :keygen	 	nil nil)
(def-std-html :output	 	t nil)

(defpackage :test-js
  (:documentation "Testing Parenscript from AServe.")
  (:use #:cl
	#:net.aserve
	#:acl-compat.excl
	#:net.html.generator
	#:parenscript))

(in-package :test-js)

(publish :path "/home"
	 :content-type "text/html"
	 :function
	 #'(lambda (r e)
	     (with-http-response (r e)
	       (with-http-body (r e)
		 (html
		   (:html (:head (:title "Parenscript Examples"))
		     (:body (:h1 "Parenscript Examples")
			    (:ol (:li ((:a href "/example1") "JS Alert"))
				 (:li ((:a href "/example2") "Adding a Node"))
				 (:li ((:a href "/example3") "Writes a string into the console for the web browser"))
				 (:li ((:a href "/example4") "Validating a JS form")))
			    (:footer "&copy Jason Robinson 2022"))))))))

(publish :path "/example1"
	 :content-type "text/html"
	 :function
	 #'(lambda (r e)
	     (with-http-response (r e)
	       (with-http-body (r e)
		 (html
		   (:html (:head (:title "Parenscript tutorial: 1st example"))
		     (:body ((:a href "/home") "Home")
		      :br
			    (:h2 "Parenscript tutorial: 1st example")
			    "Please click the link below."
			    :br
			    ((:a href "#" onclick (ps (alert "Hello World"))) "Hello World"))))))))

;; Adding a Node with JS in header <script>
(publish :path "/example2"
	 :content-type "text/html"
	 :function
	 #'(lambda (r e)
	     (with-http-response (r e)
	       (with-http-body (r e)
		 (html
		   (:html (:head (:title "Parenscript tutorial: 2nd example")
				 (:script 
				  (ps (defun add-para ()
					(var new-para (chain document (create-element "p")))
					(var new-text (chain document (create-text-node "This paragraph was generated by JS. See page source.")))
					(chain new-para (append-child new-text))
					(chain document body (append-child new-para))))))
		     ((:body onload "addPara()")
		      ((:a href "/home") "Home")
		      (:h2 "Parenscript: 2nd example"))))))))

(publish :path "/example3"
	 :content-type "text/html"
	 :function
	 #'(lambda (r e)
	     (with-http-response (r e)
	       (with-http-body (r e)
		 (html
		   (:html (:head (:title "Parenscript tutorial: 3rd example")
				 (:script 
				  (ps (defun console-msg ()
					(chain window (dump "Message from Window"))
					(chain console (log "Message from Console"))
					t))))
		     ((:body onload "consoleMsg()")
		      ((:a href "/home") "Home")
		      (:h2 "Parenscript: 3rd example")
		      :br "Check the Console.")))))))

;; Validating a JavaScript form
;; Taken from IBM Cloud Developer Lab
(publish :path "/example4"
	 :content-type "text/html"
	 :function
	 #'(lambda (r e)
	     (with-http-response (r e)
	       (with-http-body (r e)
		 (html
		   (:html (:head (:title "Contact Details")
				 ;; Will use CSS-LITE in a future version
				 (:style
				  "body {
background-color: #fefefe;
color: #333333;
margin: 2% 25% 25% 2%;
padding: 0;
font-family: Helvetica, Arial, sans-serif;
}

.row {
margin-top: 5px;
margin-bottom: 5px;
}"))
		     ((:script :type "application/javascript")
		      (ps (defun checkdata ()
			    (var username (chain document (get-element-by-id "name")))
			    (var emailid (chain document (get-element-by-id "email")))
			    (var zipcode (chain document (get-element-by-id "zip")))

			    (return-from checkdata
			      (when (string= (@ username value) "")
				(progn
				  (alert "Please enter the name")
				  (chain username (focus))
				  f)))
			    
			    (return-from checkdata
			      (when (string= (@ emailid value) "")
				(progn
				  (alert "Please enter the email")
				  (chain emailid (focus))
				  f)))
			    
			    (return-from checkdata
			      (when (or  (string= (@ zipcode value) "")
					 (numberp (parse-int)))
				(progn
				  (alert "Please enter the email")
				  (chain emailid (focus))
				  f)))

			    (alert "Form validation is successful")

			    t)))
		     (:body
		      ((:a href "/home") "Home")
		      (:h2 "Parenscript: 4th example")
		      (:h3 "Enter your contact Details: ")
		      ((:form :id "form1"
			      :onsubmit "return checkdata()")
		       ((:div :class "row")
			((:label :for "name") "Name :")
			((:input :type "text"
				 :id "name"
				 :name "name")))
		       ((:div :class "row")
			((:label :for "email") "E-mail ID :")
			((:input :type "text" :id "email" :name "email")))
		       ((:div :class "row")
			((:input :type "submit" :value "Submit"))
			((:input :type "reset" :value "Reset")))))))))))
