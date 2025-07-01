
	' Init display
	width 80
	palette 0, 0  	' black background
	palette 9, 27	' cyan text

	' Reset machine on BREAK
	on brk goto 3000

	' Define guitar tuning
	dim s$(6)
	for i = 1 to 6
		read s$(i)
	next i
	data "E F F#G G#A A#B C C#D D#E " ' Low E string
	data "A A#B C C#D D#E F F#G G#A " ' A string
	data "D D#E F F#G G#A A#B C C#D " ' D string
	data "G G#A A#B C C#D D#E F F#G " ' G string
	data "B C C#D D#E F F#G G#A A#B " ' B string
	data "E F F#G G#A A#B C C#D D#E " ' High E string

	' Two octaves worth of notes
	o$ = "E F F#G G#A A#B C C#D D#E F F#G G#A A#B C C#D D# E "

	' Define intervals and chord qualities
	dim i$(8), q$(8)
	for i = 1 to 8
		read i$(i), q$(i)
	next i

	' Semitone intervals / Chord qualities
	data "047", " "		' major
	data "037", "m"		' minor
	data "047A", "7"	' seventh
	data "037A", "m7"	' minor seventh
	data "047B", "maj7"	' major seventh
	data "057A", "7sus4"	' seventh suspended 4th
	data "057",  "sus4"	' suspended 4nd (sometimes written just "sus")
	data "027",  "sus2"	' suspended 2nd

	' User input
10	print
	print "Chord";
	input a$

	' Display chord diagram
	print
	print "E  A  D  G  B  A"
	print "+--+--+--+--+--+"
	for i = 1 to 5

		' Display six strings
		print "!  !  !  !  !  !"
		for s = 1 to 6
			f = val(mid$(a$, s, 1))
			if f = i then
				print "O";
			else
				print "!";
			end if
			print "  ";
		next s
		print
		print "+--+--+--+--+--+"

	next i

	' What notes are in this chord?
	c$ = ""
	r$ = ""
	for s = 1 to 6

		' Ignore muted strings
		s$ = mid$(a$, s, 1)
		if s$ = "X" then
			goto 20
		end if

		' Note for this string
		f = val(mid$(a$, s, 1))
		n$ = mid$(s$(s), f * 2 + 1, 2)
		t$ = n$
		if right$(n$, 1) = " " then
			n$ = left$(n$, 1)
		end if

		' Don't show duplicated notes
		if instr(c$ + " ", n$ + " ") = 0 then
			c$ = c$ + n$ + " "
			r$ = r$ + t$
		end if
20	next s

	' Now we know the notes in the chord
	print
	print "Notes: "; c$
	print

	' Try each note as the root
	f$ = "Unknown"
	for i = 1 to len(r$) step 2
		t$ = mid$(r$, i, 2)
		r = int(instr(o$, t$) / 2)

		' Find the root and the intervals
		i$ = ""
		for n = 0 to 11
			n$ = mid$(o$, (r + n) * 2 + 1, 2)
			for j = 1 to len(r$) step 2
				if n$ = mid$(r$, j, 2) then
					i$ = i$ + hex$(n)
				end if
			next j
		next n

		' Now, which chord is that?
		q$ = ""
		for k = 1 to 8
			if i$(k) = i$ then
				q$ = q$(k)
			end if
		next k

		' Did we find anything?
		if right$(t$, 1) = " " then
			t$ = left$(t$, 1)
		end if
		if q$ <> "" then
			f$ = t$ + q$
		end if

	next i

	' Display the chord
	print f$

100	goto 10

	' Reset the machine
3000	poke &h71, 0
	exec &h8c1b
