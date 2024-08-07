;; This buffer is for text that is not saved, and for Lisp evaluation.
;; To create a file, visit it with <open> and enter text in its buffer.

(require 'ob-python)
(require 'ob-clojure)

(org-version) "9.0.9"
(emacs-version)"GNU Emacs 25.3.1 (x86_64-pc-linux-gnu, GTK+ Version 3.22.30)
 of 2018-05-09"

(nth 2 '(1 2 3 4 5))

(parse-time-string "1973-09-05 21:00:00") 
(0 0 21 5 9 1973 nil nil nil)

(apply 'encode-time (parse-time-string "1973-09-05 21:00:00"))
(1771 42944)

(1771 42944)

(format-time-string "<%Y-%m-%d %a>" (apply 'encode-time (parse-time-string "1973-09-05 21:00:00"))) 
"<1973-09-05 Wed>"

(format-time-string "<%Y-%m-%d %a %H:%M>"
                    (apply 'encode-time (parse-time-string "1973-09-05 21:00:00")))
"<1973-09-05 Wed 21:00>"


(org-parse-time-string "1973-09-05 21:00:00")

(0 0 21 5 9 1973 nil nil nil)
(0 0 21 5 9 1973 nil nil nil)

(defconst org-time-stamp-formats '("<%Y-%m-%d %a>" . "<%Y-%m-%d %a %H:%M>")
  "Formats for `format-time-string' which are used for time stamps.")

(current-time)

(23809 8236 484519 937000)
(23183 4174 860738 824000)

(0 0 21 5 9 1973 nil nil nil)

(nil nil nil 5 9 1973 nil nil nil)





