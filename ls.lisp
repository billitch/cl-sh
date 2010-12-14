;;
;;  CL-SH  -  Unix Shell in Common Lisp
;;
;;  Copyright 2010 Thomas de Grivel <billitch@gmail.com>
;;
;;  Permission to use, copy, modify, and distribute this software for any
;;  purpose with or without fee is hereby granted, provided that the above
;;  copyright notice and this permission notice appear in all copies.
;;
;;  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
;;  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
;;  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
;;  ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
;;  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
;;  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
;;  OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
;;

(in-package :cl-sh)

(defun ls-one (path recursive)
  (if (probe-file path)
      (with-simple-restart (skip "Skip listing ~A" path)
	(let* ((stat (sb-posix:stat path))
	       (mode (sb-posix:stat-mode stat)))
	  (if (sb-posix:s-isdir mode)
	      (if recursive
		  (mapcan #'ls-r (cl-fad:list-directory path))
		  (cl-fad:list-directory path))
	      (list path))))
      (warn "ls: ~S: No such file or directory" path)))

(defun ls-r (path)
  (ls-one path t))

(defun ls (&rest args)
  (let ((paths (or args '("."))))
    (mapcan (lambda (p)
	      (ls-one p nil))
	    paths)))
