#!/bin/bash

if [ ! -f big_file.bin ]; then
	./create_big_file
fi

rm results_syscall.txt
touch results_syscall.txt
mkdir -p syscall
for i in 1024
do
	rm data.txt
	touch data.txt
	for j in $(seq 1 5)
	do
		echo -n "."
		sudo sh -c 'sync; echo 3 > /proc/sys/vm/drop_caches'
		{ time ./io_system_call $i < big_file.bin >/dev/null ; } 2>>data.txt >/dev/null
	done
	
	grep '^user' data.txt | awk '{gsub(",", ".", $2); split($2, a, "m"); split($2, a, "m"); sec = a[1]*60 + a[2]; print sec}' > syscall/usr_times_$i.txt
	grep '^real' data.txt | awk '{gsub(",", ".", $2); split($2, a, "m"); split($2, a, "m"); sec = a[1]*60 + a[2]; print sec}' > syscall/real_times_$i.txt
	grep '^sys' data.txt | awk '{gsub(",", ".", $2); split($2, a, "m"); split($2, a, "m"); sec = a[1]*60 + a[2]; print sec}' > syscall/sys_times_$i.txt

	echo "Done $i"
done
echo "All done"
