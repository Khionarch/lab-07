status=0

for n in 1 2 3 4; do
	out="Testcase${n}Diff"
	ok=1
	anydiff=0

	for f1 in Testcase$n/*.1.txt; do
		f2="${f1%.1.txt}.2.txt"
		name=$(basename "$f1" .1.txt)
		outfile="$out/${name}Diff.txt"

		if diff -u "$f1" "$f2" > /dev/null; then
			[ -f "$outfile" ] && ok=0
		else
			anydiff=1
			if [ ! -f "$outfile" ]; then
				ok=0
			elif [ "$(diff -u "$f1" "$f2" | tail -n +3)" != "$(tail -n +3 "$outfile")" ]; then
				ok=0
			fi
		fi
	done

	[ "$anydiff" -eq 1 ] && [ ! -d "$out" ] && ok=0
	[ "$anydiff" -eq 0 ] && [ -d "$out" ] && ok=0

	if [ "$ok" -eq 1 ]; then
		echo "Testcase$n: PASS"
	else
		echo "Testcase$n: FAIL"
		status=1
	fi
done

exit $status
