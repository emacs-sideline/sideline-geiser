;;; sideline-geiser.el --- Show Geiser result with sideline  -*- lexical-binding: t; -*-

;; Copyright (C) 2024  Shen, Jen-Chieh

;; Author: Shen, Jen-Chieh <jcs090218@gmail.com>
;; Maintainer: Shen, Jen-Chieh <jcs090218@gmail.com>
;; URL: https://github.com/emacs-sideline/sideline-geiser
;; Version: 0.1.0
;; Package-Requires: ((emacs "28.1") (sideline "0.1.0") (geiser "0.31.1"))
;; Keywords: convenience

;; This file is not part of GNU Emacs.

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program. If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:
;;
;; Show Geiser result with sideline.
;;

;;; Code:

(require 'sideline)

(eval-when-compile
  (require 'geiser)
  (require 'geiser-mode))

(defgroup sideline-geiser nil
  "Show Geiser result with sideline."
  :prefix "sideline-geiser-"
  :group 'tool
  :link '(url-link :tag "Repository" "https://github.com/emacs-sideline/sideline-geiser"))

(defface sideline-geiser-result-overlay-face
  '((((class color) (background light))
     :background "grey90" :box (:line-width -1 :color "yellow"))
    (((class color) (background dark))
     :background "grey10" :box (:line-width -1 :color "black")))
  "Face used to display evaluation results."
  :group 'sideline-racket)

(defvar sideline-geiser--buffer nil
  "Record the evaluation buffer.")

(defvar-local sideline-geiser--callback nil
  "Callback to display result.")

;;;###autoload
(defun sideline-geiser (command)
  "Backend for sideline.

Argument COMMAND is required in sideline backend."
  (cl-case command
    (`candidates (cons :async
                       (lambda (callback &rest _)
                         (setq sideline-geiser--callback callback
                               sideline-geiser--buffer (current-buffer)))))
    (`face 'sideline-geiser-result-overlay-face)))

;;;###autoload
(defun sideline-geiser-show (msg is-error &rest _)
  "Display the result MSG."
  (when (and msg
             sideline-geiser--buffer)
    (with-current-buffer sideline-geiser--buffer
      (funcall sideline-geiser--callback
               (list (format "%s%s"
                             (if is-error "ERROR" "")
                             msg))))))

(provide 'sideline-geiser)
;;; sideline-geiser.el ends here
