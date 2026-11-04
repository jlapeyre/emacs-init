;; GJL added these holidays

;; Spanish holidays borrowed from Emilio Torres Manzanera
(setq holiday-other-holidays
      '((holiday-fixed 12 8 "La Inmaculada")
        (holiday-fixed 11 1 "Todos los Santos")
        (holiday-fixed 3 19 "San José")
	(holiday-fixed 5 1 "1 de Mayo")
        (holiday-fixed 7 25 "Santiago")
        (holiday-fixed 1 18 "Santo Tomás")
	(holiday-fixed 1 6 "Reyes Magos")
        (holiday-fixed 9 8  "Nuestra Sra. de Covadonga")
	(holiday-fixed 10 12 "El Pilar")
        (holiday-fixed 7 31 "San Ignacio")
        (holiday-fixed 8 15 "Asunción de la Virgen")
	(holiday-fixed 12 6 "Dia de la Constitución")
	;; Catalan holidays
	(holiday-fixed 4 23 "Sant Jordi")
	(holiday-fixed 2 12 "Santa Eulàlia")
	(holiday-fixed 6 23 "Vacaciones local")
	(holiday-fixed 6 23 "Sant Joan")
	(holiday-fixed 6 24 "Sant Joan")
	(holiday-fixed 9 11 "La Diada")
	(holiday-fixed 9 23 "La Mercè")
	(holiday-fixed 10 12 "Dia de Columbus")
	(holiday-fixed 12 26 "San Esteban")))

(setq holiday-hebrew-holidays nil)     ; get rid of religious holidays
(setq holiday-islamic-holidays nil)    ; get rid of religious holidays
(setq holiday-oriental-holidays nil)   ; get rid of Oriental holidays
(setq holiday-bahai-holidays nil)      ; get rid of Baha'i holidays
;; mark dates of holidays in the calendar
(setq calendar-mark-holidays-flag t)
