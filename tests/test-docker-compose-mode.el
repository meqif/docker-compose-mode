;;; test-docker-compose-mode.el --- Tests for docker-compose-mode -*- lexical-binding: t; -*-

;; Copyright (C) 2017  Ricardo Martins

;; Licensed under the Apache License, Version 2.0 (the "License");
;; you may not use this file except in compliance with the License.
;; You may obtain a copy of the License at
;;
;; http://www.apache.org/licenses/LICENSE-2.0
;;
;; Unless required by applicable law or agreed to in writing, software
;; distributed under the License is distributed on an "AS IS" BASIS,
;; WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
;; See the License for the specific language governing permissions and
;; limitations under the License.

;;; Code:

(require 'docker-compose-mode)

(describe "Function: `docker-compose--prefix'"
  (it "returns the partially written key in the current line"
    (with-temp-buffer
      (insert "version: '2'\nservices:\n  example:\n    underscore_\n    partial")
      ;; move point to after the underscore
      (goto-char 50)
      (expect (docker-compose--prefix) :to-equal '("underscore_" 39 50))))

  (it "returns nil when the key is suffixed with a colon"
    (with-temp-buffer
      (insert "  foo:")
      (goto-char 7)
      (expect (docker-compose--prefix) :to-equal nil))))

(describe "Function: `docker-compose--candidates'"
  (let ((candidates '("aliases" "build" "env_file" "environment")))

    (it "returns nil when no applicable candidates are available"
      (spy-on 'docker-compose--keywords-for-buffer '())
      (expect (docker-compose--candidates "en") :to-equal nil))

    (it "returns all the applicable candidates"
      (spy-on 'docker-compose--keywords-for-buffer :and-return-value candidates)
      (let ((expected-candidates '("env_file" "environment")))
        (expect (docker-compose--candidates "en") :to-equal expected-candidates)))))

(describe "Function: `docker-compose--find-version'"
  (describe "when the version is not specified"
    (it "returns \"1.0\""
      (with-temp-buffer
        (insert "services:\n  foo:\n    build: .\n")
        (expect (docker-compose--find-version) :to-equal "1.0"))))

  (describe "when the version is not surrounded by any quotes"
    (it "returns the version specified by the `version' key"
      (with-temp-buffer
        (insert "version: 2\nservices:\n  foo:\n    build: .\n")
        (expect (docker-compose--find-version) :to-equal "2"))))

  (describe "when the version is surrounded by single quotes"
    (it "returns the version specified by the `version' key"
      (with-temp-buffer
        (insert "version: '2'\nservices:\n  foo:\n    build: .\n")
        (expect (docker-compose--find-version) :to-equal "2"))))

  (describe "when the version is surrounded by double quotes"
    (it "returns the version specified by the `version' key"
      (with-temp-buffer
        (insert "version: \"2\"\nservices:\n  foo:\n    build: .\n")
        (expect (docker-compose--find-version) :to-equal "2"))))

  (describe "when the version contains a major and a minor part"
    (it "returns the major and the minor"
      (with-temp-buffer
        (insert "version: \"3.3\"\nservices:\n  foo:\n    build: .\n")
        (expect (docker-compose--find-version) :to-equal "3.3")))))

(provide 'test-docker-compose-mode)
;;; test-docker-compose-mode.el ends here
